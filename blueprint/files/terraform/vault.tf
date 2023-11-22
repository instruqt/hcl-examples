variable "secret" {
  type = string
}

resource "vault_policy" "instruqt" {
  name = "instruqt"

  policy = <<-EOF
  path "${vault_mount.kvv2.path}/data/*" {
    capabilities = ["create", "read", "update", "list"]
  }
  EOF
}

resource "vault_token_auth_backend_role" "instruqt" {
  role_name              = "instruqt"
}

resource "vault_token" "instruqt" {
  role_name = "instruqt"

  policies = [resource.vault_policy.instruqt.name]

  renewable = true
  ttl = "24h"

  renew_min_lease = 43200
  renew_increment = 86400
}

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
}

output "vault_token" {
  value = resource.vault_token.instruqt.client_token
  sensitive = true
}