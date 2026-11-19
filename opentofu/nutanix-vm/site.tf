# Catalogue des tailles proposées sur le portail.
# Les accès Prism Central et les clés SSH arrivent par des variables (voir variables.tf) :
# aucun secret n'est écrit dans ce dépôt.
locals {
  sizes = {
    petite  = { vcpus = 2, memory_mib = 4096, disk_gib = 40 }
    moyenne = { vcpus = 4, memory_mib = 8192, disk_gib = 80 }
    grande  = { vcpus = 8, memory_mib = 16384, disk_gib = 160 }
  }
}
