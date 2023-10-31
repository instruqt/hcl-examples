// Create a postgres database and populate it with data.
// Connect to the database with another container.

resource "network" "main" {
  subnet = "10.0.10.0/24"
}

resource "copy" "postgres_init" {
  source = "files/init"
  destination = "${data("postgres")}/init"
}

resource "container" "postgres" {
  image {
    name = "postgres:16.0"
  }

  network {
    id = resource.network.main.id
  }

  environment = {
    POSTGRES_PASSWORD = "secret"
    POSTGRES_USER = "postgres"
    POSTGRES_DB = "postgres"
  }

  volume {
    source = "${data("postgres")}/init"
    destination = "/docker-entrypoint-initdb.d/"
  }

  health_check {
    timeout = "30s"

    exec {
      script = <<-EOF
        #!/bin/bash
        pg_isready -h localhost -p 5432 -U postgres
      EOF
    }
  }
}

resource "exec" "psql" {
  target = resource.container.postgres

  environment = {
    POSTGRES_PASSWORD = "example"
    POSTGRES_USER = "example"
    POSTGRES_DB = "example"
  }

  script = <<-EOF
  psql -h localhost -U example -d example -c "SELECT * FROM example;"
  EOF
}