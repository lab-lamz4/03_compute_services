# 03 EFS, AWS backups

EFS + EC2 with mounted efs
AWS backup with bkp plan, this plan will create a bkp from efs every day (will start at 23:00)
EC2 to check that is our bkp is working (need manual actions to resore bkp as new efs, and mount it into ec2)


## Used resources

terraform modules from https://github.com/SebastianUA/terraform.git

Great thanks to Vitaliy Natarov!

## AWS CREDENTIALS

```
aws configure
```

## Terrfaorm

```
terraform init
terrafrom plan
terraform apply -target module.vpc #that is needed to get id of subnets and use it in ec2 playbook
terrafrom apply
terraform destroy
```