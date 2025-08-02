storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address         = "0.0.0.0:8200"
  tls_disable     = 1
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"

# Optimized for 2GB RAM
disable_mlock = true
ui = true

log_level = "INFO"
plugin_directory = "/opt/vault/plugins"
