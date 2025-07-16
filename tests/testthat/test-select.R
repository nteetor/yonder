test_that("argument `id`", {
  expect_error(input_select(), "`id`")

  expect_silent(input_select("test", c("Choice 1", "Choice 2")))
})
