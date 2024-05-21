terraform {
  backend "s3" {
    bucket = "14"   #bucket is created manually in S3
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}