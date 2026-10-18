output "tags" {
  description = "Complete tag map to apply to every resource: the standard tags plus any extra_tags."
  value       = local.tags

  precondition {
    condition     = length(setintersection(keys(var.extra_tags), keys(local.standard_tags))) == 0
    error_message = "extra_tags must not reuse a standard tag key (owner, team, env, data-class, managed-by)."
  }
}
