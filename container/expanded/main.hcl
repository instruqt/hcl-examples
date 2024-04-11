// Create a network to connect the resources to.
resource "network" "main" {
  subnet = "100.0.10.0/24"
}

// Create an ubuntu container.
resource "container" "ubuntu" {
  image {
    name = "ubuntu"
  }

  // We use `tail -f /dev/null` as the command so it does not exit.
  command = ["/usr/bin/tail", "-f", "/dev/null"]

  // Attach the container to the network.
  network {
    id = resource.network.main.meta.id
  }

  // Mount the `files/motd` file into the container at `/etc/motd`.
  volume {
    source = "files/motd"
    destination = "/etc/motd"
  }

  // Specify the amount of memory to allocate to the container.
  resources {
    memory = 128
  }
}

// Change the root password of the ubuntu container to "password" using an exec 
// that executes the `chpasswd` command inside the ubuntu container.
//
// We can now log in to the container with the command: 
// `docker exec -it ubuntu.container.jumppad.dev login -f root`
resource "exec" "set_password" {
  target = resource.container.ubuntu

  script = <<-EOF
  echo "root:password" | chpasswd
  EOF
}