# End-to-end tests for input_file() / <bsides-file>: real browser, real
# Shiny session, real uploads over HTTP.

launch_file_app <- function() {
  shinytest2::AppDriver$new(
    test_path("apps", "file"),
    name = "file",
    variant = NULL,
    load_timeout = 30 * 1000
  )
}

input_sel <- "#upl .file-input"

test_that("a picked file uploads and lands in input$<id>", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  expect_equal(app$get_value(output = "info"), "none")

  path <- temp_upload("small.csv", "a,b")
  upload_files(app, input_sel, path)

  # The completed batch delivers the value: name, size, type, and a
  # readable datapath.
  expect_equal(app$get_value(output = "info"), "small.csv 4 text/csv")
  expect_equal(app$get_value(output = "contents"), "a,b")

  # The row is listed and marked done, with the batch controls gone.
  expect_equal(
    app$get_js("document.querySelector('#upl .file-item-name').textContent"),
    "small.csv"
  )
  expect_true(
    app$get_js(
      "document.querySelector('#upl .file-item').classList.contains('done')"
    )
  )
  expect_true(app$get_js("document.querySelector('#upl .file-batch') === null"))
  expect_false(app$get_js(
    "document.querySelector('#upl').hasAttribute('aria-busy')"
  ))
})

test_that("a staged batch uploads on the button, or from the server", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  # Idle before anything is staged — the readers' totality defaults.
  expect_equal(app$get_value(output = "stg_state"), "idle 0 0")

  # Two gestures accumulate; staging alone delivers nothing.
  upload_files(app, "#stg .file-input", temp_upload("s1.csv", "1"))
  upload_files(app, "#stg .file-input", temp_upload("s2.csv", "2"))

  expect_equal(app$get_value(output = "stg_info"), "none")
  expect_equal(app$get_value(output = "stg_state"), "staged 2 0")
  expect_equal(
    app$get_js("document.querySelectorAll('#stg .file-item').length"),
    2
  )
  expect_false(
    app$get_js("document.querySelector('#stg .file-upload').disabled")
  )

  # The Upload button starts the batch; the server sets the value.
  app$click(selector = "#stg .file-upload")
  app$wait_for_idle()

  expect_equal(app$get_value(output = "stg_info"), "s1.csv 2; s2.csv 2")
  expect_equal(app$get_value(output = "stg_state"), "done 0 1")

  # A fresh set staged after delivery, started from the server this
  # time — file_upload_start() is the button's twin.
  upload_files(app, "#stg .file-input", temp_upload("s3.csv", "3"))
  expect_equal(app$get_value(output = "stg_info"), "s1.csv 2; s2.csv 2")

  trigger(app, "do_start")
  app$wait_for_idle()

  expect_equal(app$get_value(output = "stg_info"), "s3.csv 2")
})

test_that("a staged set inside input_form() uploads on submit", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  upload_files(app, "#frm_upl .file-input", temp_upload("f1.csv", "1"))
  upload_files(app, "#frm_upl .file-input", temp_upload("f2.csv", "2"))

  # Staged, not delivered — the form has not submitted.
  expect_equal(app$get_value(output = "frm_info"), "none")

  app$click(selector = "#frm .bsides-input-form-submit")
  app$wait_for_idle()

  # The submit value and the upload land together.
  expect_equal(
    app$get_value(output = "frm_info"),
    "send / f1.csv; f2.csv"
  )

  # And in that order: an observer keyed on the submit sees the files,
  # because the form withholds its own value until uploadEnd has run.
  # Without the wait this reads "NULL" on a first submit.
  expect_equal(app$get_value(output = "frm_observed"), "f1.csv; f2.csv")
})

test_that("several files upload as one batch", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  paths <- c(temp_upload("one.csv", "1"), temp_upload("two.csv", "2"))
  upload_files(app, input_sel, paths)

  expect_equal(
    app$get_value(output = "info"),
    "one.csv 2 text/csv; two.csv 2 text/csv"
  )
  expect_equal(app$get_value(output = "contents"), "1; 2")
  expect_equal(
    app$get_js("document.querySelectorAll('#upl .file-item').length"),
    2
  )
})

test_that("a queued file starts before any job in the batch closes", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  record_upload_timings(app)

  # One file more than the uploader runs at once, so the last one is
  # queued. Its POST is issued a microtask after the bytes that freed the
  # slot land, while the close of that file still owes a socket round
  # trip — so the queued POST cannot be the later of the two. A slot held
  # across its close inverts that: the queued POST could only follow an
  # answer. The assertion is the order, which holds at any link speed and
  # any file size; the interval is what varies by machine.
  digits <- as.character(1:5)

  # temp_upload() ties each temp dir to its caller's frame; from inside a
  # lambda that frame is gone before the upload starts.
  frame <- environment()
  paths <- vapply(
    digits,
    \(d) temp_upload(paste0("q", d, ".csv"), d, envir = frame),
    character(1)
  )

  upload_files(app, input_sel, unname(paths))

  expect_equal(
    app$get_value(output = "contents"),
    paste0(digits, collapse = "; ")
  )

  timings <- app$get_js(
    "({
      posts: window.__timings.posts.length,
      ends: window.__timings.ends.length,
      lastPost: Math.max(...window.__timings.posts.map((p) => p.issued)),
      firstAnswer: Math.min(...window.__timings.ends.map((e) => e.answered))
    })"
  )

  # Every file posted and every job closed, or the order below compares
  # something other than the whole batch.
  expect_equal(timings$posts, length(digits))
  expect_equal(timings$ends, length(digits))

  expect_lt(timings$lastPost, timings$firstAnswer)
})

