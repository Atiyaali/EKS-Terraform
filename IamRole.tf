locals {
    aws_eks_role_bindings = [
        {
            rolearn  = aws_iam_role.eks_developer_role.arn
            username = "developer"
            groups   = ["none"]
        },
        {
            rolearn  = aws_iam_role.eks_admin_role.arn
            username = "admin"
            groups   = ["none"]
        }
    ]
}

# 1. Define Trust Policy for Admin (using correct 'var.' syntax)
data "aws_iam_policy_document" "assume_role_admin" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.admin_user]
    }
  }
}

# 2. Define Trust Policy for Developer
data "aws_iam_policy_document" "assume_role_developer" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.developer_user]
    }
  }
}

# 3. Define Read-Only Permissions Policy
data "aws_iam_policy_document" "eks_readonly" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters"
    ]
    resources = ["*"]
  }
}

# 4. Define Full-Access Permissions Policy for Admin
data "aws_iam_policy_document" "eks_admin" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters"
    ]
    resources = ["*"]
  }
}

# 5. Create Developer IAM Role & Attach Policy
resource "aws_iam_role" "eks_developer_role" {
  name               = "EKSDeveloperRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_developer.json
}

resource "aws_iam_role_policy" "eks_developer_policy_attachment" {
  name   = "EKSDeveloperPolicy"
  role   = aws_iam_role.eks_developer_role.id
  policy = data.aws_iam_policy_document.eks_readonly.json
}

# 6. Create Admin IAM Role & Attach Full Policy
resource "aws_iam_role" "eks_admin_role" {
  name               = "EKSAdminRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_admin.json
}

resource "aws_iam_role_policy" "eks_admin_policy_attachment" {
  name   = "EKSAdminPolicy"
  role   = aws_iam_role.eks_admin_role.id
  policy = data.aws_iam_policy_document.eks_admin.json
}