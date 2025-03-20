#############   Private Nginx Ingress Controller on   #############
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
    name  = "controller.ingressClassResource.name"
    value = "nginx-internal"
  }
  set {
    name  = "controller.ingressClassResource.default"
    value = "true"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "true"
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = var.private_ingress_load_balancer_ip
  }
}

#############   Cert Manager   #############
# Cert Manager to issue and register Ingress TLS certificates
resource "kubernetes_namespace" "cert_manager_ns" {
  metadata {
    name = var.cert_manager_ns_name
  }
}
resource "helm_release" "cert_manager_release" {
  depends_on = [
    kubernetes_namespace.cert_manager_ns,
  ]

  namespace = kubernetes_namespace.cert_manager_ns.metadata[0].name
  name      = "cert-manager"

  repository = "https://charts.jetstack.io/"
  chart      = "cert-manager"
  version    = "v1.17.0"

  # Additional settings
  cleanup_on_fail = true # default= false

  set {
    name  = "installCRDs"
    value = "true"
  }
}

/*
# Boot strap the Cert issuer for all cluster based on a self-signed certificate
# https://cert-manager.io/docs/configuration/selfsigned/#bootstrapping-ca-issuers

resource "kubernetes_manifest" "cluster_issuer_self_signed" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "${var.self_signed_cluster_issuer_name}"
    }
    spec = {
      selfSigned = {}
    }
  }

  depends_on = [
    helm_release.cert_manager_release,
    time_sleep.wait
  ]
}

resource "kubernetes_manifest" "poc_root_ca" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "${var.root_ca_name}"
      namespace = "${kubernetes_namespace.cert_manager_ns.metadata[0].name}"
    }
    spec = {
      isCA = "true"
      # commonName = "${upper(local.aks_name)} - AKS Cluster CA"
      literalSubject = "O=jetstack, CN=\"${upper(local.aks_name)} - AKS Cluster CA\", OU=\"Test OU\""
      secretName     = "${var.root_ca_certificate_name}"
      privateKey = {
        # algorithm = "ECDSA"
        # size      = 256
        algorithm = "RSA"
        encoding  = "PKCS1"
        size      = 4096
      }
      issuerRef = {
        name  = "${kubernetes_manifest.cluster_issuer_self_signed.manifest.metadata.name}" #"${local.self_signed_cluster_issuer_name}"
        kind  = "ClusterIssuer"
        group = "cert-manager.io"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.cert_manager_ns,
    kubernetes_manifest.cluster_issuer_self_signed
  ]
}

# Cluster Issuer for the entire cluster using the CA certificate
resource "kubernetes_manifest" "cluster_issuer_poc_ca" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "${var.certificate_ca_issuer_name}"
    }
    spec = {
      ca = {
        secretName = "${kubernetes_manifest.poc_root_ca.manifest.spec.secretName}"
      }
    }
  }

  depends_on = [
    kubernetes_manifest.poc_root_ca
  ]
}
#*/


