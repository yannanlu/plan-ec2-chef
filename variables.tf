variable "aws_region" {
  default = "us-east-2"
}

variable "image_id" {
  default = "ami-8b92b4ee"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {
  default = "subnet-5e7cd125"
}

variable "vpc_id" {
  default = "vpc-e8c95f81"
}

variable "iam_role" {
  default = "S3GetRole"
}

variable "instance_tag" {
  default = "ylu_dev"
}

variable "sg_name" {
  default = "sg_ylu"
}

variable "key_name" {
  default = "ylu"
}

variable "default_user" {
  default = "ubuntu"
}

variable "json_file" {
  default = "node.json"
}

variable "pem_file" {
  type = "string"
}
