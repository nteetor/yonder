test_that("id argument", {
  expect_error(input_checkbox(), "`id` must be a single string")

  expect_error(input_checkbox(20), "`id` must be a single string")

  expect_error(input_checkbox(NULL), "`id` must be a single string")
})
