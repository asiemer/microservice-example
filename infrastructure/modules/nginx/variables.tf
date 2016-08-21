variable "prefix" {
  description = "Prefixer for any names"
}
variable "image_name" {
  description = "The name of the Docker container to deploy in the EC2 instance"
}

variable "image_version" {
  description = "The version of the Docker container to deploy."
}

variable "container_port" {
  description = "The port the Docker container listens on for HTTP requests"
  default = 80
}

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster"
}

variable "vpc_id" {
  description = "The id of the VPC where the ECS cluster should run"
}

variable "elb_subnet_ids" {
  description = "A comma-separated list of subnets where the ELBs should be deployed"
}

variable "ecs_cluster_subnet_ids" {
  description = "A comma-separated list of subnets where the EC2 instances for the ECS cluster should be deployed"
}

variable "region" {
  description = "The region to apply these templates to"
}

variable "ami" {
  description = "The AMI for each EC2 instance in the cluster"
  # These are the ids for Amazon's ECS-Optimized Linux AMI from:
  # https://aws.amazon.com/marketplace/ordering?productId=4ce33fd9-63ff-4f35-8d3a-939b641f1931.
  default = {
    us-west-2 = "ami-a426edc4"
  }
}