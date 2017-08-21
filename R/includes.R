bootstrap <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      htmltools::suppressDependencies("bootstrap"),
      tags$script(src = "dull/popper/popper.min.js"),
      tags$link(
        rel = "stylesheet",
        href = "dull/bootstrap/css/bootstrap.min.css"
      ),
      tags$script(src = "dull/bootstrap/js/bootstrap.min.js"),
      tags$script(src = "dull/dull/dull.min.js"),
      tags$link(rel = "stylesheet", href = "dull/dull/dull.min.css")
    )
  )
}

`font-awesome` <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      tags$link(
        rel = "stylesheet",
        href = "dull/font-awesome/css/font-awesome.min.css"
      )
    )
  )
}
