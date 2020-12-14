# Hands-on Terraform-01 : Terraform Installation and Basic Operations

Purpose of the this hands-on training is to give students the knowledge of basic operations in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Install Terraform

- Build AWS Infrastructure with Terraform

## Outline

- Part 1 - Install Terraform

- Part 2 - Build AWS Infrastructure with Terraform

## Part 1 - Install Terraform

- Launch an EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH connections.

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
$ sudo yum update -y
```

- Install yum-config-manager to manage your repositories.

```bash
$ sudo yum install -y yum-utils
```

- Use yum-config-manager to add the official HashiCorp Linux repository.

```bash
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

- Install Terraform.

```bash
$ sudo yum -y install terraform
```

- Verify that the installation

```bash
$ terraform version
```

- list Terraform's available subcommands.

```bash
$ terraform -help
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you are just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.

Common commands:
    apply              Builds or changes infrastructure
...    
```

- Add any subcommand to terraform -help to learn more about what it does and available options.

```bash
$ terraform -help apply
```

- To enable autocomplete, run the following command and then restart your shell.

```bash
$ terraform -install-autocomplete
```

## Part 2 - Build AWS Infrastructure with Terraform

### Prerequisites

- An AWS account

- The AWS CLI installed

- Your AWS credentials configured locally.  

```bash
$ aws configure
```

> Hard-coding credentials into any Terraform configuration is not recommended, and risks secret leakage should this file ever be committed to a public version control system.

> Using aws credentials in ec2 instance is not recommended.

- So we use iam role. 

### Create a role in IAM management console.

- Select `EC2` from `select type of trusted entity`.

- Select `AmazonEC2FullAccess` from `Attach permissions policies`.

- Name it `terraform-ec2`.

- Attach this role to your ec2 instance.

### Write configuration

- The set of files used to describe infrastructure in Terraform is known as a Terraform configuration. You'll write your first configuration now to launch a single AWS EC2 instance.

- Each configuration should be in its own directory. Create a directory for the new configuration.

```bash
$ mkdir terraform-aws-example
```

- Change into the directory.

```bash
$ cd terraform-aws-example
```

- Create a file named `tf-example.tf` for the configuration code.

```txt
provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "tf-example-ec2" {
  ami           = "ami-04d29b6f966df1537"
  instance_type = "t2.micro"
}
```

- Explain the each block via the following section.

### Providers

The `provider` block configures the named provider, in our case `aws`, which is responsible for creating and managing resources. A provider is a plugin that Terraform uses to translate the API interactions with the service. A provider is responsible for understanding API interactions and exposing resources. Because Terraform can interact with any API, you can represent almost any infrastructure type as a resource in Terraform.

The `profile` attribute in your provider block refers Terraform to the AWS credentials stored in your AWS Config File, which you created when you configured the AWS CLI. HashiCorp recommends that you never hard-code credentials into `*.tf configuration files`. 

> Note: If you leave out your AWS credentials, Terraform will automatically search for saved API credentials (for example, in ~/.aws/credentials) or IAM instance profile credentials. This is cleaner when .tf files are checked into source control or if there is more than one admin user.

### Resources

The `resource` block defines a piece of infrastructure. A resource might be a physical component such as an EC2 instance.

The resource block has two strings before the block: the resource type and the resource name. In the example, the resource type is `aws_instance` and the name is `tf-example-ec2`. The prefix of the type maps to the provider. In our case "aws_instance" automatically tells Terraform that it is managed by the "aws" provider.

