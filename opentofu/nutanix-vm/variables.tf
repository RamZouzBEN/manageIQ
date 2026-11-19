variable "vm_name" {
  type        = string
  description = "Nom de la VM : 3 à 40 caractères, minuscules, chiffres et tirets"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,38}[a-z0-9]$", var.vm_name))
    error_message = "Le nom doit contenir 3 à 40 caractères : minuscules, chiffres et tirets, sans tiret au début ni à la fin."
  }
}

variable "taille" {
  type        = string
  description = "Taille de la VM : petite, moyenne ou grande"
  default     = "petite"

  validation {
    condition     = contains(["petite", "moyenne", "grande"], var.taille)
    error_message = "La taille doit être petite, moyenne ou grande."
  }
}

variable "cluster_uuid" {
  type        = string
  description = "UUID du cluster Nutanix"
}

variable "subnet_uuid" {
  type        = string
  description = "UUID du réseau de la VM"
}

variable "image_uuid" {
  type        = string
  description = "UUID de l'image du système d'exploitation"
}

variable "boot_type" {
  type        = string
  description = "Type de démarrage de l'image"
  default     = "LEGACY"

  validation {
    condition     = contains(["LEGACY", "UEFI"], var.boot_type)
    error_message = "Le type de démarrage doit être LEGACY ou UEFI."
  }
}

# Accès à Prism Central : fournis par l'agent, ou par les variables globales de Terrakube
variable "prism_endpoint" {
  type        = string
  description = "Adresse de Prism Central"
}

variable "prism_username" {
  type        = string
  description = "Compte Prism Central"
}

variable "prism_password" {
  type        = string
  description = "Mot de passe Prism Central"
  sensitive   = true
}

# Compte créé par cloud-init pour la configuration Ansible
variable "ssh_user" {
  type        = string
  description = "Compte créé dans la VM au premier démarrage"
  default     = "pocadmin"
}

variable "ssh_public_key" {
  type        = string
  description = "Clé SSH publique de l'administrateur"
  default     = ""
}

variable "agent_public_key" {
  type        = string
  description = "Clé SSH publique de l'agent du portail"
  default     = ""
}
