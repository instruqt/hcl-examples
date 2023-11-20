// Create a shared network for the Vault server and client
resource "network" "main" {
  subnet = "10.0.0.0/16"
}

// Create a Vault server from a module
module "vault_server" {
  source = "./vault_server"

  variables = {
    network_id = resource.network.main.id
    host_port = 8200
  }
}

module "vault_server_2" {
  source = "./vault_server"

  variables = {
    network_id = resource.network.main.id
    host_port = 18200
  }
}

// Create a Vault client from a module
// use the outputs of the Vault server module
// to configure the client
module "vault_client" {
  source = "./vault_client"

  variables = {
    network_id = resource.network.main.id
    vault_address = module.vault_server.output.vault_address
    vault_token = module.vault_server.output.root_token
  }
}

// Output the Vault token from the server module
// so we can log in to the UI
output "vault_token" {
  value = module.vault_server.output.root_token
}

output "vault_token_2" {
  value = module.vault_server_2.output.root_token
}