variable "cidir" {
  description = "The CIDR block for the VPC"
      default = "10.0.0.0/16"
  
}

variable "aws_availability_zones" {
  description = "List of availability zones"
    type        = list(string)   
    default     = ["us-east-2a", "us-east-2b"]
  
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default = "eks-vpc-cluster"
  
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  default = ["10.0.1.0/24"]
  
}
variable "private_subnet_tags" {
  description = "Tags for private subnets"
  default = "eks-private-subnet"

}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  default = ["10.0.2.0/24"]
  
}