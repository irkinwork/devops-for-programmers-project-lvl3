resource "digitalocean_loadbalancer" "lb" {
  name                   = "${var.homework}-lb"
  region                 = "ams3"
  redirect_http_to_https = true
  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port      = 5000
    target_protocol  = "http"
    certificate_name = digitalocean_certificate.cert.name
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 5000
    target_protocol = "http"
  }

  healthcheck {
    port     = 5000
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}