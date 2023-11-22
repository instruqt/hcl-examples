// Render the index.html file using the template resource.
// Substitute the variable "name" into the template.
resource "template" "index" {
  source = file("files/index.html.tmpl")
  destination = "${data("nginx")}/index.html"
  variables = {
    name = variable.name
    vault_address = resource.ingress.vault_http.local_address
    token = resource.terraform.configure_vault.output.vault_token
  }
}

// Create a container that uses the official nginx image.
resource "container" "nginx" {
  image {
    name = "nginx:1.25.3"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Expose the http port so we can connect to it from the host.
  port {
    local = 80
    host = 80
  }

  // Mount the index.html file into the container.
  volume {
    source = resource.template.index.destination
    destination = "/usr/share/nginx/html/index.html"
  }

  // Specify the amount of memory to allocate to the container.
  resources {
    memory = 64
  }
}