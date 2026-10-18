run "valid_inputs_produce_standard_tags" {
  command = plan

  variables {
    owner      = "platform"
    team       = "security"
    env        = "lab"
    data_class = "internal"
  }

  assert {
    condition     = output.tags["owner"] == "platform"
    error_message = "owner tag was not set from the input."
  }

  assert {
    condition     = output.tags["data-class"] == "internal"
    error_message = "data-class tag was not set from data_class."
  }

  assert {
    condition     = output.tags["managed-by"] == "terraform"
    error_message = "managed-by tag must always be terraform."
  }
}

run "extra_tags_are_merged" {
  command = plan

  variables {
    owner      = "platform"
    team       = "security"
    env        = "lab"
    data_class = "internal"
    extra_tags = { project = "kstl" }
  }

  assert {
    condition     = output.tags["project"] == "kstl"
    error_message = "extra_tags were not merged into the result."
  }
}

run "rejects_unknown_env" {
  command = plan

  variables {
    owner      = "platform"
    team       = "security"
    env        = "Prod"
    data_class = "internal"
  }

  expect_failures = [var.env]
}

run "rejects_unknown_data_class" {
  command = plan

  variables {
    owner      = "platform"
    team       = "security"
    env        = "lab"
    data_class = "secret"
  }

  expect_failures = [var.data_class]
}

run "rejects_reserved_aws_prefix" {
  command = plan

  variables {
    owner      = "platform"
    team       = "security"
    env        = "lab"
    data_class = "internal"
    extra_tags = { "aws:cloudformation:stack-name" = "x" }
  }

  expect_failures = [var.extra_tags]
}

run "extra_tags_cannot_override_standard" {
  command = plan

  variables {
    owner      = "platform"
    team       = "security"
    env        = "lab"
    data_class = "internal"
    extra_tags = { env = "prod" }
  }

  expect_failures = [output.tags]
}
