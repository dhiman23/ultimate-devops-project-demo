resource "aws_dynamodb_table" "my_table" {
  name         = "my-lock-dbtable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

module "vpc" {
  source               = "./modules/vpc"
  cidr                 = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  node_groups     = var.node_groups

}