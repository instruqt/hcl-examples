output "root_token" {
  value = resource.random_password.root_token.value
}

output "vault_address" {
  value = "http://${resource.container.vault.container_name}:8200"
}