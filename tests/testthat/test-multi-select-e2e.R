# End-to-end tests for input_multi_select() / <bsides-multi-select>:
# real browser, real Shiny session.

launch_multi_select_app <- function() {
  shinytest2::AppDriver$new(
    test_path("apps", "multi-select"),
    name = "multi-select",
    variant = NULL,
    load_timeout = 30 * 1000
  )
}

test_that("multi select adds and removes chips through the dropdown", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  input_sel <- "#ms .multi-select-input"
  menu_js <- "document.querySelector('#ms .dropdown-menu')"
  items_js <- paste0(
    "[...document.querySelectorAll('#ms .dropdown-item')]",
    ".map((n) => n.textContent.trim())"
  )

  # initial chips from the constructor
  expect_equal(app$get_value(input = "ms"), "r")

  # the dropdown lists ALL choices, with a checkmark beside members
  dispatch_key(app, input_sel, "ArrowDown")
  expect_true(app$get_js(paste0(menu_js, ".classList.contains('show')")))
  expect_equal(unlist(app$get_js(items_js)), c("Red", "Green", "Blue"))
  expect_equal(
    app$get_js(
      "document.querySelectorAll('#ms .dropdown-item .option-check').length"
    ),
    1
  )

  # ArrowDown activates the first option (Red, a member); Enter toggles it
  # off — the server sees the removal
  dispatch_key(app, input_sel, "Enter")
  expect_null(app$get_value(input = "ms"))

  # clicking an option adds it back
  app$click(selector = "#ms .dropdown-menu li:nth-of-type(2) .dropdown-item")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "ms"), "g")

  # typing filters the options by label
  dispatch(app, input_sel, "input", value = "blu")
  expect_equal(unlist(app$get_js(items_js)), "Blue")

  # free text is never added at edit = "choices"
  dispatch(app, input_sel, "input", value = "Purple")
  dispatch_key(app, input_sel, "Enter")
  expect_equal(app$get_value(input = "ms"), "g")
  dispatch_key(app, input_sel, "Escape")
  dispatch_key(app, input_sel, "Escape")

  # the chip close button removes; the value reported is post-removal
  app$click(selector = "#ms bsides-chip .btn-close")
  app$wait_for_idle()
  expect_null(app$get_value(input = "ms"))
})

test_that("update_multi_select() reaches the client and reports back", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  input_sel <- "#ms .multi-select-input"
  input_js <- sprintf("document.querySelector('%s')", input_sel)

  # select replaces the chip set and round-trips to the server
  trigger(app, "do_update_select")
  expect_setequal(app$get_value(input = "ms"), c("g", "b"))

  # replacing choices prunes members no longer offered ('g' drops) and
  # relabels the survivors
  trigger(app, "do_update_choices")
  expect_equal(app$get_value(input = "ms"), "b")

  # the placeholder is gated: with a chip present it stays hidden…
  trigger(app, "do_update_placeholder")
  expect_null(app$get_js(paste0(input_js, ".getAttribute('placeholder')")))

  # max = 2 with one chip: adding a second disables the input
  trigger(app, "do_update_max")
  dispatch_key(app, input_sel, "ArrowDown")
  dispatch_key(app, input_sel, "Enter")
  expect_length(app$get_value(input = "ms"), 2)
  expect_true(app$get_js(paste0(input_js, ".disabled")))

  # removing a chip drops below max and re-enables
  app$click(selector = "#ms bsides-chip:first-of-type .btn-close")
  app$wait_for_idle()
  expect_length(app$get_value(input = "ms"), 1)
  expect_false(app$get_js(paste0(input_js, ".disabled")))

  # disable / enable round trip
  trigger(app, "do_disable")
  expect_true(app$get_js(paste0(input_js, ".disabled")))
  trigger(app, "do_enable")
  expect_false(app$get_js(paste0(input_js, ".disabled")))

  # …and shows once the last chip is removed
  app$click(selector = "#ms bsides-chip .btn-close")
  app$wait_for_idle()
  expect_null(app$get_value(input = "ms"))
  expect_equal(app$get_js(paste0(input_js, ".placeholder")), "Pick one")
})

