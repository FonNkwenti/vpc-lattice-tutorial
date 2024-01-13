# Building an Amazon VPC Lattice network with Terraform

This project demonstrates the capabilities of Amazon VPC Lattice using Terraform. The architecture includes two consumer VPCs associated with the VPC Lattice Service Network, and two services.

## Architecture

- **Consumer VPC 1**: Contains a private AWS Lambda function.
- **Consumer VPC 2**: Contains a single EC2 instance.
- **Service 1**: An EC2 instance in an autoscaling group behind an application load balancer within a VPC.
- **Service 2**: An AWS Lambda function.

## Project Structure

The project uses a modular structure to organize the Terraform code. Each module encapsulates the logic for creating a specific resource.

- `main.tf`: Entry point of the Terraform scripts.
- `variables.tf`: Defines all the variables used in the configurations.
- `outputs.tf`: Defines all the outputs to retrieve from the configurations.
- `provider.tf`: Contains the AWS provider configuration.

## Getting Started

1. Install Terraform.
2. Clone this repository.
3. Update the `variables.tf` file with your AWS resource details.
4. Run `terraform init` to initialize your Terraform workspace.
5. Run `terraform apply` to create the resources on AWS.

## Steps required to setup an Amazon VPC Lattice Service Network
1. Create the service network:
   - Assign a name and a region.
   - Optionally, configure authentication policies to control access.
  
2. Create services:
    - Define a name and authentication policy (if required).
    - Configure listeners for each protocol and port you want to expose (e.g., HTTPS on port 443).
    - Add rules within listeners to route traffic based on conditions (e.g., path, headers).
    - Associate target groups with rules to handle incoming traffic.

3. Associate VPCs with the service network:
    - Select the VPCs that will communicate with the services.
    - Specify security groups to control traffic flow.

4. Associate services with the service network:
    - Indicate which services should be accessible within the service network.

5. Create target groups (if needed):
    - Define target groups for services that require routing traffic to backend resources (e.g., Lambda functions, EC2 instances).

6. Register targets with target groups:
    - Add the actual resources (e.g., Lambda function URLs, EC2 instance IDs) to the target groups.

## Contributing

Please read `CONTRIBUTING.md` for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
