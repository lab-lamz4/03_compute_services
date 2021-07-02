module "ec2-sg" {
  source      = "../../modules/sg"
  name        = "epam-leodorov-efs"
  environment = "learning"

  enable_security_group = true
  security_group_name   = "EC2-sg"
  security_group_vpc_id = module.vpc.vpc_id


  security_group_ingress = [
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "SSH to VPC"
      security_groups  = null
      self             = null
    }
  ]

  security_group_egress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "all from VPC"
      security_groups  = null
      self             = null
    }
  ]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}

module "efs-sg" {
  source      = "../../modules/sg"
  name        = "epam-leodorov-efs"
  environment = "learning"

  enable_security_group = true
  security_group_name   = "EFS-sg"
  security_group_vpc_id = module.vpc.vpc_id


  security_group_ingress = [
    {
      from_port = 2049
      to_port   = 2049
      protocol  = "tcp"

      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "all from ec2"
      security_groups  = [module.ec2-sg.security_group_id]
      self             = null
    }
  ]

  security_group_egress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      description      = "all to out"
      security_groups  = null
      self             = null
    }
  ]

  tags = tomap({
    "Environment"   = "learning",
    "stack" =  "ebs"
    "Owner"     = "Andrei Leodorov",
    "Orchestration" = "Terraform"
  })
}