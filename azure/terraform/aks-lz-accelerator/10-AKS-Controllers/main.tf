resource "kubernetes_namespace" "ing_ns" {
  metadata {
    name = var.private_ingress_controller_ns_name
  }
}

resource "helm_release" "private_ingress_controller_release" {
  depends_on = [
    kubernetes_namespace.ing_ns,
  ]

  namespace = kubernetes_namespace.ing_ns.metadata[0].name
  name      = "private-ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  # Additional settings
  cleanup_on_fail = true # default= false

  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "ingress-basic/default-ingress-tls"
  }
  set {
    name  = "controller.replicaCount"
    value = "2"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
  set {
    name  = "controller.ingressClass"
    value = "nginx-internal"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "true"
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = "10.1.1.6"
  }
}
