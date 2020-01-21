context("list group input")

test_that("id is character or null", {
  expect_silent(listGroupInput(id = "ID"))
  expect_silent(listGroupInput(id = NULL))

  expect_error(listGroupInput(id = NA_character_))
  expect_error(listGroupInput(id = 3030))
})

test_that("choices and values same length", {
  expect_silent(listGroupInput(id = "ID", choices = c("one")))
  expect_silent(listGroupInput(
    id = "ID", choices = c("two"), values = c("two")
  ))

  expect_error(listGroupInput(
    id = "ID", choices = c("three"), values = c("three", "four")
  ))
  expect_error(listGroupInput(
    id = "ID", choices = c("four", "five"), values = "four"
  ))
})

test_that("has dependencies", {
  expect_dependencies(listGroupInput(id = "ID"))
})
