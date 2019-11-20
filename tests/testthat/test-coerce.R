context("coerce utilties")

test_that("coerce_content", {
  expect_equal(coerce_content(NULL), NULL)
  expect_equal(coerce_content(character(0)), list())
  expect_equal(coerce_content(list()), list())
  expect_match(coerce_content(div()), "<div></div>", fixed = TRUE)
  expect_match(
    coerce_content(list(div("hello"), div("world"))),
    "<div>hello</div>\n<div>world</div>",
    fixed = TRUE
  )
  expect_match(coerce_content(c("hello", "world")), "hello\nworld")
  expect_match(coerce_content(I(c("hello", "world"))), "hello<br>\nworld")
})

test_that("coerce_selected", {
  expect_null(coerce_selected(NULL))
  expect_true(coerce_selected(TRUE))
  expect_equal(coerce_selected(1:3), list("1", "2", "3"))
})

test_that("coerce_enable", {
  expect_null(coerce_enable(NULL))
  expect_true(coerce_enable(TRUE))

  expect_equal(coerce_enable(c(23, 91)), list("23", "91"))
  expect_equal(coerce_enable(45), list("45"))
})

test_that("coerce_disable", {
  expect_null(coerce_disable(NULL))
  expect_true(coerce_disable(TRUE))

  expect_equal(coerce_disable(23), list("23"))
  expect_equal(coerce_disable(list(22, "foo")), list("22", "foo"))
})

test_that("coerce_valid", {
  expect_null(coerce_valid(NULL))
  expect_is(coerce_valid("All set"), c("html", "character"))
})

test_that("coerce_invalid", {
  expect_null(coerce_invalid(NULL))
  expect_is(coerce_invalid("Please enter"), c("html", "character"))
})
