context("responsive class utilties")

test_that("resp_contstruct handles NULL", {
  expect_is(resp_construct(NULL, c("hello")), "list")
  expect_length(resp_construct(NULL, c("hello")), 0)
})

test_that("resp_construct returns list", {
  expect_is(resp_construct("hello", c("hello", "world")), "list")
})

test_that("resp_construct checks breakpoints", {
  expect_silent(
    resp_construct(c(sm = "hello", xl = "world"), c("hello", "world"))
  )
  expect_error(
    resp_construct(c(sm = "hello", x2 = "world"), c("hello", "world"))
  )
})

test_that("resp_construct normalizes names", {
  expect_named(resp_construct("hello", "hello"), "default")
})

test_that("resp_classes returns proper classes", {
  temp <- resp_construct(c(xs = "hello", sm = "world"), c("hello", "world"))

  expect_equal(
    resp_classes(temp, "test"),
    c("test-hello", "test-sm-world")
  )
})
