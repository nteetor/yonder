include <- function(resource) {
  shiny::addResourcePath("dull", system.file("www", package = "dull"))

  htmltools::singleton(
    switch(
      resource,
      core = tags$head(
        htmltools::suppressDependencies("bootstrap", "jquery", "shiny"),
        tags$script(src = "dull/jquery/jquery.min.js"),
        tags$script(src = "shared/shiny.min.js"),
        tags$script(src = "dull/popper/popper.min.js"),
        tags$link(rel = "stylesheet", href = "dull/bootstrap/css/bootstrap.min.css"),
        tags$script(src = "dull/bootstrap/js/bootstrap.min.js"),
        tags$script(src = "dull/file-saver/FileSaver.min.js"),
        tags$script(src = "dull/dull/js/dull.min.js"),
        tags$link(rel = "stylesheet", href = "dull/dull/css/dull.min.css"),
        tags$script(src = "dull/velocity/velocity.min.js")
      ),
      `ion slider` = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "dull/ion-rangeslider/css/ion.rangeSlider.css"
        ),
        tags$link(
          rel = "stylesheet",
          href = "dull/ion-rangeslider/css/ion.rangeSlider.skinFlat.css"
        ),
        tags$script(src = "dull/ion-rangeslider/js/ion.rangeSlider.min.js")
      ),
      flatpickr = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "dull/flatpickr/css/flatpickr.min.css"
        ),
        tags$script(src = "dull/flatpickr/js/flatpickr.min.js")
      ),
      `font awesome` = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "dull/font-awesome/css/fa-svg-with-js.css"
        ),
        tags$script(
          defer = NA,
          src = "dull/font-awesome/js/fontawesome-all.min.js"
        )
      ),
      feather = tags$head(
        tags$script(
          src = "dull/feather/feather.min.js"
        )
      ),
      `material icons` = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "dull/material-design/material-icons.css"
        )
      )
    )
  )
}
