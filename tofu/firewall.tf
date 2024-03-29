resource "vultr_firewall_group" "k3s" {
  description = "k3s nodes"
}

resource "vultr_firewall_rule" "ipv4_ssh" {
  firewall_group_id = vultr_firewall_group.k3s.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "ipv4 ssh"
}

resource "vultr_firewall_rule" "ipv6_ssh" {
  firewall_group_id = vultr_firewall_group.k3s.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "22"
  notes             = "ipv6 ssh"
}

resource "vultr_firewall_rule" "ipv4_http" {
  firewall_group_id = vultr_firewall_group.k3s.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "ipv4 http"
}

resource "vultr_firewall_rule" "ipv6_http" {
  firewall_group_id = vultr_firewall_group.k3s.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "80"
  notes             = "ipv6 http"
}

resource "vultr_firewall_rule" "ipv4_https" {
  firewall_group_id = vultr_firewall_group.k3s.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "ipv4 https"
}

resource "vultr_firewall_rule" "ipv6_https" {
  firewall_group_id = vultr_firewall_group.k3s.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "443"
  notes             = "ipv6 https"
}