test_that("chips render inside the bordered field", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  field_js <- "document.querySelector('#ms .multi-select-field')"
  content_js <- "document.querySelector('#ms .multi-select-field-content')"

  # chips and the text input share the field's content box
  expect_true(app$get_js(sprintf(
    "%s.contains(document.querySelector('#ms bsides-chip'))",
    content_js
  )))
  expect_true(app$get_js(sprintf(
    "%s.contains(document.querySelector('#ms .multi-select-input'))",
    content_js
  )))

  # the chips wrapper carries semantics only (role=group over display:
  # contents); the chips sit in the shared flex flow
  expect_equal(
    app$get_js(
      "getComputedStyle(document.querySelector('#ms .multi-select-chips')).display"
    ),
    "contents"
  )

  # the field is the bordered box; unfocused it carries no ring
  expect_equal(
    app$get_js(sprintf("getComputedStyle(%s).borderTopWidth", field_js)),
    "1px"
  )
  expect_equal(
    app$get_js(sprintf("getComputedStyle(%s).boxShadow", field_js)),
    "none"
  )

  # mousedown anywhere on the field focuses the input and opens the menu
  app$run_js(sprintf(
    "%s.dispatchEvent(new MouseEvent('mousedown', { bubbles: true }))",
    field_js
  ))
  app$wait_for_idle()
  expect_true(app$get_js(
    "document.querySelector('#ms .dropdown-menu').classList.contains('show')"
  ))
  expect_true(app$get_js(
    "document.activeElement === document.querySelector('#ms .multi-select-input')"
  ))

  # the focused field carries the ring (:focus-within)
  expect_false(identical(
    app$get_js(sprintf("getComputedStyle(%s).boxShadow", field_js)),
    "none"
  ))

  # the caret is decorative and sits outside the scrollable content
  expect_equal(
    app$get_js(
      "document.querySelector('#ms .multi-select-caret').getAttribute('aria-hidden')"
    ),
    "true"
  )
  expect_equal(
    app$get_js(
      "getComputedStyle(document.querySelector('#ms .multi-select-caret')).pointerEvents"
    ),
    "none"
  )
  expect_true(app$get_js(
    "document.querySelector('#ms .multi-select-caret').parentElement ===
       document.querySelector('#ms .multi-select-field')"
  ))

  # horizontal layout: one row that scrolls instead of wrapping, with the
  # scrollbar hidden (the expanded system bar would overlay the chips) and
  # the promoted vertical axis closed off
  expect_equal(
    app$get_js(
      "getComputedStyle(document.querySelector('#mshoriz .multi-select-field-content')).flexWrap"
    ),
    "nowrap"
  )
  expect_equal(
    app$get_js(
      "getComputedStyle(document.querySelector('#mshoriz .multi-select-field-content')).overflowX"
    ),
    "auto"
  )
  expect_equal(
    app$get_js(
      "getComputedStyle(document.querySelector('#mshoriz .multi-select-field-content')).overflowY"
    ),
    "hidden"
  )
  expect_equal(
    app$get_js(
      "getComputedStyle(document.querySelector('#mshoriz .multi-select-field-content')).scrollbarWidth"
    ),
    "none"
  )
})

