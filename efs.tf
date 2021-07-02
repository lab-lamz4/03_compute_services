module "efs" {
  source      = "../../modules/efs"
  name        = "epam-leodorov-efs"
  environment = "learning"

  # EFS FS
  enable_efs_file_system           = true
  efs_file_system_name             = "web-data"
  efs_file_system_encrypted        = false
  efs_file_system_kms_key_id       = ""
  efs_file_system_performance_mode = "generalPurpose"
  efs_file_system_throughput_mode  = "bursting"

  # Infrequent Access (IA) storage class.
  efs_file_system_lifecycle_policy = [
    {
      transition_to_ia = "AFTER_90_DAYS"
    }
  ]

  # EFS mount target
  enable_efs_mount_target          = true
  efs_mount_target_subnet_ids      = [
    lookup(local.public_az, "us-east-1a"),
    lookup(local.public_az, "us-east-1b"),
    lookup(local.public_az, "us-east-1c")
  ]

  efs_mount_target_security_groups = [module.efs-sg.security_group_id]

  # EFS access point
  enable_efs_access_point = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}

module "efs_policy" {
  source      = "../../modules/efs"
  name        = "epam-leodorov-efs"
  environment = "learning"

  # EFS FS policy
  enable_efs_file_system_policy         = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.efs
  ]
}
