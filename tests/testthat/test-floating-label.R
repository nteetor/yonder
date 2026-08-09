test_that("argument `text`", {
  expect_error(floating_label(), "`text`")

  expect_error(floating_label(NULL), "`text` must be a single string")

  expect_error(floating_label(""), "`text` must be a single string")
})

test_that("floating_label() returns a classed string", {
  label <- floating_label("Name")

  expect_s3_class(label, "bsides_floating_label")
  expect_equal(as.character(label), "Name")
})

test_that("standard label renders ahead of the input", {
  html <- format(input_text(id = "name", label = "Name"))

  expect_match(html, "<label class=\"form-label\" for=\"name\">Name</label>")
  expect_true(
    regexpr("<label", html, fixed = TRUE) <
      regexpr("<input", html, fixed = TRUE)
  )
})

test_that("floating label renders form-floating markup", {
  html <- format(input_text(id = "name", label = floating_label("Name")))

  expect_match(html, "form-floating")
  expect_match(html, "<label for=\"name\">Name</label>")

  # input first, label after
  expect_true(
    regexpr("<input", html, fixed = TRUE) <
      regexpr("<label", html, fixed = TRUE)
  )
})

test_that("floating label injects a blank placeholder", {
  html <- format(input_text(id = "name", label = floating_label("Name")))

  expect_match(html, "placeholder=\" \"", fixed = TRUE)
})

test_that("floating label keeps a caller placeholder", {
  html <-
    format(input_text(
      id = "name",
      label = floating_label("Name"),
      placeholder = "Jane Doe"
    ))

  expect_match(html, "placeholder=\"Jane Doe\"", fixed = TRUE)
  expect_no_match(html, "placeholder=\" \"", fixed = TRUE)
})

test_that("floating label carries extra attributes", {
  html <-
    format(input_text(
      id = "name",
      label = floating_label("Name", class = "text-muted")
    ))

  expect_match(html, "<label for=\"name\" class=\"text-muted\">Name</label>")
})

test_that("floating select does not gain a placeholder", {
  html <-
    format(input_select(
      id = "pick",
      choices = c("A", "B"),
      label = floating_label("Pick")
    ))

  expect_match(html, "form-floating")
  expect_no_match(html, "placeholder", fixed = TRUE)

  # select first, label after
  expect_true(
    regexpr("<select", html, fixed = TRUE) <
      regexpr("<label for=\"pick\">", html, fixed = TRUE)
  )
})

test_that("floating label in a text group wraps the control, not the group", {
  html <-
    format(input_text_group(
      id = "user",
      left = "@",
      label = floating_label("Username")
    ))

  # .form-floating nested inside .input-group
  expect_true(
    regexpr("input-group", html, fixed = TRUE) <
      regexpr("form-floating", html, fixed = TRUE)
  )
})

test_that("standard label in a text group renders ahead of the group", {
  html <-
    format(input_text_group(
      id = "user",
      left = "@",
      label = "Username"
    ))

  expect_true(
    regexpr("<label", html, fixed = TRUE) <
      regexpr("input-group", html, fixed = TRUE)
  )
})

test_that("group inputs render a legend-style label", {
  html <-
    format(input_checkbox_group(
      id = "opts",
      choices = c("A", "B"),
      label = "Options"
    ))

  expect_match(html, "<fieldset>")
  expect_match(html, "<legend class=\"form-label fs-6\">Options</legend>")
})

test_that("non-floatable inputs reject floating_label()", {
  expect_error(
    input_checkbox(id = "x", choice = "X", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )

  expect_error(
    input_checkbox_group(id = "x", choices = "X", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )

  expect_error(
    input_radio_group(id = "x", choices = "X", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )

  expect_error(
    input_range(id = "x", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )

  expect_error(
    input_chip_group(id = "x", choices = "X", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )

  expect_error(
    input_list_group(id = "x", choices = "X", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )

  expect_error(
    input_multi_select(id = "x", choices = "X", label = floating_label("X")),
    "must not be a `floating_label\\(\\)`"
  )
})

test_that('wrap_label() requires `for_id` for the "label" wrapper', {
  expect_error(
    wrap_label(tags$input(), "Name", wrapper = "label"),
    "`for_id` must not be `NULL`"
  )

  expect_silent(
    wrap_label(tags$input(), "Name", wrapper = "fieldset")
  )
})

test_that("a NULL label leaves the input unwrapped", {
  html <- format(input_text(id = "name"))

  expect_no_match(html, "<label", fixed = TRUE)
  expect_no_match(html, "<div", fixed = TRUE)
})

test_that("inputs render without a label", {
  expect_silent(format(input_text(id = "x")))
  expect_silent(format(input_numeric(id = "x")))
  expect_silent(format(input_select(id = "x", choices = "A")))
  expect_silent(format(input_text_group(id = "x", left = "@")))
  expect_silent(format(input_range(id = "x")))
  expect_silent(format(input_checkbox(id = "x", choice = "A")))
  expect_silent(format(input_checkbox_group(id = "x", choices = "A")))
  expect_silent(format(input_radio_group(id = "x", choices = "A")))
  expect_silent(format(input_chip_group(id = "x", choices = "A")))
  expect_silent(format(input_list_group(id = "x", choices = "A")))
  expect_silent(format(input_multi_select(id = "x", choices = "A")))
})

test_that("an unlabelled input carries no label markup", {
  for (html in list(
    format(input_range(id = "x")),
    format(input_text_group(id = "x", left = "@"))
  )) {
    expect_no_match(html, "<label", fixed = TRUE)
    expect_no_match(html, "<fieldset", fixed = TRUE)
  }
})

test_that("argument `choice_placement`", {
  html <-
    format(input_checkbox(
      id = "x",
      choice = "X",
      choice_placement = "before"
    ))

  expect_match(html, "form-check-reverse")

  html <-
    format(input_checkbox_group(
      id = "x",
      choices = "X",
      choice_placement = "before"
    ))

  expect_match(html, "form-check-reverse")

  html <-
    format(input_radio_group(
      id = "x",
      choices = "X",
      choice_placement = "before"
    ))

  expect_match(html, "form-check-reverse")
})
