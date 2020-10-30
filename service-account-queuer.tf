
resource "google_service_account" "queuer" {
  account_id   = "app-queuer"
  display_name = "app invoker queuer service account"
}

#resource "google_service_account_key" "queuer" {
#  service_account_id = google_service_account.queuer.name
#}

#resource "local_file" "keys_queuer" {
#  content         = base64decode(google_service_account_key.queuer.private_key)
#  filename        = "keys/queuer.json"
#  file_permission = "0600"
#}

resource "google_service_account_iam_binding" "queuer_service_account_users" {
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.queuer.name
  members            = ["domain:xebia.com", "domain:binx.io"]
}
resource "google_service_account_iam_binding" "queuer_service_account_token_creator" {
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.queuer.name
  members            = ["domain:xebia.com", "domain:binx.io"]
}
