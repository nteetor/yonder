test_that("argument `id`", {
  expect_error(input_chip_group(), "`id`")

  expect_silent(input_chip_group("test", choices = c("A", "B")))
})

test_that("`choices` may be NULL, but then `select` must be too", {
  expect_silent(input_chip_group("test"))

  expect_error(input_chip_group("test", select = "a"), "`select`")
})

test_that("`choices` and `values` must be the same length", {
  expect_error(
    input_chip_group("test", choices = c("A", "B"), values = "a"),
    "same length"
  )

  expect_error(
    update_chip_group("test", choices = c("A", "B"), values = "a"),
    "same length"
  )

  expect_silent(
    input_chip_group("test", choices = c("A", "B"), values = c("a", "b"))
  )
})

test_that("`select` values must be found in `values`", {
  expect_error(
    input_chip_group("test", choices = c("A", "B"), select = "x"),
    "found in `values`"
  )

  # update validates select only when values travel in the same call
  expect_error(
    update_chip_group("test", choices = c("A", "B"), select = "x"),
    "found in `values`"
  )

  expect_silent(
    input_chip_group("test", choices = c("A", "B"), select = "A")
  )
})

test_that("`type` and `layout` are validated", {
  expect_error(
    input_chip_group("test", choices = "A", type = "plaid"),
    "type"
  )

  expect_error(
    input_chip_group("test", choices = "A", layout = "diagonal"),
    "layout"
  )

  expect_silent(
    input_chip_group(
      "test",
      choices = "A",
      type = "danger",
      layout = "horizontal"
    )
  )
})

test_that("choices and checked render as JSON attributes", {
  html <- format(
    input_chip_group(
      "test",
      choices = c("A", "B"),
      values = c("a", "b"),
      select = "a"
    )
  )

  expect_match(html, "choices=")
  expect_match(html, "checked=")
  expect_match(html, "label", fixed = TRUE)

  # the default (select = values) checks every chip
  html <- format(input_chip_group("test", choices = c("A", "B")))

  expect_match(html, "checked=")
  expect_match(html, "A", fixed = TRUE)
  expect_match(html, "B", fixed = TRUE)

  # explicit select = NULL renders no checked attribute (all unchecked)
  html <- format(input_chip_group("test", choices = c("A", "B"), select = NULL))

  expect_no_match(html, "checked=")
})
