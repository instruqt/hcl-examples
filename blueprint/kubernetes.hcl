resource "k8s_cluster" "k8s" {
  network {
    id = resource.network.main.id
  }
}

resource "helm" "vault" {
  cluster = resource.k8s_cluster.k8s

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

resource "ingress" "vault_http" {
  port = 8200

  target {
    resource = resource.k8s_cluster.k8s
    port = 8200

    config = {
      service   = "vault"
      namespace = "default"
    }
  }
}

output "VAULT_ADDR" {
  value = resource.ingress.vault_http.local_address
}

output "KUBECONFIG" {
  value = resource.k8s_cluster.k8s.kubeconfig
}