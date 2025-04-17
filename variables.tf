variable "project_id" {
  type = string
}

variable "gke_cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "allowed_cidr_block" {
}

variable "network" {
}

variable "subnet" {
}

variable "zone" {
}
