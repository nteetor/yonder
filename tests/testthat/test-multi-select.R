test_that("argument `id`", {
  expect_error(input_multi_select(), "`id`")

  expect_silent(input_multi_select("test", choices = c("A", "B")))
})

test_that("`choices` may be NULL", {
  # empty edit = "choices" input: populated later via update
  expect_silent(input_multi_select("test"))

  # but then select has nothing to resolve against
  expect_error(input_multi_select("test", select = "a"), "`select`")

  # free mode seeds arbitrary chips
  expect_silent(input_multi_select("test", edit = "free", select = "a"))
})

test_that("`choices` and `values` must be the same length", {
  expect_error(
    input_multi_select("test", choices = c("A", "B"), values = "a"),
    "same length"
  )

  expect_error(
    update_multi_select("test", choices = c("A", "B"), values = "a"),
    "same length"
  )

  expect_silent(
    input_multi_select("test", choices = c("A", "B"), values = c("a", "b"))
  )
})

test_that("`select` is bounded by `values` at edit = \"choices\"", {
  expect_error(
    input_multi_select("test", choices = c("A", "B"), select = "x"),
    "found in `values`"
  )

  expect_silent(
    input_multi_select("test", choices = c("A", "B"), select = "A")
  )

  # free mode is unbounded, even with choices present
  expect_silent(
    input_multi_select("test", choices = c("A", "B"), select = "x", edit = "free")
  )

  # update validates select only when values travel in the same call
  expect_error(
    update_multi_select("test", choices = c("A", "B"), select = "x"),
    "found in `values`"
  )
})

test_that("`edit`, `type`, and `layout` are validated", {
  expect_error(input_multi_select("test", edit = "none"), "edit")
  expect_error(
    input_multi_select("test", choices = "A", type = "plaid"),
    "type"
  )
  expect_error(
    input_multi_select("test", choices = "A", layout = "diagonal"),
    "layout"
  )

  expect_silent(
    input_multi_select("test", choices = "A", type = "info", layout = "horizontal")
  )
})

test_that("choices and chips render as JSON attributes", {
  html <- format(
    input_multi_select(
      "test",
      choices = c("A", "B"),
      values = c("a", "b"),
      select = "a"
    )
  )

  expect_match(html, "choices=")
  expect_match(html, "chips=")

  # select = NULL renders no chips attribute (empty input)
  html <- format(input_multi_select("test", choices = c("A", "B")))

  expect_no_match(html, "chips=")
})
