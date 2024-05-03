
# Data

data "yandex_cm_certificate" "bosone" {
  depends_on      = [yandex_dns_recordset.validation-record]
  certificate_id  = yandex_cm_certificate.le-certificate.id
 # wait_validation = true
}