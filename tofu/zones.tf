module "idletea_net" {
  source     = "./cloudflare_zone"
  account_id = local.cloudflare_account_id

  fqdn              = "idletea.net"
  tuta_verification = "303b0c7840ee2a2cc76d650940afec88"
  records = [
    {
      type  = "A"
      name  = "@"
      value = "138.197.165.65"
      }, {
      type  = "CNAME"
      name  = "www"
      value = "idletea.net"
      }, {
      type    = "CNAME"
      name    = "echo"
      value   = "idletea.net"
      proxied = true
      }, {
      type  = "A"
      name  = "rsvplease"
      value = "138.197.165.65"
    },
  ]
}

module "idte_net" {
  source     = "./cloudflare_zone"
  account_id = local.cloudflare_account_id

  fqdn = "idte.net"
  records = [
    # internal names
    {
      type  = "A"
      name  = "argocd.svc.idte.net"
      value = "127.8.0.10"
    },
    # machines
    {
      type  = "A"
      name  = "stoat"
      value = "138.197.165.65"
      }, {
      type  = "A"
      name  = "lemur"
      value = vultr_instance.node.main_ip
    },
  ]
}

module "oefd_net" {
  source     = "./cloudflare_zone"
  account_id = local.cloudflare_account_id

  fqdn              = "oefd.net"
  tuta_verification = "02b7fd72d03f182f58988d688d966aa5"
  records           = []
}
