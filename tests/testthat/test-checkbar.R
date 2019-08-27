context("checkbar input")

test_that("id argument", {
  expect_error(checkbarInput(), "please specify `id`")
})

test_that("has dependencies", {
  expect_dependencies(checkbarInput("ID"))
})
