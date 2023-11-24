resource "container" "k9s" {
  image {
    name = "derailed/k9s"
  }

  command = ["k9s", "--readonly"]

  volume {
    source = resource.k8s_cluster.k8s.kubeconfig
    destination = "/root/.kube/config"
  }
}