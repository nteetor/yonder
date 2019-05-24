context("Text and number input")

test_that("id argument", {
  expect_silent(textInput("id"))
  expect_silent(textInput(NULL))
  expect_silent(numberInput("id"))
  expect_silent(numberInput(NULL))

  expect_error(textInput(NA))
  expect_error(numberInput(NA))
})
