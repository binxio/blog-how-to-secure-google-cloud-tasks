
output "commands" {
  value = <<EOF

# call from python with service account key
(
    cd ${dirname(abspath(path.module))}
      pipenv run python ./call.py \
	--queue ${google_cloud_tasks_queue.app.id} \
	--url ${google_cloud_run_service.app.status[0].url}/status \
	--service-account ${google_service_account.invoker.email} \
        --impersonate-service-account ${google_service_account.queuer.email}
)

# async call via gcloud
gcloud tasks create-http-task \
    --url ${google_cloud_run_service.app.status[0].url}/status \
    --method GET \
    --queue ${google_cloud_tasks_queue.app.id} \
    --oidc--email ${google_service_account.invoker.email} \
    --oidc-token-audience  ${google_cloud_run_service.app.status[0].url} \
    --impersonate-service-account ${google_service_account.queuer.email}

EOF
}