The arguments for the resource are within the resource block. The arguments could be things like machine sizes, disk image names, or VPC IDs. You can see [providers reference](https://www.terraform.io/docs/providers/index.html) documents the required and optional arguments for each resource provider. For your EC2 instance, you specified an AMI for `Amazon Linux 2`, and requested a `t2.micro` instance so you qualify under the free tier.

### Initialize the directory

When you create a new configuration — or check out an existing configuration from version control — you need to initialize the directory with `terraform init`.

Terraform uses a plugin-based architecture to support hundreds of infrastructure and service providers. Initializing a configuration directory downloads and installs providers used in the configuration, which in this case is the `aws provider`. Subsequent commands will use local settings and data during initialization.

- Initialize the directory.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "3.9.0"...
- Installing hashicorp/aws v3.9.0...
- Installed hashicorp/aws v3.9.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Terraform downloads the `aws` provider and installs it in a hidden subdirectory of the current working directory. The output shows which version of the plugin was installed.

### Create infrastructure

- run `terraform plan`. You should see an output similar to the one shown below. (Explain the output.)

```bash
$ terraform plan

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.sample-resource will be created
  + resource "aws_instance" "tf-example-ec2" {
      + ami                          = "ami-04d29b6f966df1537"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + network_interface_id         = (known after apply)
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform can't guarantee that exactly these actions will be performed if "terraform apply" is subsequently run.
```

This output shows the execution plan, describing which actions Terraform will take in order to change real infrastructure to match the configuration.


- Run `terraform apply`. You should see an output similar to the one shown above. 

```bash
terraform apply
```

- Terraform will now pause and wait for your approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure.

- In this case the plan is acceptable, so type yes at the confirmation prompt to proceed. Executing the plan will take a few minutes since Terraform waits for the EC2 instance to become available.

```txt
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.tf-example-ec2: Creating...
aws_instance.tf-example-ec2: Still creating... [10s elapsed]
aws_instance.tf-example-ec2: Still creating... [20s elapsed]
aws_instance.tf-example-ec2: Still creating... [30s elapsed]
aws_instance.tf-example-ec2: Still creating... [40s elapsed]
aws_instance.tf-example-ec2: Creation complete after 43s [id=i-080d16db643703468]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
- Visit the EC2 console to see the created EC2 instance.

### Inspect state

- When you applied your configuration, Terraform wrote data into a file called terraform.tfstate. This file now contains the IDs and properties of the resources Terraform created so that it can manage or destroy those resources going forward.

- Inspect the current state using terraform show.

```bash
$ terraform show
# aws_instance.sample-resource:
resource "aws_instance" "tf-example-ec2" {
    ami                          = "ami-09d95fab7fff3776c"
    arn                          = "arn:aws:ec2:us-east-1:846133131154:instance/i-080d16db643703468"
    associate_public_ip_address  = true
    availability_zone            = "us-east-1d"
    cpu_core_count               = 1
    cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    id                           = "i-080d16db643703468"
    instance_state               = "running"
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    monitoring                   = false
    primary_network_interface_id = "eni-0452ee35ecf17b5a6"
    private_dns                  = "ip-172-31-18-13.ec2.internal"
    private_ip                   = "172.31.18.13"
    public_dns                   = "ec2-54-84-88-167.compute-1.amazonaws.com"
    public_ip                    = "54.84.88.167"
    security_groups              = [
        "default",
    ]
    source_dest_check            = true
    subnet_id                    = "subnet-bce854f1"
    tenancy                      = "default"
    volume_tags                  = {}
    vpc_security_group_ids       = [
        "sg-3d047a10",
    ]
```

### Manually Managing State

Terraform has a built in command called `terraform state` for advanced state management. For example, if you have a long state file, you may want a list of the resources in state, which you can get by using the `list` subcommand.

```bash
$ terraform state list
aws_instance.tf-example-ec2
```

### Creating a AWS S3 bucket

- Create a S3 bucket. Go to the `tf-example.tf` and add the followings.

```tf
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "tf-example-ec2" {
    ami           = "ami-04d29b6f966df1537"
    instance_type = "t2.micro" 
    key_name      = "northvirginia"    #<pem file>
    tags = {
      Name = "tf-ec2"
  }
}

resource "aws_s3_bucket" "tf-example-s3" {
  bucket = "oliver-tf-test-bucket"
  acl    = "private"
}
```

- Run the command `terraform plan` and `terraform apply`.

```bash
terraform plan

terraform apply
```

```txt
Error: Error creating S3 bucket: AccessDenied: Access Denied
        status code: 403, request id: 8C5E290CD1CD3F71, host id: NT6nPSh0nW9rripGZrOAo48qJpZ2yToKCiGxDl6gfKIXY97uVH67lcvBiQjX9bsJRX3cL1oNVNM=
```

- Becouse of we didn't use our aws credentials in ec2 instance in the `tf-example.tf` file , we take an error. So, now create a new role which allow to access ec2 and s3. Then name the role `terraform-ec2-s3-role`. And look at the AWS console, and show ec2 was created , but s3 bucket was not created. Then attach the new role to the ec2 and run the command `terraform apply -auto-approve`.

```bash
terraform apply -auto-approve
```
- `-auto-approve` means to skip interactive approval of plan before applying.

- Go to the AWS console, check the EC2 and S3 bucket. Then check the `terraform.state` file.

### Terraform Commands

- Go to the terminal and run `terraform validate`. It means to validates the Terraform files.

```bash
terraform validate
```

- Go to `tf-example.tf` file and delete last curly bracket "}" and key_name's last letter (key_nam). And Go to terminal and run the command `terraform validate`. After taking the errors correct them. Then run the command again.

```bash
$ terraform validate 

Error: Argument or block definition required

  on tf-example.tf line 20, in resource "aws_s3_bucket" "tf-example-s3":

An argument or block definition is required here.

$ terraform validate 

Error: Unsupported argument

  on tf-example.tf line 9, in resource "aws_instance" "tf-example-ec2":
   9:     key_nam      = "northvirginia"

An argument named "key_nam" is not expected here. Did you mean "key_name"?

$ terraform validate 
Success! The configuration is valid.
```

- Go to `tf-example.tf` file and add random indentations and spaces the lines. Then go to terminal and run the command `terraform fmt`. It means to rewrites config files to canonical format. 

```bash
terraform fmt
```

- Now, show `tf-example.tf` file. It was formatted again.

- Go to the terminal and run `terraform console`. Then run the following commands.

```bash
terraform console
> aws_instance.tf-example-ec2
> aws_instance.tf-example-ec2.subnet_id
> aws_instance.tf-example-ec2.private_ip
> aws_s3_bucket.tf-example-s3
> aws_s3_bucket.tf-example-s3.bucket
> aws_s3_bucket.tf-example-s3.versioning
> aws_s3_bucket.tf-example-s3.versioning[0]
> aws_s3_bucket.tf-example-s3.versioning[0].enabled
> exit
```

- Go to the terminal and run `terraform show`. It means to ınspect Terraform state or plan. It is more readable than `terraform.tfstate`.

```bash
terraform show
```

- Go to the terminal and run `terraform state list`. 

```bash
terraform state list
```
- Go to the terminal and run `terraform graph`. It means to create a visual graph of Terraform resources. The output of terraform graph is in the DOT format, which can easily be converted to an image by making use of dot provided by GraphViz.

- Copy the output and paste it to the ` https://dreampuf.github.io/GraphvizOnline `. Then display it. If you want to display this output in your local, you can download graphviz (`sudo yum install graphviz`) and take a `graph.svg` with the command `terraform graph | dot -Tsvg > graph.svg`.

```bash
terraform graph
```

- Now add the followings to the `tf-example.tf` file.  Then run the commands `terraform apply` and `terraform output`. `terraform output` command is used for readng an output from a state file. It reads an output variable from a Terraform state file and prints the value. With no additional arguments, output will display all the outputs for the oot module.  If NAME is not specified, all outputs are printed.

```bash
output "tf-example-public-ip" {
  value = aws_instance.tf-example-ec2.public_ip
}

output "tf-example-s3-meta" {
  value = aws_s3_bucket.tf-example-s3
}
```

```bash
terraform apply
terraform output
terraform output -json
terraform output tf-example-public-ip
```

- The `terraform refresh` command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file. First, current state of your resources with `terraform state list`. Then go to the AWS console and delete your S3 bucket `oliver-tf-test-bucket`. Display the state list again and refresh the state. Run the following commands.

```bash
$ terraform state list
aws_instance.tf-example-ec2
aws_s3_bucket.tf-example-s3

# After deleting S3 bucket. Now, you don't have S3 bucket. 
$ terraform state list
aws_instance.tf-example-ec2
aws_s3_bucket.tf-example-s3

$ terraform refresh
aws_instance.tf-example-ec2: Refreshing state... [id=i-02938164282a9c741]
aws_s3_bucket.tf-example-s3: Refreshing state... [id=oliver-tf-test-bucket]

Outputs:

tf-example-public_ip = 3.94.206.84

$ terraform state list
aws_instance.tf-example-ec2
```

- Now, you can see the differences between files `terraform.tfstate` and `terraform.tfstate.backup`

- Run the command `terraform apply -auto-approve` and create S3 bucket again.

```bash
terraform apply -auto-approve
```

-  Go to the `tf-example.tf` file and make the changes.

```bash
resource "aws_instance" "tf-example-ec2" {
    - ami           = "ami-04d29b6f966df1537"
    + ami           = "ami-0885b1f6bd170450c"
    instance_type = "t2.micro" 
    key_name      = "northvirginia"    #<pem file>
    tags = {
      - Name = "tf-ec2"
      + Name = "tf-ec2-change"
  }
}

resource "aws_s3_bucket" "tf-example-s3" {
  bucket = "oliver-tf-test-bucket-new"
  acl    = "private"
}
```

- Run the command `terraform apply -auto-approve` and check the AWS console, the old S3 bucket and EC2 were destroyed and terraform created new ones.

```bash
terraform apply -auto-approve
```

- Make the new changes in the `tf-example.tf` file.

```bash
output "tf-example-private-ip" {
  value = aws_instance.tf-example-ec2.private_ip
}
```

- Run the command `terraform apply -refresh=false`. It displays only the changes in the terminal.

```bash
$ terraform apply -refresh=false

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:

Terraform will perform the following actions:

Plan: 0 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + tf-example-private-ip = "172.31.22.95"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

```

- We can create a plan file in terraform with the `-out` command. You can use this file instead of `terraform.tfstate` file.

```bash
terraform plan -destroy -out=DestroyAllResources.tfplan
```

- Go to the EC2 and see the file `DestroyAllResources.tfplan` was created. Now, run the file with `terraform apply` command

```bash
terraform apply "DestroyAllResources.tfplan"
```
### Variables

- Make the changes in the `tf-example.tf` file.

```bash
provider "aws" {
  region  = "us-east-1"
}

variable "ec2-name" {
  default = "oliver-new-ec2"
  description = "name for new ec2"
}

variable "ec2-type" {
  default = "t2.micro"
  description = "type for new ec2"
}

variable "ec2-ami" {
  default = "ami-04d29b6f966df1537"
  description = "ami for new ec2"
}

resource "aws_instance" "tf-example-ec2" {
  ami           = var.ec2-ami
  instance_type = var.ec2-type
  key_name      = "northvirginia"
  tags = {
    Name = "${var.ec2-name}-💻🎯🎉"
  }
}

variable "s3-bucket-name" {
  default = "oliver-new-s3-bucket"
  description = "name for new s3 bucket"
}

resource "aws_s3_bucket" "tf-example-s3" {
  bucket = var.s3-bucket-name
  acl    = "private"
}

output "tf-example-public_ip" {
  value = aws_instance.tf-example-ec2.public_ip
}

output "tf-example-private-ip" {
  value = aws_instance.tf-example-ec2.private_ip
}

output "tf-example-s3-meta" {
  value = aws_s3_bucket.tf-example-s3
}

```
- Create a file name `variables.tf`. Take the variables from `tf-example.tf` file and paste.

```bash
terraform validate

terraform fmt

terraform apply
```

- Comment variables of `ec2-name` and `ec2-type`. Then make the changes in the `tf-example.tf` file. 

```bash
locals {
  my-instance-name = "oliver-locals"
  my-instance-type = "t2.micro"
}

resource "aws_instance" "tf-example-ec2" {
  ami           = var.ec2-ami
  instance_type = local.my-instance-type
  key_name      = "northvirginia"
  tags = {
    Name = local.my-instance-name
  }
}
```

- A `local` value assigns a name to an expression, so you can use it multiple times within a module without repeating it.

- Run the command `terraform apply` again.

```bash
terraform apply
```

- Go to the `variables.tf` file and comment the line.

```tf
variable "s3-bucket-name" {
#   default     = "oliver-new-s3-bucket"
  description = "name for new s3 bucket"
}
```

- Run the command belov.

```bash
terraform plan -var="s3-bucket-name=oliver-new-s3-bucket-2"
```

- You can define variables with `-var` command

- Create a file name `oliver.tfvars`. Add the followings.

```bash
s3-bucket-name = "oliver-s3-bucket-newest"
```

- Run the command belov.

```bash
terraform plan --var-file="oliver.tfvars"
```

- Go to the `variables.tf` file and uncomment the line.

```tf
variable "s3-bucket-name" {
  default     = "oliver-new-s3-bucket"
  description = "name for new s3 bucket"
}
```
### Conditionals and Loops

- Go to the `variables.tf` file and add a new variable.

```bash
variable "num_of_buckets" {
  default = 1
}
```

- Go to the `tf-example.tf` file, make the changes in order. Then run the file.

```bash
resource "aws_s3_bucket" "tf-example-s3" {
  bucket = var.s3-bucket-name
  acl    = "private"
  count = var.num_of_buckets
}

```

```bash
terraform plan
```

- Go to the `tf-example.tf` file, make the changes in order. Then run the file.

```bash
resource "aws_s3_bucket" "tf-example-s3" {
  bucket = var.s3-bucket-name
  acl    = "private"
  # count = var.num_of_buckets
  count = var.num_of_buckets != 0 ? var.num_of_buckets : 1
}

# Check the number of buckets variable and if it is not equals to zero, go ahead and create that number of buckets. But in any case, if it is zero then go ahead and at least create one single bucket.
```

```bash
terraform plan
```

- Go to the `variables.tf` file again and add a new variable.

```bash
variable "users" {
  default = ["sony", "micheal", "fredo"]
}
```

- Go to the `tf-example.tf` file make the changes. Then run the file.

```bash
resource "aws_s3_bucket" "tf-example-s3" {
  # bucket = var.s3-bucket-name
  acl = "private"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 1
  for_each = toset(var.users)
  bucket   = "example-s3-bucket-${each.value}"
}

resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}
```

```bash
terraform apply
```
- Go to the AWS console (IAM, S3, EC2) and check the resources which created yet.

### Terraform data sources

- `Data sources` allow data to be fetched or computed for use elsewhere in Terraform configuration.

- Go to the `AWS console and create an image` from your ec2. Name `terrafrom-lesson-ami`.

- Go to the `variables.tf` file and comment the variable `ec2-ami`.

- Go to the `tf-example.tf` file make the changes in order. Then run the file.

```bash
data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "tf-example-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = local.my-instance-type
  key_name      = "northvirginia"
  tags = {
    Name = local.my-instance-name
  }
}
```

```bash
terraform plan
```

### Terraform Remote State

- A `backend` in Terraform determines how state is loaded and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc. By default, Terraform uses the "local" backend, which is the normal behavior of Terraform you're used to.

- Go to the AWS console and attach a role to the ec2 for allowing AWS DynamoDB full access.

- Create a new folder name `terraform-remote-state` and move `terraform-aws-example` into it. Then create another folder name `s3-backend` in this folder, too. 

```txt
  terraform-remote-state
    ├── s3-backend
    │   └── backend.tf
    └── terraform-aws-example
        ├── oliver.tfvars
        ├── tf-example.tf
        └── variables.tf

```

- Go to the `s3-backend` folder and create a file name `backend.tf`. Add the followings.

```bash
resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "tf-remote-s3-bucket-oliver"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#locking part- dynoma db

resource "aws_dynamodb_table" "tf-remote-state_lock" {
  hash_key = "LockID"
  name = "tf-s3-app-lock"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}
```

- Run the commands belov.

```bash
terraform init

terraform apply
```

- Go to the `tf-example.tf` file make the changes. Then run the file.

```bash
terraform {
  backend "s3" {
    bucket = "tf-remote-s3-bucket-oliver"
    key = "env/project-1/users/tf-backend-state.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}
```
- Go to the `terraform-aws-example` directoy and run the commands below.

```bash
terraform init

terraform apply
```

- Becouse of using S3 bucket for backend, run `terraform init` again.

- Go to the AWS console and check the s3 bucket, Dynamo DB table and tfstate file.

- Destroy all resources.

```bash
terraform destroy
```

- Go to the AWS console and delete `tf-remote-s3-bucket-oliver` and `tf-s3-app-lock` DynamoDb table.

### Terraform modules

-Create folders name `terraform-modules`, `modules`, `dev`, `prod`,`vpc`, `main-vpc` and files as below. 

```txt
 terraform-modules
   ├── dev
   │   └── vpc
   │       └── dev-vpc.tf
   ├── modules
   │   └── main-vpc
   │       ├── main.tf
   │       ├── outputs.tf
   │       └── variables.tf
   └── prod
       └── vpc
           └── prod-vpc.tf
```

- Go to the `modules/main-vpc/main.tf` file, add the followings.

```bash
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "terraform-vpc-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = var.public_subnet_cidr
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name = "terraform-public-subnet-${var.environment}"
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block = var.private_subnet_cidr
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name = "terraform-private-subnet-${var.environment}"
  }
}
```
- Go to the `modules/main-vpc/variables.tf` file, add the followings.

```bash
variable "environment" {
  default = "default"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "this is our vpc cidr block"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  description = "this is our public subnet cidr block"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
  description = "this is our private subnet cidr block"
}
```

- Go to the `modules/main-vpc/outputs.tf` file, add the followings.

```bash
output "vpc_id" {
  value = aws_vpc.module_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.module_vpc.cidr_block
}

output "public_subnet_cidr" {
  value = aws_subnet.public_subnet.cidr_block
}

output "private_subnet_cidr" {
  value = aws_subnet.private_subnet.cidr_block
}
```

- Go to the `dev/vpc/dev-vpc.tf` file, add the followings.

```bash
module "tf-vpc" {
  source = "../../modules/main-vpc"
  environment = "DEV"
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}

```
- Go to the `prod/vpc/prod-vpc.tf` file, add the followings.

```bash
module "tf-vpc" {
  source = "../../modules/main-vpc"
  environment = "PROD"
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}

```

- Go to the `dev/vpc` folder and run the command below.

```bash
terraform init

terraform apply
```

- Go to the AWS console and check the VPC and subnets.

- Go to the `prod/vpc` folder and run the command below.

```bash
terraform init

terraform apply
```

- Go to the AWS console and check the VPC and subnets.

### Destroy

The `terraform destroy` command terminates resources defined in your Terraform configuration. This command is the reverse of terraform apply in that it terminates all the resources specified by the configuration. It does not destroy resources running elsewhere that are not described in the current configuration.

- Go to the `prod/vpc` and  `dev/vpc` folders and run the command below.

```bash
terraform destroy
```

- Visit the EC2 console to see the terminated EC2 instance.


