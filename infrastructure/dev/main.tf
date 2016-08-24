# INPUTS

# CONFIGURE
provider "aws" {
    region = "us-west-2"
}

module "stack" {
  source      = "github.com/marioharper/stack" # the module source
  name        = "weather" # the name for our project
  domain_name = "spike.local" 
  environment = "dev" # the environment we're running in
  key_name    = "dev" # reference a key you've previously created
  ecs_instance_type = "t2.micro"
  ecs_instance_ebs_optimized = false
  ecs_min_size = 1
  ecs_max_size = 1
  ecs_desired_capacity = 1
  availability_zones = "us-west-2a"
  external_subnets = "10.30.0.0/19"
  internal_subnets = "10.30.32.0/20"
}

# creates the weather-service
module "weather" {
  source = "github.com/marioharper/stack/service"
  name = "weather"
  image = "marioharper/weather"
  port = "80"
  container_port = "8080"
  dns_name = "weather"
  healthcheck = "/1"

  # these variables are automatically provisioned by stack
  environment     = "${module.stack.environment}"
  cluster         = "${module.stack.cluster}"
  zone_id         = "${module.stack.zone_id}"
  iam_role        = "${module.stack.iam_role}"
  security_groups = "${module.stack.internal_elb}"
  subnet_ids      = "${module.stack.internal_subnets}"
  log_bucket      = "${module.stack.log_bucket_id}"
}


# OUTPUTS

# The bastion host IP.
output "bastion_ip" {
  value = "${module.stack.bastion_ip}"
} 