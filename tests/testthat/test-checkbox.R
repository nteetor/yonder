context("checkbox input")

test_that("choices and value may be NULL", {
  expect_silent(checkboxInput("ID"))
})

test_that("id must be NULL or character", {
  expect_silent(checkboxInput("ID"))
  expect_silent(checkboxInput(NULL))

  expect_error(checkboxInput(2))
  expect_error(checkboxInput(""))
  expect_error(checkboxInput(NA_character_))
})

test_that("choices and values must be the same length", {
  expect_error(checkboxInput("ID", c("hello"), c("world", "moon")))
  expect_error(checkboxInput("ID", c("hello", "goodnight"), "world"))
})
