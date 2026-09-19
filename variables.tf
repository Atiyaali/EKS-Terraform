variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.30"
}

variable "admin_user" {
  type        = string
  description = "ARN of the admin user"
}

variable "developer_user" {
  type        = string
  description = "ARN of the developer user"
}