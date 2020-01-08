context("link input")

test_that("id argument", {
  expect_missing_id_error(linkInput())
  expect_error(linkInput(id = 2, "TEXT"))

  expect_silent(linkInput(id = "ID", "TEXT"))
})

test_that("download argument", {
  expect_true(
    tag_name_is(linkInput(id = "ID", "TEXT", download = FALSE), "button")
  )

  expect_true(
    tag_name_is(linkInput(id = "ID", "TEXT", download = TRUE), "a")
  )
})

test_that("has dependencies", {
  expect_dependencies(linkInput("ID", "LABEL"))
})
