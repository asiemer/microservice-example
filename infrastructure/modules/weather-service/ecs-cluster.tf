# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"
}

# The ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.prefix}-cluster"

  # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}

# The Auto Scaling Group that determines how many EC2 Instances we will be
# running
resource "aws_autoscaling_group" "ecs_cluster_instances" {
  name = "${var.prefix}-cluster-instances"
  min_size = 1
  max_size = 1
  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
  vpc_zone_identifier = ["${split(",", var.ecs_cluster_subnet_ids)}"]

  tag {
    key = "Name"
    value = "${var.prefix}-cluster-instances"
    propagate_at_launch = true
  }
}

# The launch configuration for each EC2 Instance that will run in the ECS
# Cluster
resource "aws_launch_configuration" "ecs_instance" {
  name_prefix = "${var.prefix}-ecs-instance-"
  instance_type = "t2.micro"
  key_name = "${var.key_pair_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
  security_groups = ["${aws_security_group.ecs_instance.id}"]
  image_id = "${lookup(var.ami, var.region)}"

  # A shell script that will execute when on each EC2 instance when it first boots to configure the ECS Agent to talk
  # to the right ECS cluster
  user_data = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.cluster.name}" >> /etc/ecs/ecs.config
EOF

  # Important note: whenever using a launch configuration with an auto scaling
  # group, you must set create_before_destroy = true. However, as soon as you
  # set create_before_destroy = true in one resource, you must also set it in
  # every resource that it depends on, or you'll get an error about cyclic
  # dependencies (especially when removing resources). For more info, see:
  #
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html
  lifecycle {
    create_before_destroy = true
  }
}

# Security group that controls what network traffic is allowed to go in and out of each EC2 instance in the cluster
resource "aws_security_group" "ecs_instance" {
  name = "${var.prefix}-ecs-instance"
  description = "Security group for the EC2 instances in the ECS cluster"
  vpc_id = "${var.vpc_id}"

  # Outbound Everything
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP for the container from anywhere
  ingress {
    from_port = "${var.container_port}"
    to_port = "${var.container_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound SSH from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}