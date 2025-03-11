resource "kubernetes_namespace" "tt_ns" {
  metadata {
    name = var.time_tracker_ns_name
  }
}

resource "helm_release" "time_tracker" {
  depends_on = [
    kubernetes_namespace.tt_ns,
  ]

  namespace = kubernetes_namespace.tt_ns.metadata[0].name

  name    = var.helm_release_name
  chart   = "./time-tracker"
  version = "0.1.0"

  # Additional settings
  cleanup_on_fail = true # default= false

  set {
    name  = "deployment.image.repository"
    value = var.docker_image_name
  }
  set {
    name  = "deployment.image.tag"
    value = var.docker_image_tag
  }
  set {
    name  = "deployment.envFromKeyVault.secretName"
    value = lower(data.azurerm_key_vault_secret.cs_secret.name)
  }
}
