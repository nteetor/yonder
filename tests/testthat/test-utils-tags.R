context("test-utils-tags")


test_that("is_tag", {
  expect_true(is_tag(div()))
  expect_false(is_tag(list()))
})

test_that("tagConcatAttributes", {
  expect_null(tagConcatAttributes(list(), c(hello = "world")))

  element <- tagConcatAttributes(div(multiple = NA), c(`data-hello` = "world"))

  expect_equal(element$attribs, list(multiple = NA, `data-hello` = "world"))
})

test_that("tagHasClass", {
  expect_false(tagHasClass(list()))
  expect_false(tagHasClass(div()))

  expect_true(tagHasClass(div(class = "hello"), "hello"))
  expect_true(tagHasClass(div(class = "hello"), c("hello", "world")))

  expect_true(tagHasClass(div(class = "world hello"), "hello"))
  expect_true(tagHasClass(div(class = "this that then"), "that"))

  expect_true(tagHasClass(div(class = "world hello"),  "he.+"))
  expect_true(tagHasClass(div(class = "world hello"),  c("wo..d", "he.+")))
})

test_that("tagRename", {
  expect_equal(tagRename(div(), "select")$name, "select")
  expect_equal(
    as.character(tagRename(div(), "span")),
    "<span></span>"
  )
})

test_that("tagIs", {
  expect_true(tagIs(div(), "div"))
  expect_false(tagIs(tags$span(), "div"))
})

test_that("tagAddClass", {
  expect_error(tagAddClass(list(), "hello"))
  expect_equal(tagAddClass(div(), NULL), div())

  expect_equal(
    tagAddClass(div(), "hello")$attribs$class,
    "hello"
  )
  expect_equal(
    tagAddClass(div(), c("hello", "world"))$attribs$class,
    "hello world"
  )
  expect_equal(
    tagAddClass(div(class = "hello"), c("hello", "world"))$attribs$class,
    "hello world"
  )
})

test_that("tagDropClass", {
  expect_error(tagDropClass(list(), "hello"))
  expect_equal(tagDropClass(div(), "hello"), div())

  expect_equal(
    tagDropClass(div(class = "hello world goodnight"), "world")$attribs$class,
    "hello goodnight"
  )
})
