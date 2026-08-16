test_that("dependency_get() describes the bsides bundle", {
  dep <- dependency_get()

  expect_s3_class(dep, "html_dependency")
  expect_equal(dep$name, "yonder")
  expect_equal(dep$stylesheet, "css/bsides.min.css")
  expect_equal(dep$script, "js/bsides.js")
})

test_that("dependency_append() attaches the bundle as a child", {
  tag <- dependency_append(div())

  expect_equal(tag$children[[1]], dependency_get())
})
