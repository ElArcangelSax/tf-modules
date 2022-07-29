variable "name" {
  description = "Name of the cluster"
  type = string
  default = ""  
}
variable "team" {
  description = "Team"
  type = string
  default = ""
}
variable "env" {
  description = "Environment"
  type = string
  default = ""
}
variable "vpc_id" {
  description = "VPC ID"
  type = string
  default = ""
}
variable subnets_ids{
  description = "A list of subnets IDS"
  type = list(string)
  default = [""]
}

variable "instance_class" {
  description = "Type of the instance"
  type = string
  default = "db.t3.medium"
  
}
variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}

variable "hosted_zone" {
  description = "Hosted zone ID"
  type        = string
  default     = ""
  
}
variable "engine" {
  description = "The name of the database engine to be used for this DB cluster."
  type        = string
  default     = "aurora-mysql"
}
variable "parameter_group" {
  description = "A map of standar parameters"
  type        = list(map(string))
  default = [
    {
      apply_method = "pending-reboot"
      name         = "slow_query_log"
      value        = "1"
    },
    {
      apply_method = "pending-reboot"
      name         = "log_bin_trust_function_creators"
      value        = "1"
    },
    {
      apply_method = "pending-reboot"
      name         = "server_audit_events"
      value        = "connect,query,table"
    },
    {
      apply_method = "pending-reboot"
      name         = "server_audit_logging"
      value        = "1"
    },
    {
      apply_method = "pending-reboot"
      name         = "binlog_format"
      value        = "ROW"
    }
  ]

}
variable "engine_mode" {
  description = "The database engine mode."
  type        = string
  default     = "provisioned"
}
variable "hosted_zone_name" {
  description = "Hosted zone name"
  type        = string
  default     = ""
  
}
