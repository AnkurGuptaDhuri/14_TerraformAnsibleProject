

module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  availability_zone = var.availability_zone
}

module "security-group"{
    source = "./security-group"
    ec2_sg_name = "SG for EC2 to enable SSH(22) and HTTP(80)"
    vpc_id = module.networking.ta_vpc_id
    public_subnet_cidr_block = module.networking.public_subnet_cidr_block
}

module "ec2" {
    source = "./ec2"
    ami_id = var.ec2_ami_id
    instance_type = var.instance_type
    tag_name = "Amazon linux EC2"
    ec2_key_pair = var.ec2_key_pair
    subnet_id = module.networking.ta_public_subnets_id
    sg_enable_ssh_https = module.security-group.sg_ec2_sg_ssh_http_id
    enable_public_ip_address = true
    user_data = templatefile("./script/ec2-script.sh",{})   
}