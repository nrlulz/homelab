## IP Whitelist

Annotate ingress with:

    nginx.ingress.kubernetes.io/whitelist-source-range: 192.168.1.0/24

## Big files

Annotate ingress with something like:

    nginx.ingress.kubernetes.io/proxy-body-size: 1024m
