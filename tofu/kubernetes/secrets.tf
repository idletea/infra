variable "CERT_MANAGER_CLOUDFLARE_TOKEN" {
  type     = string
  nullable = false
}

resource "kubernetes_secret_v1" "cert_manager_cloudflare_token" {
  type = "Opaque"

  metadata {
    name = "cloudflare-dns-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.CERT_MANAGER_CLOUDFLARE_TOKEN
  }

  depends_on = [kubernetes_namespace.ns["cert-manager"]]
}
