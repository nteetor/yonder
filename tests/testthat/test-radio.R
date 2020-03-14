context("radio input")

test_that("id argument", {
  expect_missing_id_error(radioInput())
  expect_error(radioInput(id = 2))

  expect_silent(radioInput(id = "ID"))
  expect_silent(radioInput(id = NULL))
})

test_that("choices argument", {
  expect_error(radioInput(id = "ID", choices = LETTERS[1:3], values = 1))
  expect_error(radioInput(id = "ID", values = 1:3))

  expect_silent(radioInput(id = "ID", choices = LETTERS[1:3], values = 1:3))
})

test_that("selected argument", {
  expect_error(radioInput(id = "ID", choices = LETTERS[1:3], selected = 1:2))

  expect_silent(radioInput(id = "ID", choices = LETTERS[1:3], values = 1:3, selected = 3))
})

test_that("returns tag", {
  expect_is(radioInput(id = "ID", choices = LETTERS[1:3]), "shiny.tag")
})

test_that("update", {
  expect_missing_id_error(updateRadioInput())
  expect_error(updateRadioInput(id = "ID", values = 1:3))
  expect_error(updateRadioInput(id = "ID", selected = 1:2))
  expect_error(updateRadioInput(id = "ID"))

  expect_silent(updateRadioInput(id = "ID", session = test_domain()))
})

test_that("has dependencies", {
  expect_dependencies(radioInput(id = "ID"))
})
