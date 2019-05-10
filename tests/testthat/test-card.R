context("card component")

test_that("card with nav pills has .nav-header-pills", {
  this <- card(
    header = navInput(id = "ID", appearance = "pills")
  )

  expect_true(grepl("card-header-pills", as.character(this)))
})

test_that("card with nav tabs has .nav-header-tabs", {
  this <- card(
    header = navInput(id = "ID", appearance = "tabs")
  )

  expect_true(grepl("card-header-tabs", as.character(this)))
})

test_that("cannot pass strings to card (old behaviour)", {
  expect_error(card("hello", "world"))
})

test_that("card paragraphs are wrapped in .card-body", {
  this <- card(p("hello, world"))

  expect_true(grepl("card-body", as.character(this)))
})

test_that("card paragraphs are given .card-text", {
  this <- card(p("hello, world"))

  expect_true(grepl("card-text", as.character(this)))
})

test_that("card respects ... named values as HTML attributes", {
  this <- card(class = "bg-blue", `data-hello` = "world")

  expect_true(tag_class_re(this, "bg-blue"))
  expect_true(grepl('data-hello="world"', as.character(this), fixed = TRUE))
})

test_that("card linkInputs have .card-link, keep id", {
  this <- card(linkInput(id = "ID", label = "LABEL"))

  expect_true(grepl('id="ID"', as.character(this), fixed = TRUE))
  expect_true(grepl("card-link", as.character(this)))
})
