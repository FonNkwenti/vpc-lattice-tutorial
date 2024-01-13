
# VPC 1 Configuration
module "vpc1" {
    source                  = "./modules/vpc"
    # project_name            = var.project_name 
    vpc_name                = "vpc-1"
    vpc_cidr                = "10.0.0.0/16"
    az1                     = "us-west-2a"
    az2                     = "us-west-2b"
    private_subnet_az1_cidr = "10.0.1.0/24"
    private_subnet_az2_cidr = "10.0.2.0/24"

}

# VPC 2 Configuration
module "vpc2" {
    source                  = "./modules/vpc"
    vpc_name                = "vpc-2"
    vpc_cidr                = "10.1.0.0/16"
    az1                     = "us-west-2a"
    az2                     = "us-west-2b"
    private_subnet_az1_cidr = "10.1.1.0/24"
    private_subnet_az2_cidr = "10.1.2.0/24"

}

module "security_groups" {
  source       = "./modules/security-groups"
  vpc_1_vpc_id = module.vpc1.vpc_id
  vpc_2_vpc_id = module.vpc2.vpc_id
}

module "lambda_1" {
  source = "./modules/lambda"
  function_name        = "Lambda-1"
  role_name            = "MyLambdaExecutionRole"
  handler              = "index.handler"
  runtime              = "nodejs18.x"
  timeout              = 10
  memory_size          = 256
}

module "consumer_1_lambda" {
  source = "./modules/lambda"
  function_name        = "consumer-1-lambda"
  role_name            = "MyLambdaExecutionRole"
  handler              = "index.handler"
  runtime              = "nodejs18.x"
  timeout              = 10
  memory_size          = 256

  subnet_ids           = module.vpc1.subnet_ids
  security_group_ids   = module.vpc1.security_group_ids
}

# module "vpc-lattice" {
#   source = "./modules/service-network"
#   service_network_name          = "vpc-lattice-service-network"
#   service_name                  = "my-lambda-service"
#   https_listener_name           = "https-listener"
#   target_group_name             = "lambda-target-group"
#   service_network_listener_rule = "path-based-rule"
#   lambda_arn                    = "path-based-rule"
#   vpc_1_id                      = "vpc-12345678" 
#   vpc_id                        = "vpc_1_vpc_id" # Replace with the ID of your VPC
  
# }

# create amazon vpc lattice service network
resource "aws_vpclattice_service_network" "service_network" {
  name = "service-network"
}

# Todo - auth policy for service network


# create vpc lattice service for lambda target group
resource "aws_vpclattice_service" "lambda_service" {
  name = "lambda-service"
  auth_type = "NONE"
  depends_on = [
    aws_vpclattice_target_group.lambda_tg
  ]
}

# create vpc lattice service network service association for our service
resource "aws_vpclattice_service_network_service_association" "service_association" {
    service_identifier = aws_vpclattice_service.lambda_service.id
    service_network_identifier = aws_vpclattice_service_network.service_network.id

}

# Todo auth policy for service
#################
resource "aws_vpclattice_access_log_subscription" "log_subscription" {
  resource_identifier = aws_vpclattice_service.lambda_service.id
  destination_arn     = aws_cloudwatch_log_group.log_group_lattice.arn
}
resource "aws_cloudwatch_log_group" "log_group_lattice" {
  name              = "/aws/lattice/service/service-1"
  retention_in_days = 7
}



#create a lambda target group
resource "aws_vpclattice_target_group" "lambda_tg" {
  name = "lambda-tg"
  type = "LAMBDA"
}

# create vpc lattice target group attachment
resource "aws_vpclattice_target_group_attachment" "lambda_tg_attachement" {
  target_group_identifier = aws_vpclattice_target_group.lambda_tg.id
  target {
    # id = aws_lambda_function.lambda_function.arn
    id = "arn:aws:lambda:us-west-2:404148889442:function:cloudgto-service-builder-prv-build-s3"
  }
  depends_on = [ aws_vpclattice_target_group.lambda_tg ]


}



# use aws_vpclattice_listener resource to create listeners and rules for our service-1 and lambda-tg

resource "aws_vpclattice_listener" "https_listener" {
  name               = "https-listener"
  protocol           = "HTTPS"
  service_identifier = aws_vpclattice_service.lambda_service.id

#   default_action {
#     forward {
#       target_groups {
#         target_group_identifier = aws_vpclattice_target_group.lambda_target.id
#       }
#     }
#   }
  default_action {
    fixed_response {
      status_code = 404
    }
  }
}

# listener rule for path based routing to lambda target groups
resource "aws_vpclattice_listener_rule" "service_network_listener_rule" {
  name                = "service-network-listener-rule"
  listener_identifier = aws_vpclattice_listener.https_listener.arn
  service_identifier  = aws_vpclattice_service.lambda_service.id
  priority            = 20
  match {
    http_match {
      path_match {
        case_sensitive = true
        match {
          prefix = "/path-1"
        }
      }
    }
  }
  # action {
  #   fixed_response {
  #     status_code = 404
  #   }

  # }
  action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.lambda_tg.id
      }

    }

  }

depends_on = [ aws_vpclattice_listener.https_listener ]
}

resource "aws_vpclattice_service_network_vpc_association" "vpc_1_association" {
  vpc_identifier             = module.vpc1.vpc_id
  service_network_identifier = aws_vpclattice_service_network.service_network.id
#   security_group_ids         = [aws_security_group.example.id]
}




# # EC2 Instance in VPC 2
# module "ec2_instance" {
#   source = "./modules/ec2_instance"
#   vpc_id = module.vpc2.vpc_id
#   # Add any additional EC2 instance configuration here
# }
