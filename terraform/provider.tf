terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.do_login
}

# Create a web server
resource "digitalocean_droplet" "web" {
    count = 2
    image = "docker-20-04"
    name = "${var.homework}-${count.index}"
    region = "ams3"
    size = "s-1vcpu-1gb"
    ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

resource "digitalocean_certificate" "cert" {
  name    = "${var.homework}.cert"
  type    = "lets_encrypt"
  domains = ["${var.homework}.${var.domain}"]
}

resource "digitalocean_loadbalancer" "lb" {

  name = "${var.homework}-lb"
  region = "ams3"
  redirect_http_to_https = true
  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 5000
    target_protocol = "http"
    certificate_name = digitalocean_certificate.cert.name
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 5000
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}

resource "digitalocean_domain" "domain" {
  name       = "${var.homework}.${var.domain}"
  ip_address = digitalocean_loadbalancer.lb.ip
}

resource "datadog_monitor" "networkmonitor" {
  name = "project3 monitor"
  type = "service check"
  message = "@${var.mail}"
	query = "\"http.can_connect\".over(\"instance:application_health_check_status\",\"url:http://localhost:5000\").by(\"host\",\"instance\",\"url\").last(2).count_by_status()"
}

