// Make an HTTP request and use the response to configure a container.
resource "http" "get" {
  method = "GET"
  url = "https://httpbin.org/get"

  headers = {
    Accept = "application/json"
  }
}

resource "http" "post" {
  method = "POST"
  url = "https://httpbin.org/post"

  payload = jsonencode({
    foo = "bar"
  })

  headers = {
    Accept = "application/json"
  }
}

local "get" {
  body = jsondecode(resource.http.get.body)
  status = resource.http.get.status
}

local "post" {
  body = jsondecode(resource.http.post.body)
  status = resource.http.post.status
}