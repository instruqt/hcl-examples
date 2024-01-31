resource "k8s_cluster" "k8s" {
  network {
    id = resource.network.main.id
  }

  copy_image {
    name = "grafana/grafana:10.3.1"
  }
  
  copy_image {
    name = "rancher/local-path-provisioner:v0.0.24"
  }

  copy_image {
    name = "rancher/mirrored-coredns-coredns:1.10.1"
  }

  copy_image {
    name = "rancher/mirrored-library-busybox:1.34.1"
  }

  copy_image {
    name = "rancher/mirrored-metrics-server:v0.6.3"
  }

  copy_image {
    name = "rancher/mirrored-pause:3.6"
  }

  copy_image {
    name = "ghcr.io/jumppad-labs/connector:v0.2.1"
  }

  copy_image {
    name = "quay.io/prometheus-operator/prometheus-config-reloader:v0.71.2"
  }

  copy_image {
    name = "quay.io/prometheus/alertmanager:v0.26.0"
  }

  copy_image {
    name = "quay.io/prometheus/node-exporter:v1.7.0"
  }

  copy_image {
    name = "quay.io/prometheus/prometheus:v2.49.1"
  }

  copy_image {
    name = "quay.io/prometheus/pushgateway:v1.7.0"
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