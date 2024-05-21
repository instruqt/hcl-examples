resource "network" "main" {
  subnet = "100.0.5.0/24"
}

resource "lab" "one" {  
  title = "Demo"
  description = <<-EOF
  Demo description 

  \\O

  O// 
  
  \O/
  EOF
}

resource "container" "nginx" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "nginx"
  }

  port {
    local  = 80
    host   = 80
  }
}

resource "terminal" "nginx" {
  target  = resource.container.nginx
}

resource "service" "nginx" {
  target = resource.container.nginx
  port   = 80
}
