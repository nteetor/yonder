context("select input")

test_that("id argument", {
  expect_missing_id_error(selectInput())
  expect_silent(selectInput("ID"))
})

test_that("choices argument", {
  expect_error(selectInput("ID", 1, 1:2))
})

test_that("selected argument", {
  expect_error(selectInput("ID", 1:3, selected = 1:2))
})

test_that("returns tag", {
  expect_is(selectInput("ID", letters[1:3]), "shiny.tag")
})

test_that("map_* helper", {
  items <- map_selectitems(1:3, 1:3, 1)

  expect_length(items, 3)
})

test_that("has dependencies", {
  expect_dependencies(selectInput("ID"))
})