test_that("a batch past the concurrency limit keeps declared order", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  # More files than the uploader runs at once, so the last few are queued
  # behind the pool and their jobs finish well after the first few. Each
  # file's content differs from its neighbours', so a row holding the
  # wrong datapath shows up as a mismatch rather than as a coincidence.
  digits <- as.character(1:6)

  # temp_upload() ties each temp dir to its caller's frame; from inside a
  # lambda that frame is gone before the upload starts.
  frame <- environment()
  paths <- vapply(
    digits,
    \(d) temp_upload(paste0("c", d, ".csv"), d, envir = frame),
    character(1)
  )

  upload_files(app, input_sel, unname(paths))

  expect_equal(
    app$get_value(output = "info"),
    paste0(paste0("c", digits, ".csv 2 text/csv"), collapse = "; ")
  )
  expect_equal(
    app$get_value(output = "contents"),
    paste0(digits, collapse = "; ")
  )
  # One upload job per file would otherwise name every file 0.csv; the
  # batch handler renames by position, so basename() still distinguishes
  # a same-extension batch.
  expect_equal(
    app$get_value(output = "paths"),
    paste0(paste0(seq_along(digits) - 1L, ".csv"), collapse = "; ")
  )
  expect_equal(
    app$get_js("document.querySelectorAll('#upl .file-item').length"),
    6
  )
})

test_that("the server's size limit surfaces inline", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  # Larger than the app's 100 byte serving limit but well under the limit
  # rendered into data-max-size, so the client lets it through and the
  # server rejects the batch at uploadInit.
  path <- temp_upload("big.csv", strrep("x", 500))
  upload_files(app, input_sel, path)

  expect_match(
    app$get_js("document.querySelector('#upl .file-errors').textContent"),
    "Maximum upload size exceeded"
  )
  expect_equal(app$get_value(output = "info"), "none")
  expect_true(
    app$get_js(
      "document.querySelector('#upl .file-item').classList.contains('error')"
    )
  )
})

test_that("client-side accept rejection costs no round trip", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  # Setting files through CDP bypasses the picker's own accept filtering,
  # the same way a drop would.
  path <- temp_upload("notes.txt", "hello")
  upload_files(app, input_sel, path)

  expect_equal(
    app$get_js("document.querySelector('#upl .file-error').textContent"),
    "notes.txt is not an accepted file type."
  )
  expect_equal(app$get_value(output = "info"), "none")
  expect_true(app$get_js("document.querySelector('#upl .file-item') === null"))
})

test_that("update_file() resets the list and toggles the input", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  upload_files(app, input_sel, temp_upload("small.csv", "a,b"))
  expect_equal(
    app$get_js("document.querySelectorAll('#upl .file-item').length"),
    1
  )

  trigger(app, "do_reset")

  # The list clears; the value the server already set stays put — the
  # protocol offers no way to unset it.
  expect_true(app$get_js("document.querySelector('#upl .file-list') === null"))
  expect_equal(app$get_value(output = "info"), "small.csv 4 text/csv")

  trigger(app, "do_disable")
  expect_true(app$get_js(paste0(
    "document.querySelector('",
    input_sel,
    "').disabled"
  )))

  trigger(app, "do_enable")
  expect_false(app$get_js(paste0(
    "document.querySelector('",
    input_sel,
    "').disabled"
  )))
})

test_that("cancelling a batch mid-flight delivers no value", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  # A window to cancel in, built rather than hoped for: the app lifts its
  # size limit, the browser's upload pipe is narrowed to 20 KB/s, and the
  # file is big enough that 200 KB takes ten seconds to push.
  trigger(app, "do_relax")
  throttle_upload(app, 20 * 1024)

  upload_files(
    app,
    "#stg .file-input",
    temp_upload_bytes("slow.csv", 200 * 1024)
  )
  app$run_js("document.querySelector('#stg .file-upload').click();")

  # Wait for the batch bar to move rather than for the batch to start:
  # the Cancel button is rendered the instant the flight opens, when no
  # byte has gone anywhere yet. A reported percentage is bytes on the
  # wire, and reads from the DOM, so no round trip can age it.
  percent <- "Number(document.querySelector(
    '#stg .file-batch-progress'
  ).getAttribute('aria-valuenow'))"

  app$wait_for_js(paste(percent, "> 0"), timeout = 15 * 1000)

  # Mid-transfer, not finished: the ten seconds this file needs at
  # 20 KB/s is the margin that keeps that true every run.
  expect_lt(app$get_js(percent), 100)

  app$run_js("document.querySelector('#stg .file-cancel').click();")
  app$wait_for_idle()

  # Nothing is delivered for an aborted batch, and manual mode lands back
  # on the staged set, ready to retry.
  expect_equal(app$get_value(output = "stg_info"), "none")
  expect_equal(app$get_value(output = "stg_state"), "staged 1 0")
  expect_true(app$get_js(
    "document.querySelector('#stg .file-cancel') === null"
  ))
})
