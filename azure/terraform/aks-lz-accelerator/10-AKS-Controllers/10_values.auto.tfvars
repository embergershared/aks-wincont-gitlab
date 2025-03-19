# 10_values.auto.tfvars

plan_tags = {
  Plan = "10-AKS-Controllers"
}

private_ingress_controller_ns_name = "internal-ing-ctrl"
private_ingress_load_balancer_ip   = "10.1.1.7"

cert_manager_ns_name       = "cert-manager"
certificate_ca_issuer_name = "hww-poc-ca-cluster-issuer"
