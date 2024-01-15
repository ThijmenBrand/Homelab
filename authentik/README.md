# Authentik

# IAM Policies

## Password expiration

The password expires every 365 days

## Password complexity

The password need to have a minimal of 15 characters with at least 2 upper and 2 lower case letters

# Implementations
## Ansible Semaphore
**Provider**
1. Create an OpenID provider for Semaphore
2. set the `redirect_urls` to "https://<semaphore domain>/api/auth/oidc/authelia/redirect"
3. select openid, profile and email scopes

**Application**
1. Create application
2. Select Semaphore provider

**Semaphore**
1. Enter semaphore docker image with `sudo docker exec -it <container id> /bin/bash`
2. place the following configuration in /etc/semaphore/config.json
```json
...
"oidc_providers": {
  “Authentik”: {
    "display_name": "Authentik",
    "provider_url": "https://auth.thijmenbrand.nl ",
    "client_id": "semaphore",
    "client_secret": "<secret>",
    "redirect_url": "https://semaphore.thijmenbrand.nl/api/auth/oidc/authelia/redirect"
    }
}
...
```
3. restart docker container with `sudo docker restart <container id>`

## Zabbix


# Errors

## Proxmox OpenID realm

### 500 error

When trying to configure proxmox to work with Authentik, I first got a 500 error and was not redirected to the login page. I was using a self signed certificate for the auth.thijmenbrand.nl domain because it was handled by the reverse proxy. After proxying it through Cloudflare, and useing their certificate I got redirected to the login page.

### 401 error

After login and being redirected back I was not able to login, It turned out I hadn't configured the scopes in authentik and the configuration in proxmox correctly. It is important to select the correct scopes in the provider in authentik. I have now selected them all, but the once neceserry where email, openid and profle.

Then in proxmox I needed to enter username claim as: `preferred_username` and the scopes `openid email profile` I needed to be exactly this for it to work. I firstly had the default values which caused the issue
