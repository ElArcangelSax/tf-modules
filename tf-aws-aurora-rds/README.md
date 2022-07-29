<p align="center"> </p>

<h1 align="center">
    Terraform Module Aurora-RDS
</h1>

### Example
```hcl
module "rds" {

  source	      = "../terraform-modules/tf-aws-aurora-rds.git?ref=v1.0.2"
  name                = "test-rds"
  env                 = "dev"
  team                = "cloudops"
  subnets_ids         = ["subnet-0d4fbdbaa29116b9f","subnet-0edbad760e6023f57"]
  vpc_id              = "vpc-078589e76825c943c"
  hosted_zone         = "Z01025523JRBPKNSRJWA8"
  instance_class      = "db.t3.medium"
  allowed_cidr_blocks = ["192.168.254.0/24"]
  hosted_zone_name    = var.hosted_zone_name


}
```
## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
|name|Nombre de la RDS|`string`|`null`|
|vpc_id|Id de la VPC|`string`|`null`|
|hosted_zone|Hosted zone ID|`string`|`null`|
|subnets_ids|Id de las subnets|`list(string)`|`null`|
|env|Environment|`string`|`null`
|instance_class|Tipo de instancia|`string`|`db.t3.medium`|
|allowed_cidr_blocks|Cidr habilitados en el security group|`string`|`null`|
|hosted_zone_name|Nombre del hosted zone|`string`|`null`|
### Record name
<p>El record name creado es "nombre_rds.nombre_hosted_zone"</p>
Ejemplo-->"test-rds.dev.internal"

### Consideraciones
Se pueden modificar todas las variables que están en el archivo variables.tf, las mencionadas arriba son para garantizar el despliegue
