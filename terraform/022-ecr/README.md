# 022-ecr - EC2 Container Service Image Repository
This module is used to create ECR image repositories for ECS services

# Deprecation notice

This module will be removed in the next major version. The resources will be moved to their respective service
workspaces:

| Repository    | Workspace         |
|---------------|-------------------|
| id-broker     | 040-id-broker     |
| pw-api        | 050-pw-manager    |
| simplesamlphp | 060-simplesamlphp |
| id-sync       | (obsolete)        |

## What this does

 - Create ECR repositories for id-broker, pw-manager, simplesamlphp, and id-sync
 - Attach ECR policy to allow appropriate access

## Required Inputs

 - `repo_name` - Name of repo, ex: Doorman, IdP, etc.
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `ecsInstanceRole_arn` - ARN for ECS Instance Role
 - `cd_user_arn` - ARN for an IAM user used by a Continuous Delivery service for pushing Docker images

## Outputs

 - `ecr_repo_idbroker` - The repository url for id-broker. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/id-broker-environment`
 - `ecr_repo_pwapi` - The repository url for pw-api. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/pw-api-environment`
 - `ecr_repo_simplesamlphp` - The repository url for simplesamlphp. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/simplesamlphp-environment`
 - `ecr_repo_idsync` - The repository url for id-sync. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/idp-name/id-sync-environment`

## Usage Example

```hcl
module "ecr" {
  source              = "github.com/silinternational/idp-in-a-box//terraform/022-ecr"
  idp_name            = var.idp_name
  ecsInstanceRole_arn = data.terraform_remote_state.core.ecsInstanceRole_arn
  ecsServiceRole_arn  = data.terraform_remote_state.core.ecsServiceRole_arn
  cd_user_arn         = data.terraform_remote_state.core.cduser_arn
}
```
