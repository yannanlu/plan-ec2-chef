# plan-ec2-chef

This is a Terraform plan to provision an EC2 instance with Chef-solo and the cookbooks loaded. Then it runs Chef-solo with the cookbooks on the EC2 instance. All the cookbooks are idempotent which means it is safe to run them multiple times. Currenly, it supports Ubuntu and CentOS only. The default web application of mbservice has been fully tested with Nginx and Apache. Within the web application, cookbooks for Nginx, Apache2, Tomcat7 and ActiveMQ are used.

This Terraform plan treats the EC2 instance immutable on most of the EC2 properties, such as AMI, Type, VPC, Networks, Volume, etc. It means if any of them needs to be changed, a new instance has to be created with the old instance destroyed. But for other server configurations, such as packages, applications, etc, they will be treated as mutable.

## Status

Tested with images of Ubuntu and CentOS only

## Description

To check the plan, cd to the directory of the plan and run the following command:
```
terraform plan -var pem_file=~/.ssh/ylu.pem
```

To apply the plan to provision an EC2 instance of Ubuntu 16.04 LTS with the default web application and the web frontend of Nginx:
```
terraform apply -var pem_file=~/.ssh/ylu.pem
```

To terminate the launched instances:
```
terraform destroy -force -var pem_file=~/.ssh/ylu.pem
```

To show the state of the launched instances:
```
terraform show
```

To apply the plan to provision an EC2 instance of Ubuntu 16.04 LTS with the default web application and the web frontend of Apache:
```
terraform apply -var pem_file=~/.ssh/ylu.pem -var json_file=apache.json
```

To apply the plan to provision an EC2 instance of Centos 7 with the default web application and the web frontend of Nginx:
```
terraform apply -var pem_file=~/.ssh/ylu.pem -var-file=centos.tfvars
```

In order to run this plan, the path of the ssh private key file for the key_name has to be specified in the command line under the var name of pem_file. It is also assumed that ~/.aws/credentials is set up with the access_key and secret_key. Further more, it is also assuemd that the ssh key pair has been set up on the AWS region. The following default variables will need to be customized to fit your choice:

| Name                         | Value           | Description                    | File                                 |
| ---                          | ---             | ---                            | ---                                  |
| key_name                     | ylu             | name of your ssh key on AWS    | variables.tf, centos.tfvars          |
| sg_name                      | sg_ylu          | name of the security group     | variables.tf, centos.tfvars          |
| instance_tag                 | ylu_dev         | tag name for your EC2 instance | variables.tf, centos.tfvars          |
| instance_type                | t2.micro        | type of EC2 instance           | variables.tf, centos.tfvars          |
| image_id                     | ami-8b92b4ee    | AMI id for your OS platform    | variables.tf, centos.tfvars          |
| aws_region                   | us-east-2       | EC2 region of AWS              | variables.tf, centos.tfvars          |
| vpc_id                       | vpc-e8c95f81    | id of an existing VPC          | variables.tf, centos.tfvars          |
| subnect_id                   | subnet-5e7cd125 | id of a Subnet on the VPC      | variables.tf, centos.tfvars          |
| default_user                 | ubuntu          | default user for ssh           | variables.tf, centos.tfvars          |
| json_file                    | node.json       | json file for chef-solo        | variables.tf                         |

## Author
Yannan Lu <yannanlu@yahoo.com>

## See Also
* [Terraform Docs] (https://www.terraform.io/docs/index.html)
* [Chef Docs] (https://docs.chef.io)
* [CentOS EC2 AMI List] (https://wiki.centos.org/Cloud/AWS)
* [Ubuntu EC2 AMI Finder] (https://cloud-images.ubuntu.com/locator/ec2/)
