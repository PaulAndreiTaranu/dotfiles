# VPS Runbook

Personal infrastructure setup: Hetzner VPS + Cloudflare domain + Docker + Caddy reverse proxy.

## Prerequisites

- [Hetzner Cloud](https://console.hetzner.cloud/) account
- [Cloudflare](https://dash.cloudflare.com/) account with domain added
- SSH key pair on your local machine (`~/.ssh/id_ed25519`)
- Local tools: `ssh`, `scp`, `docker` (for testing)

## 1. Provision

Create a VPS on Hetzner Cloud. Select Ubuntu, add your SSH key during creation. Note the IP address.

**Verify:** `ssh root@<server-ip>` connects without password prompt.

## 2. Initial Server Setup

Copy and run the base setup script — installs packages, Docker, UFW, fail2ban, hardens SSH and
kernel. Use `createUser.sh` to create a new non-root user and disable root SSH login:

```bash
scp utils.sh installDocker.sh setupVPS.sh createUser.sh root@<server-ip>:/root
ssh root@<server-ip>
bash setupVPS.sh
bash createUser.sh <username>
```

**Note:** `createUser.sh` will prompt you to set a password. Remember it — `sudo` requires it.

**Verify:** Open a second terminal and confirm `ssh <username>@<server-ip>` works before closing
root session.

Reboot to apply all changes:

```bash
sudo reboot
```

## 3. DNS — Cloudflare

In Cloudflare dashboard → DNS → add A records pointing to your VPS IP with proxy enabled (orange
cloud):

| Type | Name   | Content       | Proxy   |
| ---- | ------ | ------------- | ------- |
| A    | `@`    | `<server-ip>` | Proxied |
| A    | `test` | `<server-ip>` | Proxied |

Set SSL/TLS mode to **Full (Strict)**.

**Verify:** `dig test.paulandreitaranu.com` returns Cloudflare IPs (not your VPS IP).

## 4. Origin Certificate

Cloudflare → SSL/TLS → Origin Server → Create Certificate. Defaults are fine (RSA, 15 years,
wildcard). Save both the certificate and private key.

On the VPS:

```bash
mkdir -p ~/caddy/certs
vi ~/caddy/certs/origin.pem       # paste certificate
vi ~/caddy/certs/origin-key.pem   # paste private key
chmod 644 ~/caddy/certs/origin.pem
chmod 600 ~/caddy/certs/origin-key.pem
```

**Verify:**

```bash
head -1 ~/caddy/certs/origin.pem       # → -----BEGIN CERTIFICATE-----
head -1 ~/caddy/certs/origin-key.pem   # → -----BEGIN PRIVATE KEY-----
```

## 5. Reverse Proxy — Caddy

Create a caddy docker compose service and a Caddyfile to be referenced from the service:
`~/caddy/docker-compose.yml` `~/caddy/Caddyfile`

```bash
docker network create proxy
cd ~/caddy
docker compose up -d
```

**Verify:** `https://test.paulandreitaranu.com` loads with valid SSL in browser.

Adding a new subdomain: add an A record in Cloudflare, add a block to the Caddyfile, put the service
on the `proxy` network, `docker compose restart caddy`.

## 6. Useful Commands

```bash
# Docker
docker compose up -d              # start
docker compose down               # stop
docker compose down -v            # stop and delete volumes
docker compose logs -f <service>  # follow logs
docker compose restart <service>  # reload after config change

# Firewall
sudo ufw status
sudo ufw allow <port>/tcp

# Fail2ban
sudo fail2ban-client status sshd

# Security audit
sudo lynis audit system --quick
```

## Architecture

### Traffic Flow

- **Public traffic:** User → Cloudflare (SSL termination + DDoS) → VPS :443 → Caddy (origin cert) →
  container
- **Database access:** Developer → SSH tunnel → localhost:5432 / localhost:8081 (never exposed
  publicly)

### Ports

| Port | Binding | Service    | Access          |
| ---- | ------- | ---------- | --------------- |
| 22   | 0.0.0.0 | SSH        | Public (UFW)    |
| 80   | 0.0.0.0 | Caddy HTTP | Redirect to 443 |
| 443  | 0.0.0.0 | Caddy TLS  | Public (UFW)    |

## Recovery

**Locked out of SSH:** Go to Hetzner Cloud console → your server → **Rebuild**. Select Ubuntu and
your SSH key. This reinstalls the OS on the same server (keeps the same IP). Then re-run the setup
scripts.

**Forgot sudo password:** Use the Hetzner web console (VNC) to log in as root and reset the password
with `passwd <username>`.

## Database Access — SSH Tunneling

Databases should never be exposed publicly. Use SSH tunnels to access them from your local machine:

```bash
# PostgreSQL — connects local :5432 to the VPS container's port
ssh -L 5432:localhost:5432 <username>@<server-ip>

# Then in another terminal, connect as if it were local
psql -h localhost -U postgres
```

Your DB client (DBeaver, pgAdmin, DataGrip) can also configure SSH tunnels natively — point it at
your SSH key and it handles the tunnel automatically.

## Backups

Minimal backup strategy: tar configs and Docker volumes, copy off-server.

```bash
# On the VPS — create a backup of caddy config and certs
sudo tar czf ~/backup-$(date +%F).tar.gz ~/caddy

# From your local machine — pull the backup
scp <username>@<server-ip>:~/backup-*.tar.gz ./backups/
```

For Docker volumes specifically:

```bash
# List volumes
docker volume ls

# Back up a named volume
docker run --rm -v <volume_name>:/data -v ~/backups:/backup alpine \
  tar czf /backup/<volume_name>-$(date +%F).tar.gz -C /data .
```

## Troubleshooting

**`scp` hangs on `.pem` files from Kitty** Kitty intercepts `.pem` extensions. Rename to `.txt`
before copying, or paste content directly via `vi` over SSH.

**`vi` shows `E558: Terminal entry not found in terminfo`** Kitty's `TERM=xterm-kitty` isn't
recognized. Install `kitty-terminfo` on the VPS or use `TERM=xterm-256color vi <file>`.
