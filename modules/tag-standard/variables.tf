variable "owner" {
  description = "Person or team accountable for the resource, used to route findings and incidents."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,62}$", var.owner))
    error_message = "owner must be 2 to 63 characters: lowercase letters, digits, dot, underscore or hyphen, starting with a letter or digit."
  }
}

variable "team" {
  description = "Owning team, used for ownership lookups and cost reporting."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,62}$", var.team))
    error_message = "team must be 2 to 63 characters: lowercase letters, digits, dot, underscore or hyphen, starting with a letter or digit."
  }
}

variable "env" {
  description = "Environment the resource belongs to."
  type        = string

  validation {
    condition     = contains(["lab", "dev", "staging", "prod"], var.env)
    error_message = "env must be one of: lab, dev, staging, prod."
  }
}

variable "data_class" {
  description = "Data classification of what the resource stores or processes."
  type        = string

  validation {
    condition     = contains(["public", "internal", "confidential", "regulated"], var.data_class)
    error_message = "data_class must be one of: public, internal, confidential, regulated."
  }
}

variable "extra_tags" {
  description = "Additional tags to merge in. Cannot replace the standard tags or use the reserved aws: prefix."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.extra_tags) : !startswith(lower(k), "aws:")])
    error_message = "extra_tags keys must not start with the reserved aws: prefix."
  }
}
