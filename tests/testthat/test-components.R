context("components")

test_that("display headings", {
  expect_true(grepl("hello", d1("hello")))
  expect_true(grepl("display-1", d1("hello")))
  expect_is(d1(), "shiny.tag")

  expect_is(d2(), "shiny.tag")
  expect_is(d3(), "shiny.tag")
  expect_is(d4(), "shiny.tag")

  expect_dependencies(d1())
})

test_that("jumbotron", {
  expect_true(grepl("hello", jumbotron("hello")))
  expect_false(grepl("<hr>", jumbotron("hello")))
  expect_true(grepl("<hr ", jumbotron(title = "HELLO", "WORLD")))

  expect_dependencies(jumbotron())
})

test_that("img", {
  expect_is(img("how/now"), "shiny.tag")

  expect_dependencies(img("path"))
})

test_that("figure", {
  expect_error(figure(), "please specify `image`")
  expect_is(figure(img("/path/to/file")), "shiny.tag")

  expect_dependencies(figure(img("path")))
})

test_that("blockquote", {
  expect_true(grepl("blockquote-footer", blockquote(source = "Me, Myself")))
  expect_is(blockquote(), "shiny.tag")

  expect_dependencies(blockquote())
})

test_that("pre", {
  expect_is(pre(), "shiny.tag")
  expect_dependencies(pre())
})

test_that("fieldset", {
  expect_true(grepl(">hello<", fieldset("hello")))
  expect_is(fieldset(), "shiny.tag")
  expect_is(fieldset("hello"), "shiny.tag")
  expect_is(fieldset(legend = "Form"), "shiny.tag")
  expect_error(fieldset(legend = 3030), "`legend` must be")

  expect_dependencies(fieldset())
})
