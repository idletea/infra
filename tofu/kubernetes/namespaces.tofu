resource "kubernetes_namespace" "ns" {
  for_each = toset(["envoy-gateway", "cert-manager", "echo"])
  metadata {
    name = each.value
  }
}
