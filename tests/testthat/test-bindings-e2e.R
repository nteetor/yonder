# End-to-end tests for the TypeScript input bindings: real browser
# (headless Chrome), real Shiny session, real websocket round trips.
# Shared helpers live in helper-e2e.R; multi-select has its own file
# (test-multi-select-e2e.R).

launch_bindings_app <- function() {
  shinytest2::AppDriver$new(
    test_path("apps", "bindings"),
    name = "bindings",
    variant = NULL,
    load_timeout = 30 * 1000
  )
}

test_that("click-driven bindings report values", {
  skip_if_no_e2e()

  app <- launch_bindings_app()
  withr::defer(app$stop())

  # button and link count clicks; value passes through the R input handler
  expect_null(app$get_value(input = "btn"))
  app$click(selector = "#btn")
  expect_equal(app$get_value(input = "btn"), 1L)

  app$click(selector = "#lnk")
  expect_equal(app$get_value(input = "lnk"), 1L)

  # checkbox
  expect_false(app$get_value(input = "chk"))
  app$click(selector = "#chk .form-check-input")
  expect_true(app$get_value(input = "chk"))

  # checkbox group: two clicks, both reported
  app$click(selector = "#chkgrp .form-check-input[value='A']")
  app$click(selector = "#chkgrp .form-check-input[value='C']")
  expect_setequal(app$get_value(input = "chkgrp"), c("A", "C"))

  # radio group
  app$click(selector = "#rad .form-check-input[value='R2']")
  expect_equal(app$get_value(input = "rad"), "R2")

  # list group: toggle two items on, one off
  app$click(selector = "#lst [data-bsides-value='Item 2']")
  expect_equal(app$get_value(input = "lst"), "Item 2")
  app$click(selector = "#lst [data-bsides-value='Item 3']")
  expect_setequal(app$get_value(input = "lst"), c("Item 2", "Item 3"))
  app$click(selector = "#lst [data-bsides-value='Item 2']")
  expect_equal(app$get_value(input = "lst"), "Item 3")

  # menu: click an item (no need to open the dropdown for a JS click)
  app$run_js("document.querySelector('#mnu .dropdown-item').click();")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "mnu"), "One")
})

test_that("change- and keystroke-driven bindings report values", {
  skip_if_no_e2e()

  app <- launch_bindings_app()
  withr::defer(app$stop())

  # text: input events are debounced, value arrives after the rate policy
  dispatch(app, "#txt", "input", value = "hello")
  Sys.sleep(0.4)
  app$wait_for_idle()
  expect_equal(app$get_value(input = "txt"), "hello")

  # text group: value joins the static prefix and the typed text
  dispatch(app, "#txtgrp input", "input", value = "42")
  Sys.sleep(0.4)
  app$wait_for_idle()
  expect_equal(app$get_value(input = "txtgrp"), "$42")

  # select
  dispatch(app, "#sel", "change", value = "S2")
  expect_equal(app$get_value(input = "sel"), "S2")

  # range
  dispatch(app, "#rng .form-range", "change", value = "60")
  expect_equal(app$get_value(input = "rng"), 60L)
})

test_that("forms hold back child inputs until submit", {
  skip_if_no_e2e()

  app <- launch_bindings_app()
  withr::defer(app$stop())

  dispatch(app, "#frmtext", "input", value = "held-back")
  Sys.sleep(0.4)
  app$wait_for_idle()

  # the form intercepted the child input: the server still has the initial
  # bind-time snapshot ("") and must not have seen the typed value
  expect_identical(app$get_value(input = "frmtext"), "")

  app$click(selector = "#frm .bsides-input-form-submit")
  expect_equal(app$get_value(input = "frmtext"), "held-back")
  expect_equal(app$get_value(input = "frm"), "go")

  # server-initiated submit re-fires the form
  dispatch(app, "#frmtext", "input", value = "second")
  Sys.sleep(0.4)
  trigger(app, "do_submit_form")
  expect_equal(app$get_value(input = "frmtext"), "second")
})

test_that("update_* functions reach the client and report back", {
  skip_if_no_e2e()

  app <- launch_bindings_app()
  withr::defer(app$stop())

  trigger(app, "do_update_button")
  expect_match(app$get_html("#btn"), "Updated")

  trigger(app, "do_update_link")
  expect_match(app$get_html("#lnk"), "NewLink")

  trigger(app, "do_update_checkbox")
  expect_true(app$get_value(input = "chk"))

  trigger(app, "do_update_checkbox_group")
  expect_equal(app$get_value(input = "chkgrp"), "B")

  trigger(app, "do_update_radio")
  expect_match(app$get_html("#rad"), "N1")
  expect_equal(app$get_value(input = "rad"), "N1")

  trigger(app, "do_update_range")
  expect_equal(app$get_value(input = "rng"), 30L)

  trigger(app, "do_update_select")
  expect_equal(app$get_value(input = "sel"), "S3")

  trigger(app, "do_update_text")
  expect_equal(app$get_value(input = "txt"), "from-server")

  trigger(app, "do_update_text_group")
  expect_equal(app$get_value(input = "txtgrp"), "$77")

  trigger(app, "do_update_list_group")
  expect_setequal(app$get_value(input = "lst"), c("Item 1", "Item 3"))

  trigger(app, "do_update_menu")
  expect_match(app$get_html("#mnu"), "Picked")
  expect_equal(app$get_value(input = "mnu"), "Two")
})

test_that("modal and toast report shown/hidden state", {
  skip_if_no_e2e()

  app <- launch_bindings_app()
  withr::defer(app$stop())

  expect_null(app$get_value(input = "mdl"))

  trigger(app, "do_show_modal")
  Sys.sleep(0.5)
  app$wait_for_idle()
  expect_equal(app$get_value(input = "mdl"), "shown")

  trigger(app, "do_hide_modal")
  Sys.sleep(0.5)
  app$wait_for_idle()
  expect_equal(app$get_value(input = "mdl"), "hidden")

  trigger(app, "do_show_toast")
  Sys.sleep(0.5)
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tst"), "shown")

  trigger(app, "do_hide_toast")
  Sys.sleep(0.5)
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tst"), "hidden")
})
