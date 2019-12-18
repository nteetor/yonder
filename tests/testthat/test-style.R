context("design utilities")

test_that("style pronoun", {
  expect_equal(as.character(div(.style)), as.character(div()))
})
