# 09_values.auto.tfvars

plan_tags = {
  Plan = "09-GitLab-Runner"
}

private_ingress_controller_ns_name = "priv-ingress-nginx"
private_ingress_load_balancer_ip   = "10.1.1.6"
cert_manager_ns_name               = "cert-manager"

private_dns_zone_name = "private.contoso.com"

