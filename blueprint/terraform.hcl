resource "terraform" "configure_vault" {
  network {
    id = resource.network.main.id
  }

  version = "1.6.4"

  source = "files/terraform"
  environment = {
    VAULT_TOKEN = "root"
    VAULT_ADDR  = "http://${resource.ingress.vault_http.local_address}"
  }

  variables = {
    secret = "verysecret"
  }
}