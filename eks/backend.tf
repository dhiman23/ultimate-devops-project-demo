terraform {
  backend "s3" {
    bucket         = "terra-bucket-12"
    key            = "opentelementry-v1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-lock-table"
    encrypt        = true
  }
}