test_that("the dropdown escapes clipping containers via the top layer", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  input_sel <- "#msclip .multi-select-input"
  menu_js <- "document.querySelector('#msclip .dropdown-menu')"

  # the menu is a manual popover (the browser supports the Popover API)
  expect_equal(
    app$get_js(paste0(menu_js, ".getAttribute('popover')")),
    "manual"
  )

  dispatch_key(app, input_sel, "ArrowDown")
  expect_true(app$get_js(paste0(menu_js, ".matches(':popover-open')")))

  # the regression: the open menu extends below the short card's
  # clipping card-body yet stays within the viewport
  expect_true(app$get_js(sprintf(
    "(() => {
      const menu = %s.getBoundingClientRect();
      const body = document.querySelector('#msclip')
        .closest('.card-body').getBoundingClientRect();
      return menu.height > 0 &&
        menu.bottom > body.bottom &&
        menu.bottom <= window.innerHeight;
    })()",
    menu_js
  )))

  # positioned against the field: left and width track the field's rect
  expect_true(app$get_js(sprintf(
    "(() => {
      const menu = %s.getBoundingClientRect();
      const field = document.querySelector('#msclip .multi-select-field')
        .getBoundingClientRect();
      return Math.abs(menu.left - field.left) < 1 &&
        Math.abs(menu.width - field.width) < 1;
    })()",
    menu_js
  )))

  # scrolling a container between the field and the document repositions
  # the menu with its anchor
  top_before <- app$get_js(paste0(menu_js, ".getBoundingClientRect().top"))
  app$run_js(
    "document.querySelector('#msclip').closest('.card-body').scrollTop = 30;"
  )
  app$wait_for_idle()
  top_after <- app$get_js(paste0(menu_js, ".getBoundingClientRect().top"))
  expect_lt(top_after, top_before)

  # existing close behaviors also dismiss the popover
  dispatch_key(app, input_sel, "Escape")
  expect_false(app$get_js(paste0(menu_js, ".matches(':popover-open')")))
  expect_false(app$get_js(paste0(menu_js, ".classList.contains('show')")))
})

test_that("arrow navigation keeps the active option in view", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  input_sel <- "#msclip .multi-select-input"
  menu_js <- "document.querySelector('#msclip .dropdown-menu')"

  # ten options against the capped max-height: the menu overflows, and
  # the first active option needs no scrolling
  dispatch_key(app, input_sel, "ArrowDown")
  expect_true(app$get_js(sprintf(
    "%s.scrollHeight > %s.clientHeight",
    menu_js,
    menu_js
  )))
  expect_equal(app$get_js(paste0(menu_js, ".scrollTop")), 0)

  # ArrowUp wraps to the last option; the menu scrolls it fully into view
  dispatch_key(app, input_sel, "ArrowUp")
  expect_true(app$get_js(sprintf(
    "(() => {
      const menu = %s;
      const option = menu.querySelector('.dropdown-item.active');
      const top = option.offsetTop;
      return menu.scrollTop > 0 &&
        top >= menu.scrollTop &&
        top + option.offsetHeight <= menu.scrollTop + menu.clientHeight;
    })()",
    menu_js
  )))

  # ArrowDown wraps back to the first option; the menu scrolls back up
  dispatch_key(app, input_sel, "ArrowDown")
  expect_equal(app$get_js(paste0(menu_js, ".scrollTop")), 0)
})

test_that("free multi select creates chips from typed text", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  input_sel <- "#msfree .multi-select-input"

  # the input handler maps an empty selection to NULL
  expect_null(app$get_value(input = "msfree"))

  # no dropdown in pure tag entry
  expect_equal(
    app$get_js("document.querySelectorAll('#msfree .dropdown-menu').length"),
    0
  )

  dispatch_key(app, input_sel, "Enter", value = "Tag1")
  expect_equal(app$get_value(input = "msfree"), "Tag1")

  # duplicates are rejected and the typed text stays visible
  dispatch_key(app, input_sel, "Enter", value = "Tag1")
  expect_equal(app$get_value(input = "msfree"), "Tag1")
  expect_equal(
    app$get_js(sprintf("document.querySelector('%s').value", input_sel)),
    "Tag1"
  )

  dispatch_key(app, input_sel, "Enter", value = "Tag2")
  expect_setequal(app$get_value(input = "msfree"), c("Tag1", "Tag2"))

  # Backspace in an empty input removes the last chip
  dispatch_key(app, input_sel, "Backspace", value = "")
  expect_equal(app$get_value(input = "msfree"), "Tag1")
})
