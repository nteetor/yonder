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

# Set files on a real <input type="file"> the way a picker would.
# shinytest2's own `$upload_file()` resolves the selector from the Shiny
# input id, which for <bsides-file> is the custom element, not the input
# inside it — so address the input by selector through CDP directly.
upload_files <- function(app, selector, paths) {
  session <- app$get_chromote_session()
  document <- session$DOM$getDocument()
  node <- session$DOM$querySelector(
    nodeId = document$root$nodeId,
    selector = selector
  )

  session$DOM$setFileInputFiles(
    files = as.list(normalizePath(paths)),
    nodeId = node$nodeId
  )

  app$wait_for_idle()
}

# Throttle what the browser can push, so an upload stays measurably in
# flight instead of completing within one round trip of localhost. CDP
# network emulation applies to the POST body like any other request; the
# download direction is left alone so the WebSocket still answers
# promptly.
throttle_upload <- function(app, bytes_per_second) {
  session <- app$get_chromote_session()

  session$Network$enable()
  session$Network$emulateNetworkConditions(
    offline = FALSE,
    latency = 0,
    downloadThroughput = -1,
    uploadThroughput = bytes_per_second
  )
}

# Write `lines` to a file named `name` in a fresh temporary directory, so
# uploads carry a predictable name as well as predictable contents. The
# connection is binary: a text-mode writeLines() writes CRLF on Windows,
# and the tests assert exact byte sizes.
temp_upload <- function(name, lines, envir = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = envir)
  path <- file.path(dir, name)

  con <- file(path, open = "wb")
  writeLines(lines, con, sep = "\n")
  close(con)

  path
}

# A file of exactly `bytes` bytes, for uploads timed rather than read.
temp_upload_bytes <- function(name, bytes, envir = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = envir)
  path <- file.path(dir, name)

  con <- file(path, open = "wb")
  writeBin(raw(bytes), con)
  close(con)

  path
}
