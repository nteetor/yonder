test_that("argument `id`", {
  expect_error(modal_dialog())

  expect_silent(modal_dialog("test"))
})
