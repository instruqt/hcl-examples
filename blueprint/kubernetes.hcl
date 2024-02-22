resource "k8s_cluster" "k8s" {
  network {
    id = resource.network.main.meta.id
  }
}

resource "helm" "prometheus" {
  cluster = resource.k8s_cluster.k8s

  repository {
    name = "prometheus-community"
    url  = "https://prometheus-community.github.io/helm-charts"
  }

  chart   = "prometheus-community/prometheus"
  version = "25.11.0"

  values = "files/prometheus-values.yaml"

  health_check {
    timeout = "240s"
    pods    = ["app.kubernetes.io/name=prometheus"]
  }
}

resource "helm" "grafana" {
  cluster = resource.k8s_cluster.k8s

  repository {
    name = "grafana"
    url  = "https://grafana.github.io/helm-charts"
  }

  chart   = "grafana/grafana"
  version = "7.3.0"

  values = "files/grafana-values.yaml"

  health_check {
    timeout = "240s"
    pods    = ["app.kubernetes.io/name=grafana"]
  }
}

resource "ingress" "prometheus_http" {
  depends_on = ["resource.helm.prometheus"]

  port = 9090

  target {
    resource = resource.k8s_cluster.k8s
    port = 80

    config = {
      service   = "prometheus-server"
      namespace = "default"
    }
  }
}

resource "ingress" "grafana_http" {
  depends_on = ["resource.helm.grafana"]

  port = 3000

  target {
    resource = resource.k8s_cluster.k8s
    port = 80

    config = {
      service   = "grafana"
      namespace = "default"
    }
  }
}

output "PROMETHEUS_ADDR" {
  value = resource.ingress.prometheus_http.local_address
}

output "GRAFANA_ADDR" {
  value = resource.ingress.grafana_http.local_address
}

output "KUBECONFIG" {
  value = resource.k8s_cluster.k8s.kubeconfig
}