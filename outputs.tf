output "cluster_ca_certificate" {
  value = google_container_cluster.minimal.master_auth.0.cluster_ca_certificate
}
