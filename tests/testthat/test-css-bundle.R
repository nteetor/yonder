context("* bundle css files")

test_that("css files bundled", {
  skip_on_cran()

  expect_silent(
    withr::with_dir(
      file.path("..", "..", "CSS"),
      system("gulp", intern = TRUE)
    )
  )
})
