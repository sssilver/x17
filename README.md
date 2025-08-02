# X17 Space

## 1. Install Nomad and Vault

## 2. Create directory structure
```bash
  sudo mkdir -p /opt/vault/data
  sudo mkdir -p /opt/vault/plugins
  sudo mkdir -p /etc/vault.d
  sudo chown -R vault:vault /opt/vault
```

## 3. Copy or symlink main Nomad and Vault configurations and systemd unit files
  - `config/nomad/nomad.hcl` into `/etc/nomad.d/nomad.hcl`
  - `config/vault/vault.hcl` into `/etc/vault.d/vault.hcl`
  - `config/nomad/nomad.service` into `/etc/systemd/system/nomad.service`
  - `config/vault/vault.service` into `/etc/systemd/system/vault.service`

## 4. Enable and Run Systemd Services for both Nomand and Vault
```bash
  sudo systemctl daemon-reload

  sudo systemctl enable --now vault
  sudo systemctl enable --now nomad
```

## 5. Initialize Vault
```bash
  export VAULT_ADDR='http://127.0.0.1:8200'
  vault operator init
```
This will output:
  - 5 unseal keys
  - 1 root token

Record all of them.

## 6. Unseal Vault and login with root token
```bash
  # Provide 3 of the 5 unseal keys
  vault operator unseal  # Enter unseal key 1
  vault operator unseal  # Enter unseal key 2
  vault operator unseal  # Enter unseal key 3

  # Check seal status
  vault status

  # Login
  vault login
  # Enter root token when prompted
```

## 7. Enable KV Secrets Engine
```bash
  vault secrets enable -version=2 -path=secret kv
```

## 8. Create Vault policies
```bash
  vault policy write postgres-ro config/vault/policy-postgres-ro.hcl
```

## 9. Store Postgres credentials
```bash
  # Store PostgreSQL credentials
  vault kv put secret/postgres \
    username="postgres_user" \
    password="postgres_password" \
    host="postgres_host" \
    port="5432" \
    database="database_name"
```

## 10. Enable JWT auth and create Nomad role
```bash
# 10.1  Mount the auth backend
vault auth enable -path=jwt jwt

# 10.2  Tell Vault where to fetch Nomad's signing key
vault write auth/jwt/config \
      jwks_url="http://127.0.0.1:4646/.well-known/jwks.json" \
      bound_issuer="http://127.0.0.1:4646" \
      jwt_supported_algs='RS256'

# 10.3  Create a role that maps the JWT -> postgres-ro policy
vault write auth/jwt/role/postgres-role \
      role_type="jwt" \
      bound_audiences="x17.space" \
      user_claim="sub" \
      policies="postgres-ro" \
      token_ttl="1h" token_max_ttl="4h"

# 10.4 Restart Nomad
sudo systemctl restart nomad
```
