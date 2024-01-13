# create amazon vpc lattice service network
resource "aws_vpclattice_service_network" "this" {
  name = var.service_network_name
}

#create a lambda target group
resource "aws_vpclattice_target_group" "this" {
  name = var.target_group_name
  protocol = "HTTPS"
  port = 443
  vpc_identifier = var.vpc_id
  health_check {
    path = "/health"
  }
}

# create vpc lattice target group attachment
resource "aws_vpclattice_target_group_attachment" "this" {
  service_network_identifier = aws_vpclattice_service_network.this.id
  target_group_identifier = aws_vpclattice_target_group.this.id
  target {
    type = "AWS_LAMBDA"
    identifier = var.lambda_arn
  }
}

# create vpc lattice service for lambda target group
resource "aws_vpclattice_service" "this" {
  name = var.service_name
  service_network_identifier = aws_vpclattice_service_network.this.id
  type = "HTTP_PROXY"
  depends_on = [
    aws_vpclattice_target_group.this
  ]
}

# create vpc lattice service network service association for our service
resource "aws_vpclattice_service_network_service_association" "this" {
    service_identifier = aws_vpclattice_service.this.id
    service_network_identifier = aws_vpclattice_service_network.this.id

}

# use aws_vpclattice_listener resource to create a listener for our service for HTTPS 
resource "aws_vpclattice_listener" "this" {
  service_network_identifier = aws_vpclattice_service_network.this.id
  service_identifier = aws_vpclattice_service.this.id
  protocol = "HTTPS"
  port = 443
  certificate_arn = var.certificate_arn
  action {
    type = "FORWARD"
    forward {
      target_group {
        target_group_identifier = aws_vpclattice_target_group.this.id
      }
    }
  }
}



# create aws vpc lattice service network association for 2 vpcs named VPC-1 and VPC-2
resource "aws_vpclattice_service_network_vpc_association" "this" {
  service_network_identifier = aws_vpclattice_service_network.this.id
  vpc_identifier = var.vpc_id
  security_group_ids = var.security_group_ids
}