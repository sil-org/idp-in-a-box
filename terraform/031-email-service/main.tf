/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "email" {
  name                 = substr("tg-${var.idp_name}-${var.app_name}-${var.app_env}", 0, 32)
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = "30"

  health_check {
    path    = "/site/status"
    matcher = "200,204"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "email" {
  listener_arn = var.internal_alb_listener_arn
  priority     = "31"

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.email.arn
  }

  condition {
    host_header {
      values = ["${var.subdomain}.${var.cloudflare_domain}"]
    }
  }
}

/*
 * Generate access tokens for consuming apps
 */
resource "random_id" "access_token_pwmanager" {
  byte_length = 16
}

resource "random_id" "access_token_idbroker" {
  byte_length = 16
}

resource "random_id" "access_token_idsync" {
  byte_length = 16
}

/*
 * Create ECS services
 */
locals {
  task_def_api = templatefile("${path.module}/task-definition-api.json", {
    api_access_keys           = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                   = var.app_env
    app_name                  = var.app_name
    aws_region                = var.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    cpu_api                   = var.cpu_api
    db_name                   = var.db_name
    docker_image              = var.docker_image
    email_brand_color         = var.email_brand_color
    email_brand_logo          = var.email_brand_logo
    email_queue_batch_size    = var.email_queue_batch_size
    from_email                = var.from_email
    idp_name                  = var.idp_name
    mailer_host               = var.mailer_host
    mailer_password           = var.mailer_password
    mailer_usefiles           = var.mailer_usefiles
    mailer_username           = var.mailer_username
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory_api                = var.memory_api
    notification_email        = var.notification_email
  })
}

module "ecsservice_api" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=8.1.0"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}-api"
  service_env        = var.app_env
  ecsServiceRole_arn = var.ecsServiceRole_arn
  container_def_json = local.task_def_api
  desired_count      = var.desired_count_api
  tg_arn             = aws_alb_target_group.email.arn
  lb_container_name  = "api"
  lb_container_port  = "80"
}

locals {
  task_def_cron = templatefile("${path.module}/task-definition-cron.json", {
    api_access_keys           = "${random_id.access_token_pwmanager.hex},${random_id.access_token_idbroker.hex},${random_id.access_token_idsync.hex}"
    app_env                   = var.app_env
    app_name                  = var.app_name
    aws_region                = var.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    cpu_cron                  = var.cpu_cron
    db_name                   = var.db_name
    docker_image              = var.docker_image
    email_brand_color         = var.email_brand_color
    email_brand_logo          = var.email_brand_logo
    email_queue_batch_size    = var.email_queue_batch_size
    from_email                = var.from_email
    idp_name                  = var.idp_name
    mailer_host               = var.mailer_host
    mailer_password           = var.mailer_password
    mailer_usefiles           = var.mailer_usefiles
    mailer_username           = var.mailer_username
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory_cron               = var.memory_cron
    notification_email        = var.notification_email
  })
}

module "ecsservice_cron" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-no-alb?ref=8.1.0"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}-cron"
  service_env        = var.app_env
  container_def_json = local.task_def_cron
  desired_count      = 1
}

/*
 * Create Cloudflare DNS record
 */
resource "cloudflare_record" "emaildns" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.subdomain
  value   = var.internal_alb_dns_name
  type    = "CNAME"
  proxied = false
}

data "cloudflare_zones" "domain" {
  filter {
    name        = var.cloudflare_domain
    lookup_type = "exact"
    status      = "active"
  }
}
