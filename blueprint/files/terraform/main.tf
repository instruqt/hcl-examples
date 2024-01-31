terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "2.10.0"
    }
  }
}

provider "grafana" {}