###################################
## domains with no email service ##
###################################
resource "cloudflare_record" "email__dmarc_deny" {
  count = var.tuta_verification == "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "TXT"
  name     = "_dmarc"
  value    = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s"
}

resource "cloudflare_record" "email_spf_deny" {
  count = var.tuta_verification == "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 -all"
}

################################
## domains with email service ##
################################
resource "cloudflare_record" "email_mx" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "MX"
  name     = "@"
  value    = "mail.tutanota.de"
  priority = 10
}

resource "cloudflare_record" "email_key_s1" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "CNAME"
  name     = "s1._domainkey"
  value    = "s1.domainkey.tutanota.de"
}

resource "cloudflare_record" "email_key_s2" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "CNAME"
  name     = "s2._domainkey"
  value    = "s2.domainkey.tutanota.de"
}

resource "cloudflare_record" "email_mta_sts" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "CNAME"
  name     = "mta-sts"
  value    = "mta-sts.tutanota.de"
}

resource "cloudflare_record" "email__mta_sts" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "CNAME"
  name     = "_mta-sts"
  value    = "mta-sts.tutanota.de"
}

resource "cloudflare_record" "email__dmarc" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "TXT"
  name     = "_dmarc"
  value    = "v=DMARC1; p=quarantine; adkim=s"
}

resource "cloudflare_record" "email_spf" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "TXT"
  name     = "@"
  value    = "v=spf1 include:spf.tutanota.de -all"
}

resource "cloudflare_record" "email_t_verify" {
  count = var.tuta_verification != "" ? 1 : 0

  zone_id  = cloudflare_zone.zone.id
  comment  = "managed-by = 'infra/tofu'"
  type     = "TXT"
  name     = "@"
  value    = "t-verify=${var.tuta_verification}"
}
