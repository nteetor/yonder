includes <- function() {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    tags$head(
      htmltools::suppressDependencies("bootstrap", "jquery", "shiny"),
      tags$script(src = "dull/jquery/jquery.min.js"),
      tags$link(rel = "stylesheet", href = "shared/shiny.css"),
      tags$script(src = "shared/shiny.min.js"),
      tags$script(src = "dull/popper/popper.min.js"),
      tags$link(
        rel = "stylesheet",
        href = "dull/bootstrap/css/bootstrap.min.css"
      ),
      tags$script(src = "dull/bootstrap/js/bootstrap.min.js"),
      tags$link(
        rel = "stylesheet",
        href = "dull/ion-rangeslider/css/ion.rangeSlider.css"
      ),
      tags$link(
        rel = "stylesheet",
        href = "dull/ion-rangeslider/css/ion.rangeSlider.skinFlat.css"
      ),
      tags$script(src = "dull/ion-rangeslider/js/ion.rangeSlider.min.js"),
      tags$link(
        rel = "stylesheet",
        href = "dull/flatpickr/css/flatpickr.min.css"
      ),
      tags$script(src = "dull/flatpickr/js/flatpickr.min.js"),
      tags$script(
        defer = NA,
        src = "dull/font-awesome/js/fontawesome.min.js"
      ),
      tags$script(src = "dull/dull/js/dull.min.js"),
      tags$link(rel = "stylesheet", href = "dull/dull/css/dull.min.css")
    )
  )
}
