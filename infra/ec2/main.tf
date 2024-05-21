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

output "ta_ec2_instance_ip" {
  value = aws_instance.ta_ec2.public_ip
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
  # to write remote provisioner - it's important else local exec will fail because that doesnot wait for vm to create
  provisioner "remote-exec" {
    inline = [ "sleep 30 | sudo hostnamectl set-hostname cloudEc2.technox.com" ]
    connection {
      host        = self.public_ip #aws_instance.ta_ec2_instance_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/var/mykeys/sshkey-RSA.pem")
    }
  }

  # to write local provisioner ## command to save the public dns of ec2 in inventory file.
  provisioner "local-exec" {
    #command = "echo ${self.public_dns} > ../ansible/inventory"
    command = "echo ${self.public_ip} > ../ansible/inventory"
    
  }

  provisioner "local-exec" {
      command = "ansible-playbook -i ../ansible/inventory -u ec2-user --private-key /var/mykeys/sshkey-RSA.pem ../ansible/ansible.yml"
                #ansible-playbook -i inventory -u ec2-user --private-key /var/mykeys/sshkey-RSA.pem ansible.yml
    #command = "ansible all -m shell -a 'yum -y install httpd; systemctl restart httpd'"
  }


  # to write local provisioner for ansible.yml



}
