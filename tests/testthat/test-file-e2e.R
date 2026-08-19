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

  # The server sets the value itself at uploadEnd: name, size, type, and a
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
  expect_false(app$get_js("document.querySelector('#upl').hasAttribute('aria-busy')"))
})

test_that("a staged batch uploads on the button, or from the server", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  # Two gestures accumulate; staging alone delivers nothing.
  upload_files(app, "#stg .file-input", temp_upload("s1.csv", "1"))
  upload_files(app, "#stg .file-input", temp_upload("s2.csv", "2"))

  expect_equal(app$get_value(output = "stg_info"), "none")
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

  # A fresh set staged after delivery, started from the server this
  # time — file_upload_start() is the button's twin.
  upload_files(app, "#stg .file-input", temp_upload("s3.csv", "3"))
  expect_equal(app$get_value(output = "stg_info"), "s1.csv 2; s2.csv 2")

  trigger(app, "do_start")
  app$wait_for_idle()

  expect_equal(app$get_value(output = "stg_info"), "s3.csv 2")
})

test_that("several files upload as one batch", {
  skip_if_no_e2e()

  app <- launch_file_app()
  withr::defer(app$stop())

  paths <- c(temp_upload("one.csv", "1"), temp_upload("two.csv", "2"))
  upload_files(app, input_sel, paths)

  expect_equal(app$get_value(output = "info"), "one.csv 2 text/csv; two.csv 2 text/csv")
  expect_equal(app$get_value(output = "contents"), "1; 2")
  expect_equal(
    app$get_js("document.querySelectorAll('#upl .file-item').length"),
    2
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
  expect_true(app$get_js(paste0("document.querySelector('", input_sel, "').disabled")))

  trigger(app, "do_enable")
  expect_false(app$get_js(paste0("document.querySelector('", input_sel, "').disabled")))
})
