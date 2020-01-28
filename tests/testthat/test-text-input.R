context("text and number input")

test_that("id argument", {
  expect_silent(textInput(id = "id"))
  expect_silent(textInput(id = NULL))
  expect_silent(numberInput(id = "id"))
  expect_silent(numberInput(id = NULL))

  expect_error(textInput(id = NA))
  expect_error(numberInput(id = NA))
})

test_that("min, max, step added to <input> child element", {
  element <- numberInput(id = "ID", min = 1, max = 10, step = 2)

  expect_equal(element$children[[1]]$attribs$min, 1)
  expect_equal(element$children[[1]]$attribs$max, 10)
  expect_equal(element$children[[1]]$attribs$step, 2)
  expect_match(as.character(element), 'min="1" max="10" step="2"')
})

test_that("has dependencies", {
  expect_dependencies(textInput(id = "ID"))
})
