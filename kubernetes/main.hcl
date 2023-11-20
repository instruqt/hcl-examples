resource "network" "main" {
  subnet = "100.0.10.0/24"
}

resource "kubernetes_cluster" "k8s" {
  network {
    id = resource.network.main.id
  }
}

resource "helm" "vault" {
  cluster = resource.kubernetes_cluster.k8s

  repository {
    name = "hashicorp"
    url  = "https://helm.releases.hashicorp.com"
  }

  chart   = "hashicorp/vault"
  version = "v0.18.0"

  values = "files/vault-values.yaml"

  health_check {
    timeout = "240s"
    pods    = ["app.kubernetes.io/name=vault"]
  }
}

resource "kubernetes_config" "app" {
  depends_on = ["resource.helm.vault"]

  cluster = resource.kubernetes_cluster.k8s

  paths = ["files/web-service.yaml"]

  wait_until_ready = true

  health_check {
    timeout = "240s"
    pods    = ["app.kubernetes.io/name=web-service"]
  }
}

resource "ingress" "vault_http" {
  port = 8200

  target {
    resource = resource.kubernetes_cluster.k8s
    port = 8200

    config = {
      service   = "vault"
      namespace = "default"
    }
  }
}

resource "ingress" "web_service" {
  port = 9090

  target {
    resource = resource.kubernetes_cluster.k8s
    port = 9090

    config = {
      service   = "web-service"
      namespace = "default"
    }
  }
}

output "VAULT_ADDR" {
  value = resource.ingress.vault_http.local_address
}

output "WEB_ADDR" {
  value = resource.ingress.web_service.local_address
}

output "KUBECONFIG" {
  value = resource.kubernetes_cluster.k8s.kubeconfig
}