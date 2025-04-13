resource "google_project_service" "container" {
  project            = var.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "minimal" {
  name                = var.gke_cluster_name
  location            = var.region
  deletion_protection = var.deletion_protection
  node_pool {
    name               = "default-node-pool"
    initial_node_count = 1 # Limit the node pool to 1 node
    node_config {
      machine_type = "e2-medium"
    }
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "202.92.122.131/32"
      display_name = "Douglas Home IP"
    }
  }
  depends_on = [google_project_service.container]
}

resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_cluster_name} --region ${var.region} --project ${var.project_id}"
  }
  depends_on = [google_container_cluster.minimal]
}
