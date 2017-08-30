provider "aws" {
  region = "${var.aws_region}"
}

data "template_file" "my_userdata" {
  template = "${file("scripts/user_data.sh")}"
}

resource "aws_instance" "example" {
  ami = "${var.image_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [ "${aws_security_group.example.id}" ] 
  key_name = "${var.key_name}"
  user_data = "${data.template_file.my_userdata.rendered}"
  root_block_device {
    volume_size = 8
    delete_on_termination = true
  }
  tags = {
    Name = "${var.instance_tag}"
  }

  provisioner "remote-exec" {
    script = "scripts/wait_for_chef.sh"
    connection {
      type = "ssh"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "360s"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /var/cache/chef",
      "sudo chown ${var.default_user} /var/cache/chef",
      "sudo chmod 0755 /var/cache/chef"
    ]
    connection {
      type = "ssh"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "60s"
    }
  }
}

resource "aws_security_group" "example" {
  name = "${var.sg_name}"
  description = "Test security group."
  vpc_id = "${var.vpc_id}"

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
    Name = "tcp_only"
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
    destination = "/var/cache"
    connection {
      host = "${aws_instance.example.public_dns}"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "60s"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /opt/chef/bin/chef-solo -c /var/cache/chef/solo.rb"
    ]
    connection {
      type = "ssh"
      host = "${aws_instance.example.public_dns}"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "120s"
    }
  }

/**
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
*/
}
