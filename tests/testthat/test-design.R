context("design utilities")

test_that("size argument valid values", {
  expect_error(font(div(), size = "BIG"))
})

test_that("background color uses correct base class", {
  button <- background(buttonInput("ID", "LABEL"), "danger")
  expect_false(tag_class_re(button, "bg-danger"))
  expect_true(tag_class_re(button, "btn-danger"))

  group <- background(buttonGroupInput("ID", c("1", "2")), "primary")
  expect_false(tag_class_re(group, "bg-primary"))
  expect_true(tag_class_re(group, "btn-group-primary"))
})
