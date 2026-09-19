output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Command to update kubeconfig locally"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"

}
# Output the Role ARN so you can use it in your EKS aws-auth or access entries
output "eks_reader_role_arn" {
  description = "ARN of the IAM role for EKS reading"
  value       = aws_iam_role.eks_reader_role.arn
  }