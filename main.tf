resource "google_project_service" "container" {
  project            = var.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "minimal" {
  name                = var.gke_cluster_name
  location            = var.region
  deletion_protection = var.deletion_protection
  network = var.network
  subnet = var.subnet

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  node_pool {
    name               = "default-node-pool"
    initial_node_count = 1 # Limit the node pool to 1 node
    node_config {
      machine_type = "e2-medium"
    }
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "${var.allowed_cidr_block}/32"
      display_name = "WireGuard Client"
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
