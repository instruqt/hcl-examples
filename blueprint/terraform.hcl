resource "terraform" "configure_grafana" {
  network {
    id = resource.network.main.meta.id
  }

  version = "1.6.4"

  source = "files/terraform"
  environment = {
    GRAFANA_AUTH = "admin:admin"
    GRAFANA_URL = "http://${resource.ingress.grafana_http.local_address}"
  }

  variables = {
    prometheus_addr = "http://${resource.ingress.prometheus_http.local_address}"
  }
}