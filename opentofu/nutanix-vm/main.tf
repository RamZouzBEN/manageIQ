locals {
  size            = local.sizes[var.taille]
  authorized_keys = compact([var.ssh_public_key, var.agent_public_key])

  cloud_config = merge(
    { hostname = var.vm_name },
    length(local.authorized_keys) == 0 ? {} : {
      users = [{
        name                = var.ssh_user
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        shell               = "/bin/bash"
        ssh_authorized_keys = local.authorized_keys
      }]
    }
  )
}

provider "nutanix" {
  endpoint = var.prism_endpoint
  username = var.prism_username
  password = var.prism_password
  port     = 9440
  insecure = true # POC uniquement : accepte un certificat Prism Central auto-signé
}

resource "nutanix_virtual_machine" "vm" {
  name                   = var.vm_name
  description            = "POC Jira Service Management - taille ${var.taille}"
  cluster_uuid           = var.cluster_uuid
  num_sockets            = local.size.vcpus
  num_vcpus_per_socket   = 1
  memory_size_mib        = local.size.memory_mib
  boot_type              = var.boot_type
  boot_device_order_list = var.boot_type == "LEGACY" ? ["DISK", "CDROM", "NETWORK"] : null

  disk_list {
    disk_size_mib = local.size.disk_gib * 1024

    data_source_reference = {
      kind = "image"
      uuid = var.image_uuid
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
    subnet_uuid = var.subnet_uuid
  }

  guest_customization_cloud_init_user_data = base64encode("#cloud-config\n${yamlencode(local.cloud_config)}")
}
