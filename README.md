# plan-ec2-chef

This is a Terraform plan to provision an EC2 instance with Chef-solo and the cookbooks loaded. Then it runs Chef-solo with the cookbooks on the EC2 instance. All the cookbooks are idempotent which means it is safe to run them multiple times. Currenly, it supports Ubuntu and CentOS only. The web applications of idservice and mbservice have been fully tested with Nginx and Apache. Within the web applications, cookbooks for Nginx, Apache2, Tomcat7, ActiveMQ, MySQL and Postgresql are used.

This Terraform plan treats the EC2 instance immutable on most of the EC2 properties, such as Region, AMI, Type, VPC, Subnet, Volume, etc. It means if any of them needs to be changed, a new instance will be created with the old instance destroyed. But for other server configurations, such as packages, applications, etc, they will be treated as mutable.

This plan also requires access to AWS S3 services. Therefore, it is assumed that a role to access S3 is already set up for the user account. By default, the role of S3GetRole is assigned to the instance at the creation. Make sure to overwrite the name of the role via iam_role if it has a different name. You may also overwrite the default attribute of repo_url in cookbook of qbroker via the varible of qbroker_repo_url.

## Status

Tested with images of Ubuntu and CentOS only

## Description

To check the plan, cd to the directory of the plan and run the following command:
```
terraform plan -var pem_file=~/.ssh/ylu.pem
```

To apply the plan to provision an EC2 instance of Ubuntu 16.04 LTS with the default web application plus the database of Postgresql and the web frontend of Nginx:
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

To apply the plan to provision an EC2 instance of Ubuntu 16.04 LTS with the default web application plus the database of MySQL and the web frontend of Apache2:
```
terraform apply -var pem_file=~/.ssh/ylu.pem -var recipe=mysql
```

To apply the plan to provision an EC2 instance of Centos 7 with the default web application plus the database of Postgresql and the web frontend of Ngnix:
```
terraform apply -var pem_file=~/.ssh/ylu.pem -var-file=centos.tfvars
```

To apply the plan to provision an EC2 instance of Ubuntu 16.04 LTS with the web application of mbservice and the web frontend of Nginx:
```
terraform apply -var pem_file=~/.ssh/ylu.pem -var cookbook=mbservice -var recipe=nginx
```

In order to run this plan, the path of the ssh private key file for the key_name has to be specified in the command line under the var name of pem_file. It is also assumed that ~/.aws/credentials is set up with the access_key and secret_key. Further more, it is also assuemd that the ssh key pair has been set up on the AWS region. The default values of the following variables may need to be customized to fit your choice:

| Name                         | Value                | Description                    | File                  |
| ---                          | ---                  | ---                            | ---                   |
| key_name                     | ylu                  | name of your ssh key on AWS    | variables.tf          |
| sg_name                      | sg_ylu               | name of the security group     | variables.tf          |
| instance_tag                 | ylu_dev              | tag name for your EC2 instance | variables.tf          |
| instance_type                | t2.micro             | type of EC2 instance           | variables.tf          |
| image_id                     | ami-8b92b4ee         | AMI id for your OS platform    | variables.tf          |
| aws_region                   | us-east-2            | EC2 region of AWS              | variables.tf          |
| vpc_id                       | vpc-e8c95f81         | id of an existing VPC          | variables.tf          |
| subnect_id                   | subnet-5e7cd125      | id of a Subnet on the VPC      | variables.tf          |
| iam_role                     | S3GetRole            | IAM role for the instance      | variables.tf          |
| default_user                 | ubuntu               | default user for ssh           | variables.tf          |
| json_file                    | node.json            | json file for chef-solo        | variables.tf          |
| cookbook                     | idservice            | name of the wrapper cookbook   | variables.tf          |
| recipe                       | postgresql           | name of the recipe             | variables.tf          |
| extra_rule_port              | 0                    | port number of the rule        | variables.tf          |
| extra_rule_cidr              | 0.0.0.0/0            | cidr string of the rule        | variables.tf          |
| qbroker_repo_url             | s3://ylutest/qbroker | url of the qbroker repo        | variables.tf          |

## Author
Yannan Lu <yannanlu@yahoo.com>

## See Also
* [Terraform Docs] (https://www.terraform.io/docs/index.html)
* [Chef Docs] (https://docs.chef.io)
* [CentOS EC2 AMI List] (https://wiki.centos.org/Cloud/AWS)
* [Ubuntu EC2 AMI Finder] (https://cloud-images.ubuntu.com/locator/ec2/)
