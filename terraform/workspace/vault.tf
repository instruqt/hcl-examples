resource "vault_policy" "foo" {
  name = "foo"

  policy = <<-EOF
  path "${vault_mount.kvv2.path}/data/foo" {
    capabilities = ["read", "update"]
  }
  EOF
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "foo_reader" {
  backend         = vault_auth_backend.approle.path
  role_name       = "foo-reader"
  token_policies  = ["default", "foo"]
}

output "roleid" {
  value = vault_approle_auth_backend_role.foo_reader.role_id
  sensitive = true
}

resource "vault_approle_auth_backend_role_secret_id" "foo_reader" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.foo_reader.role_name
}

output "secretid" {
  value = vault_approle_auth_backend_role_secret_id.foo_reader.secret_id
  sensitive = true
}

variable "foo_value" {
  type = string
}

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
}

resource "vault_kv_secret_v2" "foo" {
  mount                      = vault_mount.kvv2.path
  name                       = "foo"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode({
    foo = var.foo_value
  })
}