terraform {
  backend "s3" {
    bucket         = "terra-bucket-12"
    key            = "opentelementry-v1/terraform.tfstate"
  dynamodb_table = "my-lock-table"
    region         = "us-east-1"
    encrypt        = true
  }
}