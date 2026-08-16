test_that("tag is not bare list", {
  expect_false(is_bare_list(div()))
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

test_that("tag_style_add merges style attributes", {
  # htmltools would space-join a second style attribute; the helper joins
  # declaration lists with semicolons instead
  tag <- tag_style_add(div(style = "color: red"), `--x` = "1rem")
  expect_equal(tag$attribs$style, "color: red; --x:1rem;")

  # several existing style entries collapse into the merge
  tag <- div(style = "color: red", style = "margin: 0")
  tag <- tag_style_add(tag, `--x` = "1rem")
  expect_equal(tag$attribs$style, "color: red; margin: 0; --x:1rem;")

  # a trailing semicolon on the existing style does not double up
  tag <- tag_style_add(div(style = "color: red;"), `--x` = "1rem")
  expect_equal(tag$attribs$style, "color: red; --x:1rem;")

  # all-NULL declarations are a no-op
  tag <- div(style = "color: red")
  expect_identical(tag_style_add(tag, `--x` = NULL), tag)
})

test_that("check_css_length is a shape check only", {
  expect_null(check_css_length("12rem"))
  expect_null(check_css_length("clamp(6rem, 20vh, 16rem)"))
  expect_null(check_css_length(NULL, allow_null = TRUE))

  expect_error(check_css_length(""), "empty")
  expect_error(check_css_length("  "), "whitespace")
  expect_error(check_css_length("height: 12rem;"), "declaration")
  expect_error(check_css_length(NULL), "NULL")
})
