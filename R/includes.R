bootstrap <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      htmltools::suppressDependencies("bootstrap"),
      tags$script(src = "dull/tether/tether.min.js"),
      tags$link(
        rel = "stylesheet",
        href = "dull/bootstrap/bootstrap.min.css"
      ),
      tags$script(src = "dull/bootstrap/bootstrap.min.js"),
      tags$script(src = "dull/js/dull.min.js"),
      tags$link(rel = "stylesheet", href = "dull/css/dull.min.css")
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
