context("design utilities")

test_that("font() `size` is deprecated", {
  rlang::with_options(lifecycle_verbosity = "warning", {
    expect_warning(font(div(), size = "lg"), "deprecated")
  })
})

test_that("background color uses correct base class", {
  button <- buttonInput(id = "ID", label = "LABEL") %>%
    background("danger")
  expect_false(tag_class_re(button, "bg-danger"))
  expect_true(tag_class_re(button, "btn-danger"))

  group <- buttonGroupInput(id = "ID", choices = c("1", "2")) %>%
    background("primary")
  expect_false(tag_class_re(group, "bg-primary"))
  expect_true(tag_class_re(group, "btn-group-primary"))
})
