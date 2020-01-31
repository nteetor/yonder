context("button group input")

test_that("id argument", {
  expect_missing_id_error(buttonGroupInput())
  expect_error(buttonGroupInput(id = 2, choices = "LABEL"))
  expect_silent(buttonGroupInput(id = "ID", choices = "LABELS"))
})

test_that("`choices` argument", {
  expect_error(buttonGroupInput(id = "ID", choices = c("A", "B"), values = "C"))
  expect_silent(buttonGroupInput(id = "ID", choices = c("A", "B")))
  expect_silent(buttonGroupInput(id = "ID", choices = c("A", "B"), values = c("C", "D")))
})

test_that("has dependencies", {
  expect_dependencies(buttonGroupInput(id = "ID"))
})

test_that("`labels` argument is deprecated", {
  rlang::with_options(lifecycle_verbosity = "warning", {
    expect_warning(buttonGroupInput(id = "ID", labels = c("hello", "world")))
  })
})
