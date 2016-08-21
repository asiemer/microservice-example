# An IAM role that we attach to the EC2 Instances in ECS.
resource "aws_iam_role" "ecs_instance" {
  name = "${var.prefix}-ecs-instance"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# An IAM instance profile we can attach to an EC2 instance
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.prefix}-ecs-instance"
  roles = ["${aws_iam_role.ecs_instance.name}"]

  # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}

# IAM policy we add to our EC2 Instance Role that allows an ECS Agent running
# on the EC2 Instance to communicate with the ECS cluster
resource "aws_iam_role_policy" "ecs_cluster_permissions" {
  name = "${var.prefix}-ecs-cluster-permissions"
  role = "${aws_iam_role.ecs_instance.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}


# An IAM Role that we attach to ECS Services. See the
# aws_aim_role_policy below to see what permissions this role has.
resource "aws_iam_role" "ecs_service_role" {
  name = "${var.prefix}-ecs-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Policy that allows an ECS Service to communicate with EC2 Instances.
resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "${var.prefix}-ecs-service-policy"
  role = "${aws_iam_role.ecs_service_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}