context("checkbox input")

test_that("choices and value may be NULL", {
  expect_silent(checkboxInput(id = "ID"))
})

test_that("id argument", {
  expect_missing_id_error(checkboxInput())

  expect_silent(checkboxInput(id = "ID"))
  expect_silent(checkboxInput(id = NULL))

  expect_error(checkboxInput(2))
  expect_error(checkboxInput(""))
  expect_error(checkboxInput(NA_character_))
})

test_that("choices and values must be the same length", {
  expect_error(checkboxInput(id = "ID", choices = c("hello"),
                             values = c("world", "moon")))
  expect_error(checkboxInput(id = "ID", choices = c("hello", "goodnight"),
                             values = "world"))
})

test_that("has dependencies", {
  expect_dependencies(checkboxInput(id = "ID"))
})
