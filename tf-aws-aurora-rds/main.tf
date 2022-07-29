resource "aws_db_parameter_group" "parameter_group" {
  name        = format("%s-parameter-group", lower(var.name))
  family      = "aurora-mysql5.7"
  description = "Parameter group for RDS"
  tags = {
    Owner       = var.team
    Environment = var.env
    Terraform   = true
  }
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group" {
  name        = format("%s-cluster-prameter-group", lower(var.name))
  family      = "aurora-mysql5.7"
  description = "Cluster parameter group for RDS"
  dynamic "parameter" {
    for_each = var.parameter_group
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
}

resource "random_password" "master_password" {
  count  = 2
  length = 10
}

resource "aws_secretsmanager_secret" "RDS-Credentials" {
  name                    = format("%s-secret-rds", lower(var.name))
  description             = "Credentials for RDS"
  recovery_window_in_days = 7
  depends_on = [
    aws_route53_record.cluster_record
  ]
  tags = {
    "Service" = "RDS"
    "urlFriendly" = format("%s.%s",lower(var.name),lower(var.hosted_zone_name))
  }
}

resource "aws_secretsmanager_secret_version" "user_data" {
  secret_id = aws_secretsmanager_secret.RDS-Credentials.id
  secret_string = jsonencode(
    merge(
      tomap({ "master_username" = "admin" }),
      tomap({ "master_password" = random_password.master_password[0].result }),
      tomap({ "app_username" = format("%s-app", lower(var.name)) }),
    tomap({ "app_password" = random_password.master_password[1].result }))
  )
  lifecycle {
    create_before_destroy = true
  }
}

module "rds" {
     source = "../terraform-aws-rds-aurora.git?ref=v6.1.3"

  name                    = format("%s-rds", lower(var.name))
  engine                  = var.engine
  master_username         = "admin"
  master_password         = random_password.master_password[0].result
  storage_encrypted       = true
  apply_immediately       = true
  create_security_group   = true
  create_monitoring_role  = false
  create_random_password  = false
  allowed_cidr_blocks     = var.allowed_cidr_blocks
  backup_retention_period = var.env == "prod" ? 35 : 7

  vpc_id  = var.vpc_id
  subnets = var.subnets_ids
  instances = {
    1 = {
      instance_class = var.instance_class
    }
    2 = {
      instance_class = var.instance_class
    }

  }

  db_parameter_group_name         = aws_db_parameter_group.parameter_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster_parameter_group.name

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}

resource "aws_route53_record" "cluster_record" {
   depends_on = [
     module.rds
   ]
  zone_id = var.hosted_zone 
  name    = var.name
  type    = "CNAME"
  ttl     = "60"
  records = [module.rds.cluster_endpoint]
}
