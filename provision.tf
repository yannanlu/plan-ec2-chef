provider "aws" {
  region = "${var.aws_region}"
}

data "template_file" "my_userdata" {
  template = "${file("scripts/user_data.sh")}"
}

data "template_file" "my_jsonfile" {
  template = "${file("templates/${var.json_file}.tpl")}"

  vars {
    qbroker_repo_url = "${var.qbroker_repo_url}"
    cookbook = "${var.cookbook}"
    recipe = "${var.recipe}"
  }
}

resource "aws_instance" "example" {
  count = 1
  ami = "${var.image_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [ "${aws_security_group.example.id}" ] 
  iam_instance_profile = "${var.iam_role}"
  key_name = "${var.key_name}"
  user_data = "${data.template_file.my_userdata.rendered}"
  root_block_device {
    volume_size = 8
    delete_on_termination = true
  }
  tags = {
    Name = "${var.instance_tag}"
  }
  timeouts = {
    create = "600s"
    delete = "360s"
  }

  provisioner "remote-exec" {
    script = "scripts/wait_for_chef.sh"
    connection {
      type = "ssh"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "150s"
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
      timeout = "150s"
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
    cidr_blocks = ["170.140.0.0/16", "75.131.197.0/24"]
  }

  ingress {
    from_port   = 2812
    to_port     = 2812
    protocol    = "tcp"
    cidr_blocks = ["170.140.0.0/16", "75.131.197.0/24"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["170.140.0.0/16", "75.131.197.0/24"]
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

resource "aws_security_group_rule" "extra_rule" {
  count             = "${replace(var.extra_rule_port, "/^[1-9][0-9]*$/", "1")}"
  type              = "ingress"
  from_port         = "${var.extra_rule_port}"
  to_port           = "${var.extra_rule_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.extra_rule_cidr}"]
  security_group_id = "${aws_security_group.example.id}"
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
    source = "cookbooks"
    destination = "/var/cache/chef"
    connection {
      host = "${aws_instance.example.public_dns}"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "60s"
    }
  }

  provisioner "file" {
    source = "solo.rb"
    destination = "/var/cache/chef/solo.rb"
    connection {
      host = "${aws_instance.example.public_dns}"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "60s"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cat > /var/cache/chef/node.json <<EOF\n${data.template_file.my_jsonfile.rendered}\nEOF",
      "sudo -H /opt/chef/bin/chef-solo -c /var/cache/chef/solo.rb -j /var/cache/chef/node.json"
    ]
    connection {
      type = "ssh"
      host = "${aws_instance.example.public_dns}"
      user = "${var.default_user}"
      private_key = "${file("${var.pem_file}")}"
      timeout = "60s"
    }
  }

/**
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
*/
}
