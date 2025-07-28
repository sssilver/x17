storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address         = "0.0.0.0:8200"
  tls_disable     = 1
  tls_min_version = "tls12"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true

# Optimized for 2GB RAM
disable_mlock = true
default_lease_ttl = "768h"
max_lease_ttl = "8760h"

log_level = "INFO"
plugin_directory = "/opt/vault/plugins"
