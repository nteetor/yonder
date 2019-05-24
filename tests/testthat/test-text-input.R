context("Text and number input")

test_that("id argument", {
  expect_silent(textInput("id"))
  expect_silent(textInput(NULL))
  expect_silent(numberInput("id"))
  expect_silent(numberInput(NULL))

  expect_error(textInput(NA))
  expect_error(numberInput(NA))
})

test_that("min, max, step added to <input> child element", {
  element <- numberInput("ID", min = 1, max = 10, step = 2)

  expect_equal(element$children[[1]]$attribs$min, 1)
  expect_equal(element$children[[1]]$attribs$max, 10)
  expect_equal(element$children[[1]]$attribs$step, 2)
  expect_match(as.character(element), 'min="1" max="10" step="2"')
})
