
resource "google_cloud_tasks_queue" "app" {
  name     = "app"
  location = var.region
}

resource "google_project_iam_binding" "cloudtasks_enqueuer" {
  role = "roles/cloudtasks.enqueuer"
  members = [
    "serviceAccount:${google_service_account.queuer.email}",
  ]
}

data google_project current {}

resource google_project_iam_binding "cloudtasks-service-agent" {
  role    = "roles/cloudtasks.serviceAgent"
  members = ["serviceAccount:service-${data.google_project.current.number}@gcp-sa-cloudtasks.iam.gserviceaccount.com"]
}
