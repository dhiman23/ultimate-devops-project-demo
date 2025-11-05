variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string

}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string

}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)

}

variable "node_groups" {
  description = "Configuration for the EKS node group"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}