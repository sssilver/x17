datacenter = "x17"
data_dir  = "/opt/nomad/data"
log_level  = "INFO"

bind_addr = "0.0.0.0"

server {
  # license_path is required for Nomad Enterprise as of Nomad v1.1.1+
  #license_path = "/etc/nomad.d/license.hclic"
  enabled          = true
  bootstrap_expect = 1
  oidc_issuer = "http://127.0.0.1:4646"
}

client {
  enabled = true
  servers = ["127.0.0.1"]
  network_interface = "{{ GetDefaultInterfaces | attr \"name\" }}"

  host_volume "postgres_data" {
    path      = "/opt/nomad/data/postgres"
    read_only = false
  }
}

acl = {
  enabled = true
}

vault {
  enabled = true
  address = "http://127.0.0.1:8200"

  jwt_auth_backend_path = "jwt"

  # Nomad will mint a JWT for every task:
  default_identity {
    aud  = ["x17.space"]
    ttl  = "24h"
  }
}

plugin "docker" {
  config {
    allow_privileged = true

    auth {
      config = "/home/nomad/.docker/config.json"
    }
  }
}
