context("link input")

test_that("id argument", {
  expect_missing_id_error(linkInput())
  expect_error(linkInput(id = 2, "TEXT"))

  expect_silent(linkInput(id = "ID", label = "TEXT"))
})

test_that("download argument", {
  expect_true(
    tag_name_is(linkInput(id = "ID", label = "TEXT", download = FALSE), "button")
  )

  expect_true(
    tag_name_is(linkInput(id = "ID", label = "TEXT", download = TRUE), "a")
  )
})

test_that("has dependencies", {
  expect_dependencies(linkInput(id = "ID", label = "LABEL"))
})
