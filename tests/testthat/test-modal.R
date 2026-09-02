test_that("argument `id`", {
  expect_error(modal_dialog())

  expect_silent(modal_dialog("test"))
})

test_that("modal_button() is a trigger for its modal", {
  button <- modal_button("dlg", "Open")

  expect_equal(button$attribs[["data-bs-toggle"]], "modal")
  expect_equal(button$attribs[["data-bs-target"]], "#dlg")
})

test_that("modal_header() defaults to modal_close_icon()", {
  header <- as.character(modal_header(modal_title("T")))

  expect_match(header, "btn-close")
  expect_match(header, 'data-bs-dismiss="modal"')

  bare <- as.character(modal_header(modal_title("T"), close = NULL))

  expect_no_match(bare, "btn-close")
  expect_no_match(bare, "data-bs-dismiss")
})

test_that("modal_close_icon() passes `...` as attributes", {
  icon <- modal_close_icon(class = "extra", `data-test` = "1")

  expect_match(htmltools::tagGetAttribute(icon, "class"), "btn-close")
  expect_match(htmltools::tagGetAttribute(icon, "class"), "extra")
  expect_equal(htmltools::tagGetAttribute(icon, "data-test"), "1")
})

test_that("modal_footer() defaults to modal_close_button()", {
  footer <- as.character(modal_footer())

  expect_match(footer, 'data-bs-dismiss="modal"')
  expect_match(footer, ">Close</button>")

  custom <- as.character(
    modal_footer(close = modal_close_button(label = "Done", class = "extra"))
  )

  expect_match(custom, ">Done</button>")
  expect_match(custom, "extra")
})
