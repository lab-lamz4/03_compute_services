module "iam_role" {
  source      = "../../modules/iam_role"
  name        = "epam-leodorov-efs"
  environment = "learning"

  # Using IAM role
  enable_iam_role      = true
  iam_role_name        = "efs-backup-role"
  iam_role_description = "Role to backup schedule"
  # Inside additional_files directory I will add additional policies for assume_role_policy usage in the future....
  iam_role_assume_role_policy = file("additional_files/assume_role_policy_with_mfa.json")

  iam_role_force_detach_policies = true
  iam_role_path                  = "/"
  iam_role_max_session_duration  = 3600

  # Using IAM role policy
  enable_iam_role_policy = false

  # Using IAM role policy attachment
  enable_iam_role_policy_attachment      = true
  iam_role_policy_attachment_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"]

  # Using IAM instance profile
  enable_iam_instance_profile = false

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}
