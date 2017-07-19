context("* bundle JS files")

test_that("files pass linting", {
  skip_on_cran()

  expect_silent(
    withr::with_dir(
      file.path("..", "..", "JS"),
      system("gulp eslint", intern = TRUE)
    )
  )
})

test_that("files bundle properly", {
  skip_on_cran()

  expect_silent(
    withr::with_dir(
      file.path("..", "..", "JS"),
      system("gulp scripts", intern = TRUE)
    )
  )
})


