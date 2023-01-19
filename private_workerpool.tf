resource "google_cloudbuild_worker_pool" "private_pool" {
  for_each = var.cloud_build_private_pools

  project  = var.project_id
  name     = each.key
  location = lookup(each.value, "region")

  worker_config {
    disk_size_gb   = lookup(each.value, "disk_size")
    machine_type   = lookup(each.value, "machine_type")
    no_external_ip = true
  }

  network_config {
    peered_network = format("projects/%s/global/networks/%s",
      var.project_id, lookup(each.value, "network")
    )
  }
}

# https://cloud.google.com/build/docs/private-pools/set-up-private-pool-to-use-in-vpc-network
resource "google_compute_network_peering_routes_config" "service_networking_vpc_peering" {
  for_each = var.cloud_build_private_pools

  project = var.project_id
  network = lookup(each.value, "network")
  peering = "servicenetworking-googleapis-com"

  # export private vpc routes to service networking vpc
  import_custom_routes = false
  export_custom_routes = true
}

# https://cloud.google.com/build/docs/private-pools/use-in-private-network#dns-zones
resource "null_resource" "service_networking_dns_peering" {
  for_each = var.cloud_build_private_pools

  triggers = {
    sha1 = sha1(jsonencode(var.cloud_build_private_pools))
  }

  provisioner "local-exec" {
    command = <<EOT
      if [[ ! $(gcloud services peered-dns-domains list \
                  --project ${var.project_id} \
                  --network ${lookup(each.value, "network")} \
                  --format 'value(NAME)') ]]; then
        gcloud services peered-dns-domains create root \
            --project ${var.project_id} \
            --network ${lookup(each.value, "network")} \
            --dns-suffix=.
      fi
    EOT
  }
}
