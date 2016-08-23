# Configure the AWS Provider
provider "aws" {
    region = "us-west-2"
}

module "stack" {
  source      = "github.com/marioharper/stack" # the module source
  name        = "weather" # the name for our project
  environment = "dev" # the environment we're running in
  key_name    = "dev" # reference a key you've previously created
}

# creates the weather-service
module "weather" {
  source = "github.com/marioharper/stack/service"
  name = "weather"
  image = "alpine"
  port = "80"
  container_port = "80"
  dns_name = "weather"

  # these variables are automatically provisioned by stack
  environment     = "${module.stack.environment}"
  cluster         = "${module.stack.cluster}"
  zone_id         = "${module.stack.zone_id}"
  iam_role        = "${module.stack.iam_role}"
  security_groups = "${module.stack.internal_elb}"
  subnet_ids      = "${module.stack.internal_subnets}"
  log_bucket      = "${module.stack.log_bucket_id}"
}