context("actions")

test_that("normalize_actions", {
  actions <- list(
    showTarget("home"),
    showTarget("about")
  )

  values <- list("home", "info", "about")

  norm <- normalize_actions(actions, values)

  expect_named(norm, names(values))

  expect_is(norm[[1]], "list")
  expect_is(norm[[1]][[1]], "input_action")

  expect_null(norm[[2]])
  expect_is(norm[[3]], "list")
})
