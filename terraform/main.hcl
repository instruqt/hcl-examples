// A network to connect all the resources to.
resource "network" "main" {
  subnet = "100.10.0.0/16"
}

// The vault server.
resource "container" "vault_server" {
  network {
    id = resource.network.main.id
  }

  image {
    name = "vault:1.13.3"
  }

  environment = {
    VAULT_DEV_ROOT_TOKEN_ID = "root"
  }

  port {
    local  = 8200
    remote = 8200
    host   = 8200
  }
}

resource "copy" "workspace" {
  source      = "./workspace"
  destination = data("terraform")
  permissions = "0777"
}

// Terraform config that configures the vault server.
resource "terraform" "vault" {
  working_directory = "/terraform"

  environment = {
    VAULT_TOKEN = "root"
    VAULT_ADDR  = "http://${resource.container.vault_server.container_name}:8200"
  }

  variables = {
    foo_value = "bar"
  }

  network {
    id = resource.network.main.id
  }

  volume {
    source      = resource.copy.workspace.destination
    destination = "/terraform"
  }
}

// Write the roleid output from terraform to a file.
resource "template" "vault_roleid" {
  source = <<-EOF
  ${resource.terraform.vault.output.roleid}
  EOF
  destination = "${data("vault")}/roleid"
}

// Write the secretid output from terraform to a file.
resource "template" "vault_secretid" {
  source = <<-EOF
  ${resource.terraform.vault.output.secretid}
  EOF
  destination = "${data("vault")}/secretid"
}

// Generate the vault agent config from a template and customize it with 
// variables.
resource "template" "vault_agent_config" {
  source = template_file("vault/agent.hcl", {
    server_address = resource.container.vault_server.container_name
  })
  destination = "${data("vault")}/agent.hcl"
}

// The vault agent.
resource "container" "vault_agent" {
  network {
    id = resource.network.main.id
  }

  image {
    name = "vault:1.13.3"
  }

  command = [
    "agent",
    "-config=/vault/config"
  ]

  volume {
    source      = resource.template.vault_roleid.destination
    destination = "/vault/config/roleid"
  }

  volume {
    source      = resource.template.vault_secretid.destination
    destination = "/vault/config/secretid"
  }

  volume {
    source      = resource.template.vault_agent_config.destination
    destination = "/vault/config/agent.hcl"
  }

  volume {
    source      = "vault/foo_template.hcl"
    destination = "/vault/config/foo_template.hcl"
  }
}
