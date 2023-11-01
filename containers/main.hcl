// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "10.0.10.0/24"
}

// frontend
resource "container" "frontend" {
  image {
    name = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Configure fake-service with the environment variables.
  environment = {
    NAME = "frontend"
    MESSAGE = "Hello from frontend"
    LISTEN_ADDR = "0.0.0.0:80"
    UPSTREAM_URIS = "http://${resource.container.backend_1.container_name},http://${resource.container.backend_2.container_name}"
  }

  port {
    local = 80
    host = 80
  }
}

// backend 1
resource "container" "backend_1" {
  image {
    name = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Configure fake-service with the environment variables.
  environment = {
    NAME = "backend_1"
    MESSAGE = "Hello from backend_1"
    LISTEN_ADDR = "0.0.0.0:80"
    UPSTREAM_URIS = "http://${resource.container.database.container_name}:5432"
  }
}

// backend 2
resource "container" "backend_2" {
  image {
    name = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Configure fake-service with the environment variables.
  environment = {
    NAME = "backend_2"
    MESSAGE = "Hello from backend_2"
    LISTEN_ADDR = "0.0.0.0:80"
    UPSTREAM_URIS = "http://${resource.container.database.container_name}:5432"
  }
}

// database
resource "container" "database" {
  image {
    name = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Configure fake-service with the environment variables.
  environment = {
    NAME = "database"
    MESSAGE = "Hello from database"
    LISTEN_ADDR = "0.0.0.0:5432"
  }
}