test_that("argument `id`", {
  expect_error(input_list_group(), "`id` must be a single string")
  expect_error(input_list_group(20), "`id` must be a single string")
  expect_error(input_list_group(NULL), "`id` must be a single string")
  expect_error(input_list_group(NA_character_), "`id` must be a single string")
})
