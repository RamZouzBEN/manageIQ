# Valeurs propres à ton environnement : à adapter une seule fois.
locals {
  cluster_name = "ELC1" # Nom du cluster Nutanix
  subnet_uuid  = "72de71c9-c617-498d-9f94-b6857e1e9b58" # UUID du subnet des VM du POC
  image_name   = "jammy-server-cloudimg-amd64-disk-kvm.img" # Image cloud (Rocky, Ubuntu...) présente dans Prism Central
  boot_type    = "UEFI"      # LEGACY ou UEFI, selon l'image

  # Clé SSH publique injectée par cloud-init (facultatif)
  ssh_public_key = ""
  ssh_user       = "pocadmin"

  # Catalogue des tailles proposées aux utilisateurs
  sizes = {
    petite  = { vcpus = 2, memory_mib = 4096, disk_gib = 40 }
    moyenne = { vcpus = 4, memory_mib = 8192, disk_gib = 80 }
    grande  = { vcpus = 8, memory_mib = 16384, disk_gib = 160 }
  }

  # Fichier créé sur l'appliance par scripts/setup-appliance.sh
  prism_credentials_file = "/etc/manageiq-poc/prism.json"
}
