module "vpc_network" {
  source  = "terraform-google-modules/network/google"
  version = "3.0.1"

  project_id   = var.project_id
  network_name = "${var.cluster_name}-gke-vpc"

  subnets = [
    {
      subnet_name   = "${var.cluster_name}-gke-subnet"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.cluster_name}-gke-subnet" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

module "gke_cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "13.0.0"

  project_id         = var.project_id
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  regional           = true
  region             = var.region
  network            = module.vpc_network.network_name
  subnetwork         = module.vpc_network.subnets_names[0]
  ip_range_pods      = var.ip_range_pods_name
  ip_range_services  = var.ip_range_services_name
  node_pools = [
    {
      name           = "default-node-pool"
      machine_type   = "e2-medium"
      node_locations = "europe-west1-b,europe-west1-c,europe-west1-d"
      min_count      = 1
      max_count      = 2
      disk_size_gb   = 10
      preemptible    = false
    },
    {
      name           = "standard-preemptible-node-pool"
      machine_type   = "n2-standard-2"
      node_locations = "europe-west1-b"
      min_count      = 1
      max_count      = 2
      disk_size_gb   = 10
      preemptible    = true
    }
  ]
}

module "gke_auth" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "13.0.0"

  project_id   = var.project_id
  location     = module.gke_cluster.location
  cluster_name = module.gke_cluster.name

  depends_on = [module.gke_cluster]
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig-${var.cluster_name}"
  content  = module.gke_auth.kubeconfig_raw
}
