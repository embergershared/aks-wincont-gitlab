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

  name  = "tf-test1" # <= Helm release name
  chart = "./time-tracker"

  # Additional settings
  cleanup_on_fail = true # default= false

  set {
    name  = "deployment.image.repository"
    value = "acrakslzaccel234.azurecr.io/timetracker"
  }
  set {
    name  = "deployment.image.tag"
    value = "latest"
  }
}
