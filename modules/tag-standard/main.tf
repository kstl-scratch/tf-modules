locals {
  standard_tags = {
    owner        = var.owner
    team         = var.team
    env          = var.env
    "data-class" = var.data_class
    managed-by   = "terraform"
  }

  # Standard tags are merged last, so they always win over extra_tags.
  tags = merge(var.extra_tags, local.standard_tags)
}
