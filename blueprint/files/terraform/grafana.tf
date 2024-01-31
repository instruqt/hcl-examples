variable "prometheus_addr" {
  type        = string
  description = "Prometheus address"
}

variable "grafana_user" {
  type        = string
  description = "Grafana user"
  default = "user"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "grafana_user" "user" {
  email    = "user@example.com"
  login    = var.grafana_user
  password = resource.random_password.password.result
  is_admin = true
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = "prometheus"
  url  = var.prometheus_addr
}

resource "grafana_dashboard" "dashboard" {
  config_json = file("${path.module}/dashboard.json")
}

output "grafana_username" {
  value = resource.grafana_user.user.login
  sensitive = true
}

output "grafana_password" {
  value = resource.random_password.password.result
  sensitive = true
}