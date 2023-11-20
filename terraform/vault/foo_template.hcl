template "foo" {
  contents = "{{ with secret \"kvv2/data/foo\" }}{{ .Data.data.foo }}{{ end }}"
  destination = "/tmp/secret_foo"
  error_on_missing_key = true
}