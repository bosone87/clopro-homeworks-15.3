
# Object Storage + Bucket

resource "yandex_storage_bucket" "site-bucket" {
    depends_on = [ yandex_iam_service_account.sa4bucket ]
    access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
    bucket     = "bosone.ru"
    acl        = "public-read"
    website {
        index_document = "index.html"
    }
    https {
        certificate_id = yandex_cm_certificate.le-certificate.id
    }
}
resource "yandex_storage_bucket" "pictures-bucket" {
    depends_on = [ yandex_iam_service_account.sa4bucket ]
    access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
    bucket = "pictures-bucket"
    acl    = "public-read"

    anonymous_access_flags {
        read = true
        list = false
    }
    server_side_encryption_configuration {
        rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = yandex_kms_symmetric_key.s-key.id
            sse_algorithm     = "aws:kms"
        }
        }
    }
}
resource "yandex_storage_object" "index-site" {
    depends_on = [ yandex_storage_bucket.site-bucket ]
    access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
    bucket     = yandex_storage_bucket.site-bucket.bucket
    key        = "index.html"
    source     = "../index.html"
    acl        = "public-read"
}
resource "yandex_storage_object" "picture-1" {
    depends_on = [ yandex_storage_bucket.pictures-bucket ]
    access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
    bucket     = yandex_storage_bucket.pictures-bucket.bucket
    key        = "picture-tlz-1.jpg"
    source     = "../picture-tlz-1.jpg"
    acl        = "public-read"
}
resource "yandex_storage_object" "picture-2" {
    depends_on = [ yandex_storage_bucket.site-bucket ]
    access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
    bucket     = yandex_storage_bucket.site-bucket.bucket
    key        = "picture-do-1.png"
    source     = "../picture-do-1.png"
    acl        = "public-read"
}