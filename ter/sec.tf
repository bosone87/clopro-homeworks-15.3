
# Service Accounts

resource "yandex_iam_service_account" "sa4bucket" {
    name      = "sa4bucket"
}
resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
    folder_id = var.folder_id
    role      = "storage.admin"
    member    = "serviceAccount:${yandex_iam_service_account.sa4bucket.id}"
    depends_on = [yandex_iam_service_account.sa4bucket]
}
resource "yandex_iam_service_account_static_access_key" "sa-sa-key" {
    service_account_id = yandex_iam_service_account.sa4bucket.id
    description        = "access key for bucket"
}
resource "yandex_resourcemanager_folder_iam_member" "kms" {
  folder_id =  var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa4bucket.id}"
}

# KMS

resource "yandex_kms_symmetric_key" "s-key" {
  name              = "symetric-key"
  description       = "symetric-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

# Cert

resource "yandex_cm_certificate" "le-certificate" {
  name    = "cert"
  domains = ["bosone.ru", "*.bosone.ru"]

  managed {
  challenge_type = "DNS_CNAME"
  challenge_count = 1
  }
}