resource "digitalocean_droplet" "web" {
  count    = 2
  image    = "docker-20-04"
  name     = "${var.homework}-${count.index}"
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}
