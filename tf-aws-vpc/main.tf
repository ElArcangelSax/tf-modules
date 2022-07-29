module "vpc" {
  source = "../terraform-aws-vpc.git?ref=v3.13.0"
  create_vpc           = var.create_vpc
  name                 = var.name
  cidr                 = var.cidr_block
  azs                  = var.azs
  private_subnets      = var.private_subnets_cidr
  private_subnet_tags  = var.private_subnet_tags
  public_subnets       = var.public_subnets_cidr
  public_subnet_tags   = var.public_subnet_tags
  database_subnets     = var.database_subnets_cidr
  database_subnet_tags = var.database_subnet_tags
  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment" {
  transit_gateway_id = var.tgw_gtw_id
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  dns_support        = var.enable_dns_support
  ipv6_support       = var.enable_ipv6_support

}

resource "aws_route" "private_tgw_gateway" {
  count = var.create_vpc && var.enable_tgw_gateway ? length(var.private_subnets_cidr) : 0

  route_table_id         = element(module.vpc.private_route_table_ids, count.index)
  destination_cidr_block = var.tgw_gateway_destination_cidr_block
  transit_gateway_id     = var.tgw_gtw_id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "persistence_tgw_gateway" {
  count = var.create_vpc && var.enable_tgw_gateway ? length(var.database_subnets_cidr) : 0

  route_table_id         = element(module.vpc.database_route_table_ids, count.index)
  destination_cidr_block = var.tgw_gateway_destination_cidr_block
  transit_gateway_id     = var.tgw_gtw_id

  timeouts {
    create = "5m"
  }
}
