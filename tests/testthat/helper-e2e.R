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

# Record when each upload POST is issued and when each `uploadEnd` is
# answered, so a test can assert the order of the two rather than the
# interval between them. Install before the upload starts.
#
# The app's own `makeRequest` is wrapped, not the prototype's: the
# uploader reads `Shiny.shinyapp` once in run() and calls through that
# instance, so an own property shadowing the prototype is what it sees.
# POSTs are recognised by url — every upload job's url carries `/upload/`
# — because they share XMLHttpRequest with nothing else the page does.
record_upload_timings <-
  function(app) {
    app$run_js(
      "(() => {
        window.__timings = { posts: [], ends: [] };

        const shinyapp = Shiny.shinyapp;
        const makeRequest = shinyapp.makeRequest.bind(shinyapp);

        shinyapp.makeRequest = function (method, args, ok, fail, blobs) {
          if (method !== 'uploadEnd') {
            return makeRequest(method, args, ok, fail, blobs);
          }

          const end = { issued: performance.now(), answered: null };

          window.__timings.ends.push(end);

          return makeRequest(
            method,
            args,
            (value) => { end.answered = performance.now(); ok(value); },
            (error) => { end.answered = performance.now(); fail(error); },
            blobs
          );
        };

        const open = XMLHttpRequest.prototype.open;
        const send = XMLHttpRequest.prototype.send;

        XMLHttpRequest.prototype.open = function (method, url, ...rest) {
          this.__url = url;
          return open.call(this, method, url, ...rest);
        };

        XMLHttpRequest.prototype.send = function (body) {
          if (String(this.__url).includes('/upload/')) {
            window.__timings.posts.push({ issued: performance.now() });
          }

          return send.call(this, body);
        };
      })();"
    )

    invisible(app)
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
