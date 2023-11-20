// Create a network to connect the resources to. 
resource "network" "main" {
  subnet = "100.0.10.0/24"
}

resource "container" "httpbin" {
  image {
    name = "kong/httpbin:0.1.0"
  }

  network {
    id = resource.network.main.id
  }

  port {
    local = 80
    host = 80
  }

  health_check {
    timeout = "30s"

    http {
      address = "http://localhost/get"
      success_codes = [200]
    }
  }
}

resource "http" "get" {
  method = "GET"

  url = "http://${resource.container.httpbin.container_name}/get"

  headers = {
    Accept = "application/json"
  }
}

resource "http" "post" {
  method = "POST"

  url = "http://${resource.container.httpbin.container_name}/post"

  payload = jsonencode({
    foo = "bar"
  })

  headers = {
    Accept = "application/json"
  }
}

output "get_body" {
  value = resource.http.get.status == 200 ? resource.http.get.body : "error"
}

output "post_body" {
  value = resource.http.post.status == 200 ? resource.http.post.body : "error"
}