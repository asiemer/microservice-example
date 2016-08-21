# The load balancer that distributes load between the EC2 Instances
resource "aws_elb" "elb" {
  name = "${var.prefix}"
  subnets = ["${split(",", var.elb_subnet_ids)}"]
  security_groups = ["${aws_security_group.elb.id}"]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30

    target = "HTTP:${var.container_port}/"
  }

  listener {
    instance_port = "${var.container_port}"
    instance_protocol = "http"
    lb_port = "${var.container_port}"
    lb_protocol = "http"
  }
}



# The securty group that controls what traffic can go in and out of the ELB
resource "aws_security_group" "elb" {
  name = "${var.prefix}-elb"
  description = "The security group for the ELB"
  vpc_id = "${var.vpc_id}"

  # Outbound Everything
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.container_port}"
    to_port = "${var.container_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The ECS Task that specifies what Docker containers we need to run 
resource "aws_ecs_task_definition" "task" {
  family = "${var.prefix}"
  container_definitions = <<EOF
[
  {
    "name": "${var.prefix}",
    "image": "${var.image_name}:${var.image_version}",
    "cpu": 1024,
    "memory": 768,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {"name": "RACK_ENV", "value": "production"}
    ]
  }
]
EOF
}


# A long-running ECS Service for the task
resource "aws_ecs_service" "service" {
  name = "${var.prefix}"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  depends_on = ["aws_iam_role_policy.ecs_service_policy"]
  desired_count = 2
  deployment_minimum_healthy_percent = 50
  iam_role = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.elb.name}"
    container_name = "${var.prefix}"
    container_port = "${var.container_port}"
  }
}