module "iam" {
  source = "../modules/iam"
}

module "nginx" {
  source = "../modules/nginx"
  prefix = "weather-service-nginx-v1"
  region = "us-west-2"
  image_name = "nginx"
  image_version = "latest"
  key_pair_name = "ecs"
  vpc_id = "vpc-0c96be68"
  elb_subnet_ids = "subnet-0a603e6e,subnet-a80573de,subnet-3775c46f"
  ecs_cluster_subnet_ids = "subnet-0a603e6e,subnet-a80573de,subnet-3775c46f"
}