resource "digitalocean_domain" "domain" {
  name = "${var.homework}.${var.domain}"
}

