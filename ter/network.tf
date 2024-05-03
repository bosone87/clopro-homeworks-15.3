
# Network

resource "yandex_vpc_network" "network" {
  name = var.network_name
}
resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_name_1
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.subnet_cidr_1
}
resource "yandex_dns_zone" "zone1" {
  name        = "bosone"
  description = "Test public zone"
  zone    = "bosone.ru."
  public  = true
}
resource "yandex_dns_recordset" "validation-record" {
  zone_id = yandex_dns_zone.zone1.id
  name    = yandex_cm_certificate.le-certificate.challenges[0].dns_name
  type    = yandex_cm_certificate.le-certificate.challenges[0].dns_type
  data    = [yandex_cm_certificate.le-certificate.challenges[0].dns_value]
  ttl     = 300
}
resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "bosone.ru."
  type    = "CNAME"
  ttl     = 600
  data    = [ yandex_storage_bucket.site-bucket.website_endpoint ]
}