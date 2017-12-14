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
      tags$script(
        defer = NA,
        src = "dull/font-awesome/js/fontawesome-all.js"
        )
    )
  )
}

# d3 <- function() {
#   shiny::addResourcePath("dull", system.file("www", package = "dull"))
#
#   htmltools::singleton(
#     tags$head(
#       tags$script(src = "dull/d3/d3.min.js")
#     )
#   )
# }

chartist <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      tags$link(rel = "stylesheet", href = "dull/chartist/chartist.min.css"),
      tags$script(src = "dull/chartist/chartist.min.js")
    )
  )
}

`ion-range-slider` <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      tags$link(rel = "stylesheet", href = "dull/ion-range-slider/css/ion-range-slider.css"),
      tags$link(rel = "stylesheet", href = "dull/ion-range-slider/css/ion-range-slider-flat.css"),
      tags$script(src = "dull/ion-range-slider/js/ion-range-slider.min.js")
    )
  )
}
