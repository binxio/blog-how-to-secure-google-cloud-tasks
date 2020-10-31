
output "commands" {
  value = <<EOF

gcloud tasks create-http-task \
	--queue ${google_cloud_tasks_queue.app.id} \
	--url ${google_cloud_run_service.app.status[0].url}/status \
        --method GET \
	--oidc-service-account-email ${google_service_account.invoker.email} \
	--oidc-token-audience  ${google_cloud_run_service.app.status[0].url} \
        --impersonate-service-account ${google_service_account.queuer.email}

EOF
}
