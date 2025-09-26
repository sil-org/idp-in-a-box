# 000-core - Core setup: IAM users, ECS cluster
This module is used to create an ECS cluster along with the necessary
IAM roles to function. It can also optionally create an ACM certificate
used by later workspaces for HTTPS with the ALB.

## What this does

 - Create ECS cluster named after `app_name` and `app_env`
 - Create IAM roles and policies for ECS services and instances
 - Optionally create and validate an ACM certificate using DNS
 - Optionally manage AppConfig application and environment

## Required Inputs

 - `cluster_name` - Name of ECS cluster, typically the app name (e.g.: "idp-acme") and app env (e.g.: "prod") separated by a hyphen.
 - `cert_domain` - The TLD for the certificate domain.

## Optional Inputs

 - `create_acm_cert` - Set to true if an ACM certificate is needed. Default: `false`
 - `create_cd_user` - Set to false if an IAM user for continuous deployment is not needed. Default: `true`
 - `app_env` - The abbreviated version of the environment used for naming resources, typically either stg or prod. Default: 'prod'
 - `appconfig_app_name` - DEPRECATED - The application name in AppConfig. If not specified, no AppConfig resources will be created."

## Outputs

 - `cduser_access_key_id` - AWS access key id for continuous delivery user
 - `cduser_access_key_secret` - AWS access key secret for continuous delivery user
 - `cduser_arn` - ARN for continuous delivery IAM user
 - `cduser_username` - Username for contiuous delivery IAM user
 - `ecs_ami_id` - The ID for the latest ECS optimized AMI
 - `ecs_cluster_id` - The ECS cluster ID
 - `ecs_cluster_name` - The ECS cluster name
 - `ecs_instance_profile_id` - The ID for created IAM profile `ecsInstanceProfile`
 - `ecsInstanceRole_arn` - The ARN for created IAM role `ecsInstanceRole`
 - `ecsServiceRole_arn` - The ID for created IAM role `ecsServiceRole`


## Usage Example

```hcl
module "core" {
  source           = "github.com/silinternational/idp-in-a-box//terraform/000-core"
  app_name         = var.app_name
  app_env          = var.app_env
  cert_domain      = var.cert_domain
  create_acm_cert  = var.create_acm_cert
}
```
