
# VPC 1 Configuration
module "vpc1" {
    source                  = "./modules/vpc"
    # project_name            = var.project_name 
    vpc_name                = "vpc-1"
    vpc_cidr                = "10.0.0.0/16"
    az1                     = "us-west-1a"
    az2                     = "us-west-1b"
    private_subnet_az1_cidr = "10.0.1.0/24"
    private_subnet_az2_cidr = "10.0.2.0/24"

}

# VPC 2 Configuration
module "vpc2" {
    source                  = "./modules/vpc"
    vpc_name                = "vpc-2"
    vpc_cidr                = "10.1.0.0/16"
    az1                     = "us-west-1a"
    az2                     = "us-west-1b"
    private_subnet_az1_cidr = "10.1.1.0/24"
    private_subnet_az2_cidr = "10.1.2.0/24"

}

module "security_groups" {
  source       = "./modules/security-groups"
  vpc_1_vpc_id = module.vpc1.vpc_id
  vpc_2_vpc_id = module.vpc2.vpc_id
}


module "vpc-lattice" {
  source = "./modules/service-network"
  service_network_name          = "vpc-lattice-service-network"
  service_name                  = "my-lambda-service"
  https_listener_name           = "https-listener"
  target_group_name             = "lambda-target-group"
  service_network_listener_rule = "path-based-rule"
  lambda_arn                    = "path-based-rule"
  vpc_1_id                      = "vpc-12345678" 
  vpc_id                        = "vpc_1_vpc_id" # Replace with the ID of your VPC
  
}

# # Lambda Function in VPC 1
# module "lambda" {
#   source = "./modules/lambda"
#   vpc_id = module.vpc1.vpc_id
#   # Add any additional Lambda configuration here
# }

# # EC2 Instance in VPC 2
# module "ec2_instance" {
#   source = "./modules/ec2_instance"
#   vpc_id = module.vpc2.vpc_id
#   # Add any additional EC2 instance configuration here
# }
