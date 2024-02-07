resource "cloudflare_record" "records" {
  for_each = {
    for index, r in var.records:
    "${r.type}_${substr(sha256("${r.name}{r.value ? r.value : ''}${r.salt}"), 0, 12)}" => r
  }

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  name     = each.value["name"]
  value    = each.value["value"]
  type     = each.value["type"]
  proxied  = each.value["proxied"]
  priority = each.value["priority"]
}
