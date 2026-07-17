# End-to-end tests for input_chip_group() / <bsides-chip-group>:
# real browser, real Shiny session.

launch_chip_group_app <- function() {
  shinytest2::AppDriver$new(
    test_path("apps", "chip-group"),
    name = "chip-group",
    variant = NULL,
    load_timeout = 30 * 1000
  )
}

test_that("chip group toggles chips and reports the checked set", {
  skip_if_no_e2e()

  app <- launch_chip_group_app()
  withr::defer(app$stop())

  # select = NULL: all chips render unchecked, the value is NULL
  expect_null(app$get_value(input = "cg"))

  # no select: the constructor default checks every chip
  expect_setequal(app$get_value(input = "cgall"), c("one", "two"))

  # the elevation shadow marks chips as interactive (pure-CSS token;
  # guards against the custom property being dropped in a refactor)
  expect_false(
    app$get_js(
      "getComputedStyle(document.querySelector('#cg bsides-chip')).boxShadow"
    ) ==
      "none"
  )

  # clicking a chip toggles its checked state
  app$click(selector = "#cg bsides-chip:first-of-type")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "cg"), "r")

  app$click(selector = "#cg bsides-chip:nth-of-type(3)")
  app$wait_for_idle()
  expect_setequal(app$get_value(input = "cg"), c("r", "b"))

  app$click(selector = "#cg bsides-chip:first-of-type")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "cg"), "b")

  # initial select from the constructor
  expect_equal(app$get_value(input = "cg2"), "m")
})

test_that("update_chip_group() replaces selections and choices", {
  skip_if_no_e2e()

  app <- launch_chip_group_app()
  withr::defer(app$stop())

  # select replaces the checked set (no merging)
  app$click(selector = "#cg bsides-chip:nth-of-type(2)") # check Green
  app$wait_for_idle()
  expect_equal(app$get_value(input = "cg"), "g")
  trigger(app, "do_select")
  expect_setequal(app$get_value(input = "cg"), c("r", "b"))

  # an empty select clears the selection
  trigger(app, "do_select_clear")
  expect_null(app$get_value(input = "cg"))

  # replacing choices drops checked values whose chip no longer exists
  # (cg2 starts with "m" checked; Medium survives the replacement)
  trigger(app, "do_replace_choices")
  expect_equal(app$get_value(input = "cg2"), "m")
  expect_equal(
    app$get_js("document.querySelectorAll('#cg2 bsides-chip').length"),
    2
  )

  # disable stops toggling; enable restores it
  trigger(app, "do_disable")
  app$click(selector = "#cg bsides-chip:first-of-type")
  app$wait_for_idle()
  expect_null(app$get_value(input = "cg"))
  trigger(app, "do_enable")
  app$click(selector = "#cg bsides-chip:first-of-type")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "cg"), "r")
})
