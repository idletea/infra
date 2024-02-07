resource "cloudflare_zone" "zone" {
  account_id = var.account_id
  zone       = var.fqdn

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone_settings_override" "zone" {
  zone_id = cloudflare_zone.zone.id
  settings {
    always_use_https = "on"
    min_tls_version  = "1.3"
    ssl              = "strict"
  }
}
