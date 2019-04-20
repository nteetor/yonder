context("general utilities")

test_that("tag is not strict list", {
  expect_false(is_strictly_list(div()))
})

test_that("str_re allows NULL", {
  expect_true(str_re(NULL, "hello"))
})

test_that("str_re matches full string", {
  expect_true(str_re("hello", "h.+o"))
  expect_false(str_re("hello", "hell"))
})

test_that("str_collate flat arguments", {
  expect_equal(str_collate("hello", "world"), "hello world")
  expect_equal(str_collate("here.", "there."), "here. there.")
})

test_that("str_collate nested arguments", {
  expect_equal(
    str_collate("hello", c("goodnight", "moon")),
    "hello goodnight moon"
  )
  expect_equal(
    str_collate(c("hello", "world"), c("goodnight", "moon")),
    "hello world goodnight moon"
  )
})

test_that("drop_nulls", {
  expect_equal(drop_nulls(list(NULL, 1, NULL)), list(1))
})
