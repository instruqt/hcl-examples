// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "100.0.10.0/24"
}

// Generate a CA certificate.
resource "certificate_ca" "root" {
  output = data("certs")
}

// Use the generated CA certificate to generate a leaf certificate.
resource "certificate_leaf" "cert" {
  ca_key = resource.certificate_ca.root.private_key.path
  ca_cert = resource.certificate_ca.root.certificate.path

  // The dns_names should resolve to 127.0.0.1
  ip_addresses = ["127.0.0.1"]

  // The certificate will be valid for localhost and webserver.container.jumppad.dev
  dns_names = [
    "localhost",
    "webserver.container.jumppad.dev",
  ]

  // Output the generated leaf certificate to a temporary data directory.
  output = data("certs")
}

// Create an nginx container and use the certificates to enable HTTPS.
// We will be able to access the container over HTTPS by running:
// curl --cacert ~/.jumppad/data/certs/root.cert https://webserver.container.jumppad.dev
resource "container" "webserver" {
  image {
    name = "nginx:mainline-alpine3.18-slim"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.meta.id
  }

  // Specify the amount of memory to allocate to the container.
  resources {
    memory = 64
  }

  // Mount the nginx configuration as a volume.
  volume {
    source = "files/nginx.conf"
    destination = "/etc/nginx/conf.d/default.conf"
  }

  // Mount the generated private key as a volume.  
  volume {
    source = "${data("certs")}/${resource.certificate_leaf.cert.private_key.filename}"
    destination = "/etc/nginx/certs/cert.key"
  }

  // Mount the generated certificate as a volume.
  volume {
    source = "${data("certs")}/${resource.certificate_leaf.cert.certificate.filename}"
    destination = "/etc/nginx/certs/cert.crt"
  }

  // Expose the https port so we can connect to it from the host.
  port {
    local = 443
    remote = 443
    host = 443
  }
}