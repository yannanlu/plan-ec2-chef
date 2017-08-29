# plan-ec2-chef

This is a Terraform plan to provision an EC2 instance with Chef-solo and the cookbooks loaded. Then it runs Chef-solo on the cookbooks on the EC2 instance. All the cookbooks are idempotent which means it is safe to run them multiple times. Currenly, it supports Ubuntu and CentOS only. The web applications of mbservice has been fully tested. Within the web application, cookbooks for Nginx, Tomcat7 and ActiveMQ are used.

This Terraform plan treats the EC2 instance immutable on its EC2 properties, such as AMI, Type, VPC, Security Group, Networks, Volume, etc. It means if any of them needs to be changed, a new instance has to be created with the old instance destroyed. But for other server configurations, such as packages, applications, etc, they will be treated as mutable.

## Status

Tested with images of Ubuntu and CentOS only

## Description

To run the plan to provision an EC2 instance of Ubuntu 16.04 LTS with the default web application:
```
terraform apply
```

To terminate the launched instances:
```
terraform destroy
```

To list the launched instances:
```
terraform show
```

In order to run this playbook, the path of the ssh private key file for the key_name has to be specified in the command line under the var name of pem_file. It is also assumed that ~/.aws/credentials is set up with the access_key and secret_key. Further more, it is also assuemd that the ssh key pair has been set up on the AWS region. The following default variables will need to be customized to fit your choice:

| Name                         | Value           | Description                    | File                                 |
| ---                          | ---             | ---                            | ---                                  |
| key_name                     | ylu             | name of your ssh key on AWS    | roles/ec2_launcher/defaults/main.yml |
| sg_name                      | ylu_sg          | name of the security group     | roles/ec2_launcher/defaults/main.yml |
| instance_tag                 | ylu_test        | tag name for your EC2 instance | roles/ec2_launcher/defaults/main.yml |
| instance_type                | t2.micro        | type of EC2 instance           | roles/ec2_launcher/defaults/main.yml |
| image_id                     | ami-8b92b4ee    | AMI of Ubuntu 16.04 LTS        | roles/ec2_launcher/defaults/main.yml |
| aws_region                   | us-east-2       | EC2 region of AWS              | roles/ec2_launcher/defaults/main.yml |
| vpc_id                       | vpc-e8c95f81    | id of an existing VPC          | roles/ec2_launcher/defaults/main.yml |
| subnect_id                   | subnet-5e7cd125 | id of a Subnet on the VPC      | roles/ec2_launcher/defaults/main.yml |
| default_user                 | ec2-user        | default user for ssh           | roles/ec2_launcher/defaults/main.yml |

## Author
Yannan Lu <yannanlu@yahoo.com>

## See Also
* [CentOS EC2 AMI List] (https://wiki.centos.org/Cloud/AWS)
* [Ubuntu EC2 AMI Finder] (https://cloud-images.ubuntu.com/locator/ec2/)
