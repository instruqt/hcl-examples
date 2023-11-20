// The vault client.
resource "container" "vault_client" {
  network {
    id = variable.network_id
  }

  image {
    name = "vault:1.13.3"
  }

  environment = {
    VAULT_ADDR = variable.vault_address
    VAULT_TOKEN = variable.vault_token
  }
}
