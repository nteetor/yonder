context("checkbar input")

test_that("id argument", {
  expect_missing_id_error(checkbarInput())
})

test_that("has dependencies", {
  expect_dependencies(checkbarInput("ID"))
})
