// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "10.0.10.0/24"
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

  // Specify the amount of memory to allocate to the container.
  resources {
    memory = 64
  }
}