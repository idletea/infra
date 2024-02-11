resource "cloudflare_ruleset" "idletea_net_global" {
  zone_id     = module.idletea_net.zone_id
  name        = "global-zone-transforms"
  description = ""
  kind        = "zone"
  phase       = "http_request_late_transform"

  rules {
    action = "rewrite"
    action_parameters {
      headers {
        name       = "edge-host"
        operation  = "set"
        expression = "http.host"
      }
    }
    expression = "true"
    description = "add edge-host header"
    enabled = true
  }
}
