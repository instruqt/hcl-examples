// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "100.0.10.0/24"
}

// A "Fake Service" container that poses as a frontend application.
// The frontend application will call the currency and payments microservices.
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
    UPSTREAM_URIS = "http://${resource.container.currency.container_name}?currency=USD,http://${resource.container.payments.container_name}?user=johndoe"
  }

  // Expose the http port to the host.
  // We will be able to visit the UI on http://localhost/ui.
  port {
    local = 80
    host = 80
  }
}

// A "Fake Service" container that poses as a currency microservice.
// The currency microservice will call the database.
resource "container" "currency" {
  image {
    name = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Configure fake-service with the environment variables.
  environment = {
    NAME = "currency"
    MESSAGE = "Hello from currency"
    LISTEN_ADDR = "0.0.0.0:80"
    UPSTREAM_URIS = "http://${resource.container.database.container_name}:5432"
  }
}

// A "Fake Service" container that poses as a payments microservice.
// The payments microservice will call the database.
resource "container" "payments" {
  image {
    name = "ghcr.io/nicholasjackson/fake-service:v0.26.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Configure fake-service with the environment variables.
  environment = {
    NAME = "payments"
    MESSAGE = "Hello from payments"
    LISTEN_ADDR = "0.0.0.0:80"
    UPSTREAM_URIS = "http://${resource.container.database.container_name}:5432"
  }
}

// A "Fake Service" container that poses as a postgres database.
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