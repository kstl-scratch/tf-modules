# tag-standard

Computes the standard tag map that every resource must carry. It creates no resources and needs no provider, so it is free to test.

## Usage

```hcl
module "tags" {
  source = "../../modules/tag-standard"

  owner      = "platform"
  team       = "security"
  env        = "lab"
  data_class = "internal"
}

resource "aws_s3_bucket" "example" {
  bucket = "kstl-example"
  tags   = module.tags.tags
}
```

## Inputs

| Name | Description | Allowed values | Required |
| --- | --- | --- | --- |
| owner | Person or team accountable for the resource | 2 to 63 characters: lowercase letters, digits, `.`, `_`, `-` | yes |
| team | Owning team, used for ownership lookups and cost reporting | Same format as owner | yes |
| env | Environment | lab, dev, staging, prod | yes |
| data_class | Data classification | public, internal, confidential, regulated | yes |
| extra_tags | Additional tags to merge in | Map of strings; no `aws:` prefix; cannot reuse a standard key | no |

## Outputs

| Name | Description |
| --- | --- |
| tags | Complete tag map: owner, team, env, data-class, managed-by, plus any extra_tags |

## Rules

- `managed-by` is always `terraform` and cannot be overridden.
- `extra_tags` cannot reuse a standard key; the plan fails if it does.
- Invalid `env` or `data_class` values fail at plan time.

## Tests

Run from the repository root:

```
terraform -chdir=modules/tag-standard test
```

The tests cover valid input, merging, and each rejection rule.
