# the queuer service account
resource "google_service_account" "queuer" {
  account_id   = "app-queuer"
  display_name = "app invoker queuer service account"
}


# grant to allow to assume the role of queuer
resource "google_service_account_iam_member" "binx_io_queuer_service_account_token_creator" {
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.queuer.name
  member             = "user:markvanholsteijn@binx.io"
}
