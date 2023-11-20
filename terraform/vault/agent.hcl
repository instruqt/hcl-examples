log_level = "debug"

vault {
  address = "http://{{server_address}}:8200"
}

auto_auth {
  method {
    type = "approle"

    config = {
      role_id_file_path = "/vault/config/roleid"
      secret_id_file_path = "/vault/config/secretid"
    }
  }

  sinks {
    sink {
      type = "file"

      config = {
        path = "/tmp/token"
      }
    }
  }
}

template_config {
  exit_on_retry_failure = true
  static_secret_render_interval = "10m"
}

api_proxy {
  use_auto_auth_token = true
}

listener "tcp" {
  address = "127.0.0.1:8100"
  tls_disable = true
}