test_that("alert() defaults to alert_close_icon()", {
  html <- as.character(alert("Notice"))

  expect_match(html, "btn-close")
  expect_match(html, 'data-bs-dismiss="alert"')
})

test_that("alert_close_icon() passes `...` as attributes", {
  icon <- alert_close_icon(class = "extra", `data-test` = "1")

  expect_match(htmltools::tagGetAttribute(icon, "class"), "btn-close")
  expect_match(htmltools::tagGetAttribute(icon, "class"), "extra")
  expect_equal(htmltools::tagGetAttribute(icon, "data-test"), "1")
})
