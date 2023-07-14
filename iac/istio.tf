# Istio

locals {
  create_istio = (var.create_istio) ? 1 : 0
}
resource "aws_security_group_rule" "istio_status" {
  count             = local.create_istio
  description       = "Istio status ingress"
  protocol          = "tcp"
  security_group_id = module.eks.node_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 31371
  to_port           = 31371
  type              = "ingress"
  depends_on        = [module.eks]
}

resource "helm_release" "istio_base" {
  count            = local.create_istio
  name             = "istio-base"
  chart            = "./helm/istio-1.18.0/charts/base"
  namespace        = "istio-system"
  create_namespace = true
  set {
    name  = "global.hub"
    value = "${var.docker_hub}/istio"
  }
}

resource "helm_release" "istio_discovery" {
  count      = local.create_istio
  name       = "istiod"
  chart      = "./helm/istio-1.18.0/charts/istio-control/istio-discovery"
  namespace  = "istio-system"
  depends_on = [helm_release.istio_base]
  set {
    name  = "global.hub"
    value = "${var.docker_hub}/istio"
  }
}

resource "helm_release" "istio_operator" {
  count     = local.create_istio
  name      = "istio-operator"
  chart     = "./helm/istio-1.18.0/charts/istio-operator"
  namespace = "istio-system"

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  count     = local.create_istio
  name      = "istio-ingress"
  chart     = "./helm/istio-1.18.0/charts/gateways/istio-ingress"
  namespace = "istio-system"
  set {
    name  = "global.hub"
    value = "${var.docker_hub}/istio"
  }

  set {
    name  = "gateways.istio-ingressgateway.autoscaleMin"
    value = 1
  }
  depends_on = [helm_release.istio_base, helm_release.istio_discovery]

}

resource "helm_release" "istio_egress" {
  count      = local.create_istio
  name       = "istio-egress"
  chart      = "./helm/istio-1.18.0/charts/gateways/istio-egress"
  namespace  = "istio-system"
  depends_on = [helm_release.istio_base, helm_release.istio_discovery]
  set {
    name  = "global.hub"
    value = "${var.docker_hub}/istio"
  }

  set {
    name  = "gateways.istio-egressgateway.autoscaleMin"
    value = 1
  }
}

resource "kubectl_manifest" "tg_binding" {
  count     = local.create_istio
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: istio-tgb-80-nlb
  namespace: istio-system
spec:
  serviceRef:
    name: istio-ingressgateway # route traffic to the awesome-service
    port: 80
  targetGroupARN: ${aws_lb_target_group.istio.arn}
  targetType: instance # Instance for EC2, IP for fargate
  networking:
    ingress:
    - from:
      - ipBlock:
          cidr: 0.0.0.0/0 # subnet-1 cidr
      ports:
      - protocol: TCP # Allow all TCP traffic from ALB SG
        port: 31381 # NodePort from Istio Ingress
YAML

  depends_on = [
    aws_lb.eks,
    aws_lb_target_group.istio,
    helm_release.aws_load_balancer,
    helm_release.istio_ingress
  ]
}


resource "kubectl_manifest" "ingress_daemonset" {
  count     = local.create_istio
  yaml_body = <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio-ingress-daemonset
  namespace: istio-system
spec:
  components:
    ingressGateways:
    - name: istio-ingressgateway
      enabled: true
      k8s:
        overlays:
        - apiVersion: apps/v1
          kind: Deployment
          name: istio-ingressgateway
          patches:
          - path: kind
            value: DaemonSet
          - path: spec.strategy
          - path: spec.updateStrategy
            value:
              rollingUpdate:
                maxUnavailable: 1
              type: RollingUpdate
        - apiVersion: apps/v1
          kind: Service
          name: istio-ingressgateway
          patches:
          - path: spec.type
            value: NodePort
EOF

  depends_on = [
    helm_release.istio_ingress,
    helm_release.istio_operator
  ]
}

resource "kubectl_manifest" "istio_gateway" {
  count     = local.create_istio
  yaml_body = <<EOF
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: ${module.eks.cluster_name}-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
EOF

  depends_on = [
    helm_release.istio_ingress,
    helm_release.istio_operator
  ]
}





# resource "kubernetes_namespace" "istio_ingress" {
#   metadata {
#     labels = {
#       istio-injection = "enabled"
#     }
#     name = "istio-ingress"
#   }
# }

# resource "helm_release" "istio-base" {
#   repository       = var.istio_charts_url
#   chart            = "base"
#   name             = "istio-base"
#   create_namespace = true
#   namespace        = "istio-system"
#   version          = var.istio_version
#   depends_on       = [module.eks.eks_managed_node_groups]
# }

# resource "helm_release" "istiod" {
#   repository = var.istio_charts_url
#   chart      = "istiod"
#   name       = "istiod"
#   namespace  = "istio-system"
#   version    = var.istio_version
#   depends_on = [helm_release.istio-base, module.eks.eks_managed_node_groups]
# }

# # resource "helm_release" "istio-ingress" {
# #   repository = var.istio_charts_url
# #   chart      = "gateway"
# #   name       = "istio-ingress"
# #   namespace  = kubernetes_namespace.istio_ingress.id
# #   version    = var.istio_version
# #   depends_on = [helm_release.istiod, module.eks.eks_managed_node_groups]
# # }
