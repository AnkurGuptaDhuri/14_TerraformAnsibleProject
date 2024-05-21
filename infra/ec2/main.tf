variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "subnet_id" {}
variable "sg_enable_ssh_https" {}
variable "enable_public_ip_address" {}
variable "user_data" {}
variable "ec2_key_pair" {}

##output values for other modules.
output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /home/ec2-user/keys/aws_ec2_terraform ec2-user@", aws_instance.ta_ec2.public_ip)
}

output "ta_ec2_instance_id" {
  value = aws_instance.ta_ec2.id
}

output "ta_ec2_instance_dns" {
  value = aws_instance.ta_ec2.public_dns
}

# Resource Creation e.g. EC2
resource "aws_instance" "ta_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = var.ec2_key_pair  #"aws_key"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_enable_ssh_https,] #, var.ec2_sg_name_for_python_api]
  associate_public_ip_address = var.enable_public_ip_address
  user_data = var.user_data

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
/*
  # to write remote provisioner
  provisioner "remote-exec" {
    inline = [ "sudo hostnamectl set-hostname cloudEc2.technox.com" ]
    connection {
      host        = aws_instance.ta_ec2public_dns
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("../../AWSPractice/ec2-keypair.pem")
    }
  }
*/
  # to write local provisioner ## command to save the public dns of ec2 in inventory file.
  provisioner "local-exec" {
    command = "echo ${self.public_dns} > ../ansible/inventory"
  }
/*
  provisioner "local-exec" {
      command = "ansible-playbook ../ansible/ansible.yml"
    #command = "ansible all -m shell -a 'yum -y install httpd; systemctl restart httpd'"
  }

*/
  # to write local provisioner for ansible.yml



}

/*
resource "aws_key_pair" "ta_public_key" {
  key_name   = "aws_key"
  public_key = var.public_key
}
*/