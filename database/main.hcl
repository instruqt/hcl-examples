// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "10.0.10.0/24"
}

// Copy the init sql files from our local folder to a temporary data directory 
// named "postgres".
resource "copy" "postgres_init" {
  source = "files/init"
  destination = "${data("postgres")}/init"
}

// Create a postgres container that uses the official postgres docker image.
resource "container" "postgres" {
  image {
    name = "postgres:16.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Pass the postgres environment variables to the container to configure it.
  environment = {
    POSTGRES_PASSWORD = "secret"
    POSTGRES_USER = "postgres"
    POSTGRES_DB = "postgres"
  }

  // Export the postgres port so we can connect to it from the host.
  port {
    local = 5432
    host = 5432
  }

  // Mount the init sql files as a volume.
  volume {
    source = "${data("postgres")}/init"
    destination = "/docker-entrypoint-initdb.d/"
  }

  // Wait for the postgres container to be ready as initialisation can take a 
  // while.
  health_check {
    timeout = "30s"

    exec {
      script = <<-EOF
        pg_isready -h localhost -p 5432 -U postgres
      EOF
    }
  }
}

// Connect to the postgres container with psql.
// We are using an exec resource here as we don't need to keep the container 
// running after the script has finished.
resource "exec" "psql" {
  image {
    name = "postgres:16.0"
  }

  // Attach the container to the network.
  network {
    id = resource.network.main.id
  }

  // Pass the postgres environment variables to psql to configure it.
  environment = {
    PGHOST = resource.container.postgres.container_name
    PGPASSWORD = "example"
    PGUSER = "example"
    PGDATABASE = "example"
  }

  // Run a query against the postgres container.
  script = <<-EOF
  psql -c "SELECT * FROM example;"
  EOF
}