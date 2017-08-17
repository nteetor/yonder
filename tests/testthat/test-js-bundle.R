context("* bundle js files")

test_that("js files bundled", {
  skip_on_cran()

  expect_silent(
    withr::with_dir(
      file.path("..", "..", "JS"),
      system("gulp", intern = TRUE)
    )
  )
})


