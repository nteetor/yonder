context("chip input")

test_that("id is character or null", {
  expect_silent(chipInput("ID"))
  expect_silent(chipInput(NULL))

  expect_error(chipInput(NA_character_))
  expect_error(chipInput(""))
})

test_that("choices and values must be the same length", {
  expect_error(chipInput("ID", c("choice1", "choice2"), "value1"))
  expect_error(chipInput("ID", "choice1", c("value1", "value2")))
})

test_that("has dependencies", {
  expect_dependencies(chipInput("ID"))
})
