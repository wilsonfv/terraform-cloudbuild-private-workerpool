variable "project_id" {
  type = string
}

variable "cloud_build_private_pools" {
  type = map(object(
    {
      network: string
      region: string
      machine_type: string
      disk_size: number
    }
  ))
  description = "cloudbuild private workerpool attribute definition"
  default = {}
}