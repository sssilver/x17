datacenter = "x17"
data_dir  = "/opt/nomad/data"
log_level  = "INFO"

bind_addr = "0.0.0.0"

server {
  # license_path is required for Nomad Enterprise as of Nomad v1.1.1+
  #license_path = "/etc/nomad.d/license.hclic"
  enabled          = true
  bootstrap_expect = 1
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

plugin "docker" {
  config {
    allow_privileged = true

    auth {
      config = "/home/nomad/.docker/config.json"
    }
  }
}
