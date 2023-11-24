resource "container" "k9s" {
  image {
    name = "derailed/k9s"
  }

  command = ["tail", "-f", "/dev/null"]

  volume {
    source = resource.k8s_cluster.k8s.kubeconfig
    destination = "/root/.kube/config"
  }
}