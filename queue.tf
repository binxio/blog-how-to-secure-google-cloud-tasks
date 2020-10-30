# the queue for async calls to the application
resource "google_cloud_tasks_queue" "app" {
  name     = "app"
  location = var.region
}

# grant the queuer sa the right to queue tasks
resource "google_project_iam_binding" "cloudtasks_enqueuer" {
  role = "roles/cloudtasks.enqueuer"
  members = [
    "serviceAccount:${google_service_account.queuer.email}",
  ]
}

# ensure that the cloud task service agent is allowed in the project
resource google_project_iam_binding "cloudtasks-service-agent" {
  role    = "roles/cloudtasks.serviceAgent"
  members = ["serviceAccount:service-${data.google_project.current.number}@gcp-sa-cloudtasks.iam.gserviceaccount.com"]
}

data google_project current {}
