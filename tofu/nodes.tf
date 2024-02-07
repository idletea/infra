resource "vultr_instance" "node" {
  region            = "yto"
  plan              = "vc2-2c-4gb"
  os_id             = 2136
  hostname          = "lemur.idte.net"
  enable_ipv6       = true
  firewall_group_id = vultr_firewall_group.k3s.id
  ssh_key_ids       = [vultr_ssh_key.default.id]
  backups           = "disabled"
}
