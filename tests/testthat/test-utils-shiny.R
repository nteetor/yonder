context("test-utils-shiny")

test_that("dropNulls", {
  expect_length(dropNulls(list(NULL, NULL)), 0)
  expect_length(dropNulls(list(1, NULL, 3)), 2)
  expect_equal(dropNulls(list(1, NULL, 3)), list(1, 3))
})
