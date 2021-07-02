module "kms" {
  source = "../../modules/kms"

  name        = "epam-leodorov-efs"
  environment = "learning"

  # KMS key
  enable_kms_key                  = true
  kms_key_name                    = "kms_backup"
  kms_key_deletion_window_in_days = 30

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

}