context("test-utils")

test_that("tag is not strict list", {
  expect_false(is_strictly_list(div()))
})

test_that("re allows NULL", {
  expect_true(re(NULL, "hello"))
})

test_that("re matches full string", {
  expect_true(re("hello", "h.+o"))
  expect_false(re("hello", "hell"))
})

test_that("collate flat arguments", {
  expect_equal(collate("hello", "world"), "hello world")
  expect_equal(collate("here.", "there."), "here. there.")
})

test_that("collate nested arguments", {
  expect_equal(
    collate("hello", c("goodnight", "moon")),
    "hello goodnight moon"
  )
  expect_equal(
    collate(c("hello", "world"), c("goodnight", "moon")),
    "hello world goodnight moon"
  )
})

test_that("ensureBreakpoints handles NULL", {
  expect_is(ensureBreakpoints(NULL, c("hello")), "list")
  expect_length(ensureBreakpoints(NULL, c("hello")), 0)
})

test_that("ensureBreakpoints returns list", {
  expect_is(ensureBreakpoints("hello", c("hello", "world")), "list")
})

test_that("ensureBreakpoints checks breakpoints", {
  expect_silent(
    ensureBreakpoints(c(sm = "hello", xl = "world"), c("hello", "world"))
  )
  expect_error(
    ensureBreakpoints(c(sm = "hello", xx = "world"), c("hello", "world"))
  )
})

test_that("ensureBreakpoints normalizes names", {
  expect_named(ensureBreakpoints("hello", "hello"), "default")
})

test_that("ensureBreakpoints transform values", {
  values <- ensureBreakpoints("hello", "world", function(x) "world")
  expect_equal("world", values[[1]])
})

test_that("createResponsiveClasses returns proper classes", {
  hello <- ensureBreakpoints(c(xs = "hello", sm = "world"), c("hello", "world"))

  expect_equal(
    createResponsiveClasses(hello, "test"),
    c("test-hello", "test-sm-world")
  )
})
