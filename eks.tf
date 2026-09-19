module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Gives the user/role that runs terraform admin access to the cluster
  enable_cluster_creator_admin_permissions = true

  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets
  # manage_aws_auth_configmap = true
  # aws_auth_roles = local.aws_eks_role_bindings
access_entries = {
    developer = {
      principal_arn = aws_iam_role.eks_developer_role.arn
      user_name     = "developer"     # <--- Forces K8s to recognize this IAM role as user "developer"
      kubernetes_groups = [] 
      type          = "STANDARD"
      # No cluster-wide policy here, because they are restricted by your namespace RoleBinding
    }
    admin = {
      principal_arn = aws_iam_role.eks_admin_role.arn
      user_name     = "admin"         # <--- Forces K8s to recognize this IAM role as user "admin"
      kubernetes_groups = []
      type          = "STANDARD"
    }
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
}