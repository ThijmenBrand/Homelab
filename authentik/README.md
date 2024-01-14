# Authentik

# IAM Policies

## Password expiration

The password expires every 365 days

## Password complexity

The password need to have a minimal of 15 characters with at least 2 upper and 2 lower case letters

# Errors

## Proxmox OpenID realm

### 500 error

When trying to configure proxmox to work with Authentik, I first got a 500 error and was not redirected to the login page. I was using a self signed certificate for the auth.thijmenbrand.nl domain because it was handled by the reverse proxy. After proxying it through Cloudflare, and useing their certificate I got redirected to the login page.

### 401 error

After login and being redirected back I was not able to login, It turned out I hadn't configured the scopes in authentik and the configuration in proxmox correctly. It is important to select the correct scopes in the provider in authentik. I have now selected them all, but the once neceserry where email, openid and profle.

Then in proxmox I needed to enter username claim as: `preferred_username` and the scopes `openid email profile` I needed to be exactly this for it to work. I firstly had the default values which caused the issue
