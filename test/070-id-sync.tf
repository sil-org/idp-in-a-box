module "sync" {
  source = "../terraform/070-id-sync"

  alerts_email                 = ""
  allow_empty_email            = ""
  app_env                      = ""
  app_name                     = ""
  cloudwatch_log_group_name    = ""
  cpu                          = ""
  docker_image                 = ""
  ecs_cluster_id               = ""
  enable_new_user_notification = ""
  enable_sync                  = true
  event_schedule               = ""
  id_broker_access_token       = ""
  id_broker_adapter            = ""
  id_broker_assertValidIp      = ""
  id_broker_base_url           = ""
  id_broker_trustedIpRanges    = [""]
  id_store_adapter             = ""
  id_store_config              = { a = "b" }
  idp_display_name             = ""
  idp_name                     = ""
  memory                       = ""
  notifier_email_to            = ""
  sync_safety_cutoff           = ""
}
