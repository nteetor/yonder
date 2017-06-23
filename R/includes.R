bootstrap <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      htmltools::suppressDependencies("bootstrap"),
      tags$script(src = "dull/tether/tether.min.js"),
      tags$link(
        rel = "stylesheet",
        href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css",
        integrity = "sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ",
        crossorigin = "anonymous"
      ),
      tags$script(
        src = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js",
        integrity = "sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn",
        crossorigin = "anonymous"
      ),
      tags$script(src = "dull/js/dull.min.js"),
      tags$link(rel = "stylesheet", href = "dull/css/dull.css")
    )
  )
}

`font-awesome` <- function() {
  htmltools::singleton(
    tags$head(
      tags$link(
        rel = "stylesheet",
        href = "dull/font-awesome/css/font-awesome.min.css"
      )
    )
  )
}
