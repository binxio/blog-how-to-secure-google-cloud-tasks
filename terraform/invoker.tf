# the invoker service account
resource "google_service_account" "invoker" {
  account_id   = "app-invoker"
  display_name = "app invoker service account"
}

# grant the queuer to actAs the invoker
resource "google_service_account_iam_binding" "invoker_service_account_users" {
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.invoker.name
  members            = ["serviceAccount:${google_service_account.queuer.email}"]
}
