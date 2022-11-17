output "kubectl_command" {
  value       = "gcloud container clusters get-credentials ${google_container_cluster.app_cluster.name} --region ${var.region} --project ${var.project_id}"
  description = "kubectl command to connect to cluster."
  
}

