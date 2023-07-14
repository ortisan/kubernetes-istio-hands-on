
# resource "helm_release" "rancher" {
#   repository       = "https://releases.rancher.com/server-charts/latest"
#   chart            = "rancher"
#   name             = "rancher"
#   namespace        = "cattle-system"
#   create_namespace = true
#   version          = var.rancher_version
# }

