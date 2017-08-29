provider "aws" {
  region = "us-east-2"
}

data "template_file" "my_userdata" {
  template = "${file("scripts/user_data.sh")}"
}

resource "aws_instance" "example" {
  ami = "ami-8b92b4ee"
  instance_type = "t2.micro"
  subnet_id = "subnet-5e7cd125"
  vpc_security_group_ids = [ "${aws_security_group.example.id}" ] 
  key_name = "ylu"
  user_data = "${data.template_file.my_userdata.rendered}"
  tags = {
    Name = "ylu_dev"
  }

  provisioner "remote-exec" {
    script = "scripts/wait_for_chef.sh"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("~/.ssh/ylu.pem")}"
      timeout = "120s"
    }
  }
}

resource "aws_security_group" "example" {
  name = "sg_ylu"
  description = "Test security group."
  vpc_id = "vpc-e8c95f81"

  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["170.140.201.0/24", "75.131.197.0/24"]
  }

  ingress {
    from_port   = 2812
    to_port     = 2812
    protocol    = "tcp"
    cidr_blocks = ["170.140.201.0/24", "75.131.197.0/24"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["170.140.201.0/24", "75.131.197.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "ssh_only"
  }
}

output "public_dns" {
  value = "${aws_instance.example.public_dns}"
}

/* the publi ip will be released if an eip is assigned to the instance */
/**
resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
  depends_on = ["aws_instance.example"]
}

output "elastic_ip" {
  value = "${aws_eip.ip.public_ip}"
}
*/

resource "null_resource" "chef" {
  triggers {
    version = "${timestamp()}"
  }

  provisioner "file" {
    source = "chef"
    destination = "/home/ubuntu"
    connection {
      host = "${aws_instance.example.public_dns}"
      user = "ubuntu"
      private_key = "${file("~/.ssh/ylu.pem")}"
      timeout = "60s"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /opt/chef/bin/chef-solo -c ~/chef/solo.rb"
    ]
    connection {
      type = "ssh"
      host = "${aws_instance.example.public_dns}"
      user = "ubuntu"
      private_key = "${file("~/.ssh/ylu.pem")}"
      timeout = "120s"
    }
  }

/**
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
*/
}
