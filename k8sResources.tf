resource "kubernetes_namespace" "wandarlust" {
  metadata {
    name = "wandarlust-namespace"
  }
}
resource "kubernetes_role" "developer_role" {
  metadata {
    name = "developer-role"
    namespace = kubernetes_namespace.wandarlust.metadata[0].name
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["pods", "services", "configmaps"]
    verbs          = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets", "daemonsets"]
    verbs      = ["get", "list","watch"]
  }
}
resource "kubernetes_role_binding" "developer_binding" {
  metadata {
    name      = "developer-binding"
    namespace = kubernetes_namespace.wandarlust.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "developer-role"
  }
  subject {
    kind      = "User"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }
 
}

resource "kubernetes_cluster_role" "admin_role" {
  metadata {
    name = "admin-role"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}
resource "kubernetes_cluster_role_binding" "admin_binding" {
  metadata {
    name = "admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin-role"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

