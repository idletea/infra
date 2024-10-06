resource "vultr_instance" "n0_vk_idte_net" {
  region            = "yto"
  plan              = "vhp-2c-4gb-amd"
  os_id             = 2136
  hostname          = "n0.vk.idte.net"
  label             = "n0.vk.idte.net"
  vpc2_ids          = [vultr_vpc2.vk_idte_net.id]
  enable_ipv6       = true
  firewall_group_id = vultr_firewall_group.cluster.id
  ssh_key_ids       = [vultr_ssh_key.key.id]
  backups           = "disabled"
}
