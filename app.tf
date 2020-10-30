resource "google_cloud_run_service" "app" {
  name = "app"


  template {
    spec {
      containers {
        image = "gcr.io/binx-io-public/paas-monitor:latest"
      }
      service_account_name = google_service_account.app.email
    }
  }
  location                   = var.region
  autogenerate_revision_name = true

}


resource "google_service_account" "app" {
  account_id   = "app-run"
  display_name = "app service account"
}


resource "google_cloud_run_service_iam_binding" "app-run-invoker" {
  role = "roles/run.invoker"
  members = [
    "serviceAccount:${google_service_account.invoker.email}"
  ]
  service  = google_cloud_run_service.app.name
  location = google_cloud_run_service.app.location
}

