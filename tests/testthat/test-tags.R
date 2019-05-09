context("tag utilities")

test_that("is_tag", {
  expect_true(is_tag(div()))
  expect_false(is_tag(list()))
})

test_that("tag_attributes_add", {
  expect_error(tag_attributes_add(list(), c(hello = "world")))

  element <- tag_attributes_add(div(multiple = NA), c(`data-hello` = "world"))

  expect_equal(element$attribs, list(multiple = NA, `data-hello` = "world"))
})

test_that("tag_class_re", {
  expect_error(tag_class_re(list()))
  expect_false(tag_class_re(div()))

  expect_true(tag_class_re(div(class = "hello"), "hello"))
  expect_true(tag_class_re(div(class = "hello"), c("hello", "world")))

  expect_true(tag_class_re(div(class = "world hello"), "hello"))
  expect_true(tag_class_re(div(class = "this that then"), "that"))

  expect_true(tag_class_re(div(class = "world hello"),  "he.+"))
  expect_true(tag_class_re(div(class = "world hello"),  c("wo..d", "he.+")))
})

test_that("tag_class_re on tag with multiple attributes", {
  this <- tags$div(class = "hello", class = "world")
  expect_true(tag_class_re(this, "world"))

  that <- tags$div(class = "hello", class = "goodnight world")
  expect_true(tag_class_re(that, "goodnight"))
})

test_that("tag_name_is", {
  expect_true(tag_name_is(div(), "div"))
  expect_false(tag_name_is(tags$span(), "div"))
})

test_that("tag_class_add", {
  expect_error(tag_class_add(list(), "hello"))
  expect_equal(tag_class_add(div(), NULL), div())

  expect_equal(
    tag_class_add(div(), "hello")$attribs$class,
    "hello"
  )
  expect_equal(
    tag_class_add(div(), c("hello", "world"))$attribs$class,
    "hello world"
  )
  expect_equal(
    tag_class_add(div(class = "hello"), c("hello", "world"))$attribs$class,
    "hello world"
  )
})

test_that("tag_class_remove", {
  expect_error(tag_class_remove(list(), "hello"))
  expect_equal(tag_class_remove(div(), "hello"), div())

  expect_equal(
    tag_class_remove(div(class = "hello world goodnight"), "world")$attribs$class,
    "hello goodnight"
  )
})

test_that("tag_class_remove on tag with multiple class attributes", {
  this <- tag_class_remove(div(class = "one", class = "two three"), "two")

  expect_true(grepl('class="one three"', as.character(this), fixed = TRUE))
})
