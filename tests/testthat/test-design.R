context("design utilities")

test_that("size argument valid values", {
  expect_error(font(div(), size = "BIG"))
})

test_that("background color uses correct base class", {
  button <- background(buttonInput("ID", "LABEL"), "red")
  expect_false(tag_class_re(button, "bg-red"))
  expect_true(tag_class_re(button, "btn-red"))

  group <- background(buttonGroupInput("ID", c("1", "2")), "blue")
  expect_false(tag_class_re(group, "bg-blue"))
  expect_false(tag_class_re(group, "btn-blue"))
  expect_true(tag_class_re(group$children[[1]][[1]], "btn-blue"))
  expect_true(tag_class_re(group$children[[1]][[2]], "btn-blue"))
})
