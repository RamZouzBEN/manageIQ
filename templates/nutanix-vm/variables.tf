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
