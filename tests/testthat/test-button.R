context("button input")

test_that("argument id must be character or null", {
  expect_error(buttonInput(id = 1, label = "LABEL"))
  expect_silent(buttonInput(id = "ID", label = "LABEL"))
})
