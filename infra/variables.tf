variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "VPC name: Terraform Ansible"
}

variable "cidr_public_subnet"{
    type = string
    description = "public subnet for ec2"
}

variable "availability_zone"{
    type = string
    description = "availability_zone for this project"
}

variable "ec2_ami_id"{
    type = string
    description = "amazon linux ami of ec2"
}

variable "ec2_key_pair"{
    type = string
    description = "key-pair - already exist in account"
}

variable "region"{
    type = string
    description = "region to be utilized in aws e.g. eu-north-1"
}

variable instance_type{
    type = string
    description = "Ec2 instance type e.g. t3-micro, t2- micro"
}