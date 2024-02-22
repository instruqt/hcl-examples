resource "container" "k9s" {
  network {
    id = resource.network.meta.id
  }

  image {
    name = "derailed/k9s"
  }

  entrypoint = ["/usr/bin/tail"]
  command = ["-f", "/dev/null"]

  volume {
    source = resource.k8s_cluster.k8s.kubeconfig
    destination = "/root/.kube/config"
  }
}