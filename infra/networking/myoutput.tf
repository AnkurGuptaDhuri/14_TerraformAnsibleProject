output "ta_vpc_id" {
    value = aws_vpc.ta_vpc.id
}

output "ta_public_subnets_id" {
  value = aws_subnet.ta_public_subnets.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.ta_public_subnets.cidr_block
}