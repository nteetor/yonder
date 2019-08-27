context("list group input")

test_that("id is character or null", {
  expect_silent(listGroupInput("ID"))
  expect_silent(listGroupInput(NULL))

  expect_error(listGroupInput(NA_character_))
  expect_error(listGroupInput(3030))
})

test_that("choices and values same length", {
  expect_silent(listGroupInput("ID", c("one")))
  expect_silent(listGroupInput("ID", c("two"), c("two")))

  expect_error(listGroupInput("ID", c("three"), c("three", "four")))
  expect_error(listGroupInput("ID", c("four", "five"), "four"))
})

test_that("has dependencies", {
  expect_dependencies(listGroupInput("ID"))
})
