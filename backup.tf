module "backup" {
  source      = "../../modules/backup"
  name        = "epam-leodorov-efs"
  environment = "learning"

  enable_backup_region_settings = true
  backup_region_settings_resource_type_opt_in_preference = {
    "DynamoDB"        = false
    "Aurora"          = false
    "EBS"             = false
    "EC2"             = false
    "EFS"             = true
    "FSx"             = false
    "RDS"             = false
    "Storage Gateway" = false
  }

  # AWS Backup vault
  enable_backup_vault      = true
  backup_vault_name        = "efs-vault"
  backup_vault_kms_key_arn = module.kms.kms_key_arn

  # AWS Backup plan
  enable_backup_plan = true
  backup_plan_name   = "efs-plan"
  backup_plan_rule = [{
    rule_name = "bkp-rule-1"
    schedule  = "cron(0 23 * * ? *)"
  }]

  # AWS backup selection
  enable_backup_selection       = true
  backup_selection_name         = ""
  backup_selection_iam_role_arn = module.iam_role.iam_role_arn
  backup_selection_resources    = [module.efs.efs_file_system_arn]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.iam_role,
    module.kms,
    module.efs
  ]

}