context("modal")

test_that("id argument", {
  expect_missing_id_error(modal())

  expect_silent(modal("ID"))
})

test_that("size argument", {
  expect_error(modal("ID", size = "BIG"))
  expect_match(as.character(modal("ID", size = "sm")), "modal-sm", fixed = TRUE)
  expect_match(as.character(modal("ID", size = "lg")), "modal-lg", fixed = TRUE)
})

test_that("title argument", {
  expect_false(grepl("modal-title", modal("ID", header = "TITLE")))
  expect_true(grepl("modal-title", modal("ID", header = h5("TITLE"))))
})

test_that("has dependencies", {
  expect_dependencies(modal("ID"))
})
