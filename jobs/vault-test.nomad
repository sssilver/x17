job "vault-test" {
  datacenters = ["x17"]
  type = "batch"

  group "test" {
    task "test" {
      driver = "docker"
      
      vault {
        role = "postgres-role"
        policies = ["postgres-ro"]
      }
      
      config {
        image = "alpine:latest"
        command = "sh"
        args    = ["-c", "echo 'Secret from Vault:' $POSTGRES_PASSWORD && sleep 5"]
      }
      
      template {
        destination = "local/env"
        env = true
        data = <<EOH
          POSTGRES_PASSWORD={{ with secret "secret/data/postgres" }}{{ .Data.data.password }}{{ end }}
        EOH
      }
      
      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
