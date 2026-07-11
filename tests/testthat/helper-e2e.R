# Shared helpers for the shinytest2 end-to-end tests.

skip_if_no_e2e <- function() {
  skip_on_cran()
  skip_if_not_installed("shinytest2")
  skip_if_not_installed("bslib")
}

# Fire a server-side observer defined in the app.
trigger <- function(app, id) {
  app$run_js(sprintf(
    "Shiny.setInputValue('%s', Date.now(), {priority: 'event'});",
    id
  ))
  app$wait_for_idle()
}

# Dispatch a native, bubbling event on the element matching `selector`.
dispatch <- function(app, selector, event, value = NULL) {
  app$run_js(sprintf(
    "(() => {
      const el = document.querySelector('%s');
      %s
      el.dispatchEvent(new Event('%s', { bubbles: true }));
    })();",
    selector,
    if (is.null(value)) "" else sprintf("el.value = '%s';", value),
    event
  ))
  app$wait_for_idle()
}

# Dispatch a native, bubbling keydown on the element matching `selector`,
# optionally setting its value first.
dispatch_key <- function(app, selector, key, value = NULL) {
  app$run_js(sprintf(
    "(() => {
      const el = document.querySelector('%s');
      %s
      el.dispatchEvent(new KeyboardEvent('keydown', { key: '%s', bubbles: true }));
    })();",
    selector,
    if (is.null(value)) "" else sprintf("el.value = '%s';", value),
    key
  ))
  app$wait_for_idle()
}
