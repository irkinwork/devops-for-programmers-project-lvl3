resource "digitalocean_certificate" "cert" {
  name    = "${var.homework}.cert"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.domain.name]
}

