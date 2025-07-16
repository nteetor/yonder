test_that("argument id", {
  expect_error(input_button(), "`id` must be a single string")

  expect_error(
    input_button(10),
    "`id` must be a single string, not the number 10"
  )
})
