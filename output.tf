
output "bastion_open_tunnel_command" {
  description = "Command that opens an SSH tunnel to the Bastion instance."
  value       = module.bastion.ssh
}


output "kubectl_command" {
  value       = module.google_kubernetes_cluster.kubectl_command
  description = "kubectl command to connect to cluster."

}