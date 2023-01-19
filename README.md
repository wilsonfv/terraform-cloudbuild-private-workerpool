# terraform-cloudbuild-private-workerpool
[Terraform](https://developer.hashicorp.com/terraform/intro) module to provision Google Cloud Platform [Cloud Build private worker pool](https://cloud.google.com/build/docs/private-pools/create-manage-private-pools) and [relevant VPC network setting](https://cloud.google.com/build/docs/private-pools/use-in-private-network).

## Prerequisite
* [VPC network](https://cloud.google.com/vpc/docs/create-modify-vpc-networks#create-custom-network) must be presence
* [Private Service Connection](https://cloud.google.com/build/docs/private-pools/set-up-private-pool-to-use-in-vpc-network#setup-private-connection) must be presence

## GCP IAM Roles
Minimum GCP iam roles to proceed terraform provision.
* [Cloud Build WorkerPool Owner (roles/cloudbuild.workerPoolOwner)](https://cloud.google.com/iam/docs/understanding-roles#cloudbuild.workerPoolOwner)
* [Compute Network Admin (roles/compute.networkAdmin)](https://cloud.google.com/iam/docs/understanding-roles#compute.networkAdmin)

## Usage
Prepare private worker pool [definition](https://cloud.google.com/build/docs/private-pools/private-pool-config-file-schema) json file, see [sample_private_workerpool.tfvars.json](sample_private_workerpool.tfvars.json) for reference. <br/>
Run terraform apply on the module, see sample output below 
```
$ terraform apply -var project_id=usecase-eu-dev -var-file sample_private_workerpool.tfvars.json

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"] will be created
  + resource "google_cloudbuild_worker_pool" "private_pool" {
      + create_time = (known after apply)
      + delete_time = (known after apply)
      + id          = (known after apply)
      + location    = "europe-west2"
      + name        = "private-pool-vpc1"
      + project     = "usecase-eu-dev"
      + state       = (known after apply)
      + uid         = (known after apply)
      + update_time = (known after apply)

      + network_config {
          + peered_network = "projects/usecase-eu-dev/global/networks/usecase-vpc1"
        }

      + worker_config {
          + disk_size_gb   = 200
          + machine_type   = "e2-medium"
          + no_external_ip = true
        }
    }

  # google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"] will be created
  + resource "google_cloudbuild_worker_pool" "private_pool" {
      + create_time = (known after apply)
      + delete_time = (known after apply)
      + id          = (known after apply)
      + location    = "europe-west1"
      + name        = "private-pool-vpc2"
      + project     = "usecase-eu-dev"
      + state       = (known after apply)
      + uid         = (known after apply)
      + update_time = (known after apply)

      + network_config {
          + peered_network = "projects/usecase-eu-dev/global/networks/usecase-vpc2"
        }

      + worker_config {
          + disk_size_gb   = 100
          + machine_type   = "e2-medium"
          + no_external_ip = true
        }
    }

  # google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc1"] will be created
  + resource "google_compute_network_peering_routes_config" "service_networking_vpc_peering" {
      + export_custom_routes = true
      + id                   = (known after apply)
      + import_custom_routes = false
      + network              = "usecase-vpc1"
      + peering              = "servicenetworking-googleapis-com"
      + project              = "usecase-eu-dev"
    }

  # google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc2"] will be created
  + resource "google_compute_network_peering_routes_config" "service_networking_vpc_peering" {
      + export_custom_routes = true
      + id                   = (known after apply)
      + import_custom_routes = false
      + network              = "usecase-vpc2"
      + peering              = "servicenetworking-googleapis-com"
      + project              = "usecase-eu-dev"
    }

  # null_resource.service_networking_dns_peering["private-pool-vpc1"] will be created
  + resource "null_resource" "service_networking_dns_peering" {
      + id       = (known after apply)
      + triggers = {
          + "sha1" = "68cb6d47dfba62caf058b3e5fdfab116ea3ea40e"
        }
    }

  # null_resource.service_networking_dns_peering["private-pool-vpc2"] will be created
  + resource "null_resource" "service_networking_dns_peering" {
      + id       = (known after apply)
      + triggers = {
          + "sha1" = "68cb6d47dfba62caf058b3e5fdfab116ea3ea40e"
        }
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.service_networking_dns_peering["private-pool-vpc2"]: Creating...
null_resource.service_networking_dns_peering["private-pool-vpc1"]: Creating...
null_resource.service_networking_dns_peering["private-pool-vpc1"]: Provisioning with 'local-exec'...
null_resource.service_networking_dns_peering["private-pool-vpc2"]: Provisioning with 'local-exec'...
null_resource.service_networking_dns_peering["private-pool-vpc1"] (local-exec): Executing: ["/bin/sh" "-c" "      if [[ ! $(gcloud services peered-dns-domains list \\\n                  --project usecase-eu-dev \\\n                  --network usecase-vpc1 \\\n                  --format 'value(NAME)') ]]; then\n        gcloud services peered-dns-domains create root \\\n            --project usecase-eu-dev \\\n            --network usecase-vpc1 \\\n            --dns-suffix=.\n      fi\n"]
null_resource.service_networking_dns_peering["private-pool-vpc2"] (local-exec): Executing: ["/bin/sh" "-c" "      if [[ ! $(gcloud services peered-dns-domains list \\\n                  --project usecase-eu-dev \\\n                  --network usecase-vpc2 \\\n                  --format 'value(NAME)') ]]; then\n        gcloud services peered-dns-domains create root \\\n            --project usecase-eu-dev \\\n            --network usecase-vpc2 \\\n            --dns-suffix=.\n      fi\n"]
google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc1"]: Creating...
google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc2"]: Creating...
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Creating...
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Creating...
null_resource.service_networking_dns_peering["private-pool-vpc1"]: Creation complete after 6s [id=4647345999822409040]
null_resource.service_networking_dns_peering["private-pool-vpc2"]: Creation complete after 8s [id=2050716494488319925]
google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc2"]: Still creating... [10s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Still creating... [10s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Still creating... [10s elapsed]
google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc1"]: Still creating... [10s elapsed]
google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc2"]: Creation complete after 14s [id=projects/usecase-eu-dev/global/networks/usecase-vpc2/networkPeerings/servicenetworking-googleapis-com]
google_compute_network_peering_routes_config.service_networking_vpc_peering["private-pool-vpc1"]: Creation complete after 14s [id=projects/usecase-eu-dev/global/networks/usecase-vpc1/networkPeerings/servicenetworking-googleapis-com]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Still creating... [20s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Still creating... [20s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Still creating... [30s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Still creating... [30s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Still creating... [40s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Still creating... [40s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Still creating... [50s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Still creating... [50s elapsed]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc1"]: Creation complete after 55s [id=projects/usecase-eu-dev/locations/europe-west2/workerPools/private-pool-vpc1]
google_cloudbuild_worker_pool.private_pool["private-pool-vpc2"]: Creation complete after 59s [id=projects/usecase-eu-dev/locations/europe-west1/workerPools/private-pool-vpc2]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```