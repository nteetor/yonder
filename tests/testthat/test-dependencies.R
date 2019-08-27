context("dependencies")

test_that("dependency expectation", {
  my_div <- htmltools::attachDependencies(div(), dep_yonder())

  expect_silent(
    expect_dependencies(my_div)
  )

  expect_error(
    expect_dependencies(div())
  )
})
