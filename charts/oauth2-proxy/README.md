# oauth2-proxy

https://kubernetes.github.io/ingress-nginx/examples/auth/oauth-external-auth/#key-detail

## Generating a cookie secret

https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview#generating-a-cookie-secret

    openssl rand -base64 32 | tr -- '+/' '-_'

## Ingress annotations

https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#external-authentication

The ingress to be protected should have the following annotations:

    annotations:
        nginx.ingress.kubernetes.io/auth-url: "https://$host/oauth2/auth"
        nginx.ingress.kubernetes.io/auth-signin: "https://$host/oauth2/start?rd=$escaped_request_uri"

This will redirect unauthenticated requests to the auth-signin url (oauth2-proxy), which redirects to the OIDC provider to authenticate, which redirects to the callback url (oauth2-proxy), which sets a cookie (thus authenticating subsequent requests), then redirects back to the original request url.
