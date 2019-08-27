expect_dependencies <- function(tag) {
  expect_equal(
    attr(tag, "html_dependencies"),
    dep_yonder()
  )
}
