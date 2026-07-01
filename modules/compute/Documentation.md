# Module: Compute

## Purpose

The compute module provisions the application-facing infrastructure behind the load balancer. It creates an Application Load Balancer, target group, launch template, and Auto Scaling Group for horizontally scaling web application instances.

## Resources Created

- aws_lb.app
- aws_lb_target_group.app
- aws_lb_listener.http
- aws_launch_template.app
- aws_autoscaling_group.app

## Inputs

- name_prefix: Prefix used in resource names
- vpc_id: ID of the VPC in which the ASG and ALB are placed
- public_subnet_ids: Subnets for the ALB
- private_subnet_ids: Subnets for the instances in the ASG
- alb_security_group_id: Security group for the ALB
- ec2_security_group_id: Security group for the EC2 instances
- ami_id: AMI used for the instances
- instance_type: EC2 instance type
- aws_region: AWS region used by the user data script
- app_port: Port used by the target group and health check
- min_size, max_size, desired_capacity: Autoscaling settings

## Outputs

- alb_dns_name: DNS name of the Application Load Balancer
- alb_arn: ARN of the ALB
- target_group_arn: ARN of the target group
- asg_name: Name of the autoscaling group
- launch_template_id: ID of the launch template

## Deployment Behavior

- The ALB listens on port 80 and forwards traffic to the target group.
- The target group performs health checks on `/` using HTTP.
- The Auto Scaling Group uses the launch template and scales within the private subnets.
- The user data script installs Nginx and serves a simple placeholder page.

## Notes

- The current implementation uses a simple bootstrap script and is intended as a baseline for application deployment.
- For a real workload, replace the user data script with a production application deployment mechanism such as Ansible, CodeDeploy, or a container-based solution.

## Example Usage

```hcl
module "compute" {
  source = "../../modules/compute"

  name_prefix         = "use1"
  aws_region          = "us-east-1"
  vpc_id              = module.networking.vpc_id
  public_subnet_ids   = module.networking.public_subnet_ids
  private_subnet_ids  = module.networking.private_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id
  ec2_security_group_id = module.networking.app_security_group_id
  ami_id              = data.aws_ami.ubuntu.id
  instance_type       = "t3.micro"
}
```
