# infra

All-in-one repo for my hobby infrastructure based on [k3s](https://k3s.io/).

* [tofu](tofu/readme.md)
    * provision the vm & dns
* [ansible](ansible/readme.md)
    * set up k3s on the vm
* [manifests](manifests/readme.md)
    * set up [argocd](https://argo-cd.readthedocs.io/en/stable/)
* [static](static/readme.md)
    * static website contents
* [containers](containers/readme.md)
    * [auth-proxy](containers/auth-proxy)
        * validates [cloudflare zero-trust](https://developers.cloudflare.com/cloudflare-one/) jwts

## requirements

* [mise](https://mise.jdx.dev/) for managing most requirements
* [fish](https://fishshell.com/) for scripts

## secrets

Some secrets are managed manually outside this repo, at least until I try to integrate something like the [external secrets operator](https://external-secrets.io/latest/).

### cloudflare-dns-token

Used by [cert-manager](manifests/cert-manager) to do [DNS-01](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge) challenges.

Permissions in all zones for which certs can be issued are required:
* Zone - DNS - Edit
* Zone - Zone - Read

```
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-dns-token
  namespace: cert-manager
type: Opaque
stringData:
  api-token: <API Token>
```

### ghcr.io dockerconfigjson

Manifests that may refer to a private ghcr.io package need a secret set up with a base64 encoded json something like this

```
{"auths":{"ghcr.io":{"auth":"idletea:<base64 encoded github classic token with `package:read` privileges>"}}}
```

```
kind: Secret
type: kubernetes.io/dockerconfigjson
apiVersion: v1
metadata:
  name: ghcr-io
  namespace: app-name
  labels:
    app: app-name
data:
  .dockerconfigjson: "<base64 encoded json>"
```
