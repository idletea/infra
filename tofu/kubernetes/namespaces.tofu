resource "kubernetes_namespace" "ns" {
  for_each = toset(["envoy-gateway", "cert-manager"])
  metadata {
    name = each.value
  }
}
