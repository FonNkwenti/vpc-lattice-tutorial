# create amazon vpc lattice service network
resource "aws_vpclattice_service_network" "service_network" {
  name = var.service_network_name
}

# Todo - auth policy for service network


# create vpc lattice service for lambda target group
resource "aws_vpclattice_service" "lambda_service" {
  name = var.service_name
  auth_type = "NONE"
  depends_on = [
    aws_vpclattice_target_group.lambda_tg
  ]
}

# create vpc lattice service network service association for our service
resource "aws_vpclattice_service_network_service_association" "service_association" {
    service_identifier = aws_vpclattice_service.lambda_service
    service_network_identifier = aws_vpclattice_service_network.service_network

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
  name = var.target_group_name
  type = "LAMBDA"
}

# create vpc lattice target group attachment
resource "aws_vpclattice_target_group_attachment" "lambda_tg_attachement" {
  target_group_identifier = aws_vpclattice_target_group.lambda_tg.id
  target {
    id = aws_lambda_function.lambda_function.arn
  }

}



# use aws_vpclattice_listener resource to create listeners and rules for our service-1 and lambda-tg

resource "aws_vpclattice_listener" "https_listener" {
  name               = var.https_listener_name
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
  name                = var.service_network_listener_rule
  listener_identifier = aws_vpclattice_listener.https_listener.id
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
  action {
    fixed_response {
      status_code = 200
    }

  }
#   action {
#     forward {
#       target_groups {
#         target_group_identifier = aws_vpclattice_target_group.lambda_tg.id
#       }

#     }

#   }
}

resource "aws_vpclattice_service_network_vpc_association" "vpc_1_association" {
  vpc_identifier             = var.vpc_1_id
  service_network_identifier = aws_vpclattice_service_network.service_network.id
#   security_group_ids         = [aws_security_group.example.id]
}