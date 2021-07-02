data "aws_subnet" "public" {
  for_each = toset(module.vpc.public_subnets_ids)

  id = each.key
  depends_on = [
    module.vpc
  ]
}

locals {
  public_az       = {
    for s in data.aws_subnet.public : s.availability_zone => s.id
  }
}

module "ec2-efs" {
  source = "../../modules/ec2"
  name   = "ec2-efs"
  region = "us-east-1"
  ami    = {
      us-east-1 = "ami-0ab4d1e9cf9a1215a"
  }

  enable_instance             = true
  environment                 = "learning"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  root_block_device           = [{
      delete_on_termination = true
      volume_size           = 20
      volume_type           = "gp2"
  }]


  disk_size                             = null
  tenancy                               = "default"
  subnet_id                             = lookup(local.public_az, "us-east-1c")
  vpc_security_group_ids                = [module.ec2-sg.security_group_id]
  user_data                             = templatefile("additional_files/ec2efs.yaml", { addr = module.efs.efs_file_system_dns_name})
  instance_initiated_shutdown_behavior  = "terminate"
  monitoring                            = true
  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.vpc,
    module.ec2-sg,
    module.efs
  ]
}

module "ec2-private" {
  source = "../../modules/ec2"
  name   = "private-host"
  region = "us-east-1"
  ami    = {
      us-east-1 = "ami-0ab4d1e9cf9a1215a"
  }

  enable_instance                       = true
  environment                           = "learning"
  instance_type                         = "t2.micro"
  root_block_device                     = [{
      delete_on_termination = true
      volume_size           = 20
      volume_type           = "gp2"
  }]
  tenancy                               = "default"
  iam_instance_profile                  = ""
  subnet_id                             = lookup(local.public_az, "us-east-1a")
  vpc_security_group_ids                = [module.ec2-sg.security_group_id]
  monitoring                            = true
  user_data                             = file("additional_files/test-host.yaml")
  instance_initiated_shutdown_behavior  = "terminate"
  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })

  depends_on = [
    module.vpc,
    module.ec2-sg,
    module.efs
  ]
}
