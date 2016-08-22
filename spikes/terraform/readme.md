# quick primer on terraform

From here [the terraform site](https://www.terraform.io/intro/getting-started/build.html).

Create an example.tf file (there is one in this folder already).  Then enter this data.

```
provider "aws" {
  access_key = "AKIAISSBAMQWURCDRXCA"
  secret_key = "QQ7pj0POgsLPXkRSbdCOFrIOkNp/RTb3e779rOqA"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-13be557e"
  instance_type = "t2.micro"
}
```

Use your own access key an secret key (the ones above are not valid).

Then in a terminal window navigate into the folder where your .tf file lives.  Type 

```
$ terraform plan
```

And you will see what terraform is going to do to your AWS account.

Next type 

```
$terraform apply
```

And terraform will build our a quick ec2 instance for you.

Next change your .tf file to use this new resource type.

```
resource "aws_instance" "example" {
  ami           = "ami-13be557e"
  instance_type = "t2.micro"
}
```

Then lets take a look at the new plan.

```
$ terraform plan
```

It should show you that it know exactly what has changed.

Then we can apply the changes.

```
$ terraform apply
```

Then you can see exactly what your aws looks like for this configuration.  Type

```
$ terraform show
```

Now we can get ready to take down the environment.  But first lets see exactly what destroying the environment will do.

```
$ terraform plan -destroy
```

This shows us what will be done according to this plan.  Then we can actually destroy the environment.

```
$ terraform destroy
```

Now you have no assets created in your aws account.

