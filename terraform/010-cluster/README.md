# 010-cluster - Cluster setup
This module is used to setup the cluster with VPC, security groups, auto-scaling group,
ssl certificate, core application load balancer, and a CloudWatch log group

## What this does

 - Create VPC named after `app_name` and `app_env`
 - Create security group to allow traffic from Cloudflare IPs
 - Create auto scaling group of defined size and distribute instances across `aws_zones`
 - Locate ACM certificate for use in ALB listeners
 - Create application load balancer (ALB)
 - Create CloudWatch log group

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: prod, test, etc.
 - `aws_instance` - A map containing keys for `instance_type`, `volume_size`, `instance_count`
 - `aws_region` - A string with region to deploy in, example: `us-east-1`
 - `aws_zones` - A list of availability zones to distribute instances across, example: `["us-east-1a", "us-east-1b", "us-east-1c"]`
 - `cert_domain_name` - Domain name for certificate, example: `*.mydomain.com`
 - `ecs_cluster_name` - ECS cluster name for registering instances
 - `ecs_instance_profile_id` - IAM profile ID for ecsInstanceProfile
 - `idp_name` - Name of the IDP (all lowercase, no spaces), example: `acme`

## Optional Inputs

- `aws_region_secondary` - A string with a secondary region to deploy in, example: `us-east-1`
- `aws_zones_secondary` -  A list of availability zones to distribute secondary instances across, example: `["us-east-1a", "us-east-1b", "us-east-1c"]`


## Outputs

 - `aws_zones` - The list of zones deployed in
 - `aws_zones_secondary` - The list of secondary zones deployed in
 - `cloudflare_sg_id` - Security group ID for Cloudflare HTTPS access
 - `cloudflare_sg_id_secondary` - Secondary security group ID for Cloudflare HTTPS access
 - `db_subnet_group_name` - Database subnet group name
 - `db_subnet_group_name_secondary` - Secondary database subnet group name
 - `nat_gateway_ip` - NAT gateway elastic IP address
 - `nat_gateway_ip_secondary` - Secondary NAT gateway elastic IP address
 - `private_subnet_cidr_blocks` - A list of private subnet CIDR blocks, ex: `["10.0.11.0/24","10.0.22.0/24"]`
 - `private_subnet_cidr_blocks_secondary` - A list of secondary private subnet CIDR blocks, ex: `["10.0.11.0/24","10.0.22.0/24"]`
 - `private_subnet_ids` - List of private subnet ids in VPC
 - `private_subnet_ids_secondary` - List of secondary private subnet ids in VPC
 - `public_subnet_cidr_blocks` - A list of public subnet CIDR blocks, ex: `["10.0.10.0/24","10.0.12.0/24"]`
 - `public_subnet_cidr_blocks_secondary` - A list of secondary public subnet CIDR blocks, ex: `["10.0.10.0/24","10.0.12.0/24"]`
 - `public_subnet_ids` - List of public subnet ids in VPC
 - `public_subnet_ids_secondary` - List of secondary public subnet ids in VPC
 - `vpc_default_sg_id` - The default security group ID for the VPC
 - `vpc_default_sg_id_secondary` - The default security group ID for the secondary VPC
 - `vpc_id` - ID for the VPC
 - `vpc_id_secondary` - ID for the secondary VPC
 - `alb_arn` - ARN for application load balancer
 - `alb_arn_secondary` - ARN for secondary application load balancer
 - `alb_default_tg_arn` - ARN for default target group on load balancer
 - `alb_default_tg_arn_secondary` - ARN for default target group on secondary load balancer
 - `alb_dns_name` - DNS name for ALB
 - `alb_dns_name_secondary` - DNS name for secondary ALB
 - `alb_https_listener_arn` - ARN for HTTPS listener on ALB
 - `alb_https_listener_arn_secondary` - ARN for HTTPS listener on secondary ALB
 - `alb_id` - ID for ALB
 - `alb_id_secondary` - ID for secondary ALB
 - `wildcard_cert_arn` - ARN to wildcard ACM certificate
 - `cloudwatch_log_group_name` - Name of the CloudWatch log group
 - `cloudwatch_log_group_name_secondary` - Name of the secondary CloudWatch log group
 
## Example Usage

```hcl
module "cluster" {
  source                  = "github.com/silinternational/idp-in-a-box//terraform/010-cluster"
  app_name                = var.app_name
  app_env                 = var.app_env
  aws_instance            = var.aws_instance
  aws_region              = var.aws_region
  aws_zones               = var.aws_zones
  cert_domain_name        = var.cert_domain_name
  ecs_cluster_name        = data.terraform_remote_state.core.ecs_cluster_name
  ecs_instance_profile_id = data.terraform_remote_state.core.ecs_instance_profile_id
  idp_name                = var.idp_name
}
```
