locals {
  prism = sensitive(jsondecode(file(local.prism_credentials_file)))
  size  = local.sizes[var.taille]

  cloud_config = merge(
    { hostname = var.vm_name },
    local.ssh_public_key == "" ? {} : {
      users = [{
        name                = local.ssh_user
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        shell               = "/bin/bash"
        ssh_authorized_keys = [local.ssh_public_key]
      }]
    }
  )
}

provider "nutanix" {
  endpoint = local.prism.endpoint
  username = local.prism.username
  password = local.prism.password
  port     = 9440
  insecure = true # POC uniquement : accepte un certificat Prism Central auto-signé
}

data "nutanix_cluster" "this" {
  name = local.cluster_name
}

data "nutanix_subnet" "this" {
  subnet_name = local.subnet_name
}

data "nutanix_image" "this" {
  image_name = local.image_name
}

resource "nutanix_virtual_machine" "vm" {
  name                 = var.vm_name
  description          = "POC ManageIQ - taille ${var.taille}"
  cluster_uuid         = data.nutanix_cluster.this.id
  num_sockets          = local.size.vcpus
  num_vcpus_per_socket = 1
  memory_size_mib      = local.size.memory_mib
  boot_type            = local.boot_type

  disk_list {
    disk_size_mib = local.size.disk_gib * 1024

    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.this.id
    }

    device_properties {
      device_type = "DISK"
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
    }
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.this.id
  }

  guest_customization_cloud_init_user_data = base64encode("#cloud-config\n${yamlencode(local.cloud_config)}")
}
