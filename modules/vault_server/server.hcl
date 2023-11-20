resource "random_password" "root_token" {
  length = 32
}

resource "container" "vault" {
  network {
    id = variable.network_id
  }

  image {
    name = "vault:1.13.3"
  }

  environment = {
    VAULT_ADDR = "http://localhost:8200"
    VAULT_DEV_ROOT_TOKEN_ID = resource.random_password.root_token.value
  }

  port {
    local  = 8200
    remote = 8200
    host   = variable.host_port
  }
}