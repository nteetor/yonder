include <- function(resource) {
  shiny::addResourcePath("yonder", system.file("www", package = "yonder"))

  htmltools::singleton(
    switch(
      resource,
      core = tags$head(
        htmltools::suppressDependencies("bootstrap", "jquery", "shiny"),
        tags$script(src = "yonder/jquery/jquery.min.js"),
        tags$script(src = "shared/shiny.min.js"),
        tags$script(src = "yonder/popper/popper.min.js"),
        tags$link(rel = "stylesheet", href = "yonder/bootstrap/css/bootstrap.min.css"),
        tags$script(src = "yonder/bootstrap/js/bootstrap.min.js"),
        tags$script(src = "yonder/file-saver/FileSaver.min.js"),
        tags$script(src = "yonder/yonder/js/yonder.min.js"),
        tags$link(rel = "stylesheet", href = "yonder/yonder/css/yonder.min.css"),
        tags$script(src = "yonder/velocity/velocity.min.js"),
        tags$link(rel = "stylesheet", href = "yonder/chabudai/css/chabudai.min.css"),
        tags$script(src = "yonder/chabudai/js/chabudai.min.js")
      ),
      `ion slider` = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "yonder/ion-rangeslider/css/ion.rangeSlider.css"
        ),
        tags$link(
          rel = "stylesheet",
          href = "yonder/ion-rangeslider/css/ion.rangeSlider.skinFlat.css"
        ),
        tags$script(src = "yonder/ion-rangeslider/js/ion.rangeSlider.min.js")
      ),
      flatpickr = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "yonder/flatpickr/css/flatpickr.min.css"
        ),
        tags$script(src = "yonder/flatpickr/js/flatpickr.min.js")
      ),
      `font awesome` = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "yonder/font-awesome/css/fa-svg-with-js.css"
        ),
        tags$script(
          defer = NA,
          src = "yonder/font-awesome/js/fontawesome-all.min.js"
        )
      ),
      feather = tags$head(
        tags$script(
          src = "yonder/feather/feather.min.js"
        )
      ),
      `material icons` = tags$head(
        tags$link(
          rel = "stylesheet",
          href = "yonder/material-design/material-icons.css"
        )
      )
      # chabudai = tags$head(
      #   tags$link(
      #     rel = "stylesheet",
      #     href = "yonder/chabudai/css/chabudai.min.css"
      #   ),
      #   tags$script(
      #     src = "yonder/chabudai/js/chabudai.min.js"
      #   )
      # )
    )
  )
}
