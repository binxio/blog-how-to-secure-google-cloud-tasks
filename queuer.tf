# the queur service account
resource "google_service_account" "queuer" {
  account_id   = "app-queuer"
  display_name = "app invoker queuer service account"
}

# identities allowed to actAs the queuer
resource "google_service_account_iam_binding" "queuer_service_account_users" {
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.queuer.name
  members            = ["domain:xebia.com", "domain:binx.io"]
}

# identities allowed to create a queuer sa token
resource "google_service_account_iam_binding" "queuer_service_account_token_creator" {
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.queuer.name
  members            = ["domain:xebia.com", "domain:binx.io"]
}
