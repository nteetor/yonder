test_that("argument `id`", {
  expect_error(input_radio_group(), "`id`")

  expect_silent(input_radio_group("test", c("Choice 1", "Choice 2")))
})
