context("radio input")

test_that("id argument", {
  expect_missing_id_error(radioInput())
  expect_error(radioInput(2))

  expect_silent(radioInput("ID"))
  expect_silent(radioInput(NULL))
})

test_that("choices argument", {
  expect_error(radioInput("ID", 1:3, 1))
  expect_error(radioInput("ID", values = 1:3))

  expect_silent(radioInput("ID", 1:3, 1:3))
})

test_that("selected argument", {
  expect_error(radioInput("ID", 1:3, selected = 1:2))

  expect_silent(radioInput("ID", 1:3, selected = 3))
})

test_that("returns tag", {
  expect_is(radioInput("ID", 1:3), "shiny.tag")
})

test_that("update", {
  expect_missing_id_error(updateRadioInput())
  expect_error(updateRadioInput("ID", values = 1:3))
  expect_error(updateRadioInput("ID", selected = 1:2))
  expect_error(updateRadioInput("ID"))

  expect_silent(updateRadioInput("ID", session = test_domain()))
})

test_that("has dependencies", {
  expect_dependencies(radioInput("ID"))
})
