variable "project_id" {
  description = "The project ID where all resources will be launched"
  type        = string
  default     = "utility-ratio-304121"
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster"
  type        = string
  default     = "europe-west1-b"
}

variable "region" {
  description = "The region for the network"
  type        = string
  default     = "europe-west1"
}

variable "env" {
  description = "The environment for the GKE cluster"
  type        = string
  default     = "staging"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
  default     = "test"
}

variable "kubernetes_version" {
  description = "The K8s version for the GKE cluster"
  type        = string
  default     = "1.18.15-gke.800"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  type        = string
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  type        = string
  default     = "ip-range-services"
}