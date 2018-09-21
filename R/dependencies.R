yonderDep <- function() {
  list(
    htmlDependency(
      name = "yonder",
      version = "0.0.5",
      src = c(href = "yonder/yonder"),
      stylesheet = "css/yonder.min.css",
      script = "js/yonder.min.js"
    ),
    htmlDependency(
      name = "file-saver",
      version = "1.3.8",
      src = c(href = "yonder/file-saver"),
      script = "FileSaver.min.js"
    ),
    htmlDependency(
      name = "velocity",
      version = "1.5.1",
      src = c(href = "yonder/velocity"),
      script = "velocity.min.js"
    )
  )
}

shinyDep <- function() {
  c(
    attr(suppressDependencies("shiny"), "html_dependencies")[[1]],
    list(
      htmlDependency(
        name = "shiny",
        version = "3.3.3",
        src = c(href = "shared"),
        script = "shiny.min.js"
      )
    )
  )
}

bootstrapDep <- function() {
  list(
    htmlDependency(
      name = "popper",
      version = "1.14.3",
      src = c(href = "yonder/popper"),
      script = "popper.min.js"
    ),
    htmlDependency(
      name = "jquery",
      version = "3.3.1",
      src = c(href = "yonder/jquery"),
      script = "jquery.min.js"
    ),
    htmlDependency(
      name = "bootstrap",
      version = "4.1.2",
      src = c(href = "yonder/bootstrap"),
      stylesheet = "css/bootstrap.min.css",
      script = "js/bootstrap.min.js"
    )
  )
}

flatpickrDep <- function() {
  list(
    htmlDependency(
      name = "flatpickr",
      version = "4.5.1",
      src = c(href = "yonder/flatpickr"),
      stylesheet = "css/flatpickr.min.css",
      script = "js/flatpickr.min.js"
    )
  )
}

chabudaiDep <- function() {
  list(
    htmlDependency(
      name = "chabudai",
      version = "0.0.1",
      src = c(href = "yonder/chabudai"),
      stylesheet = "css/chabudai.min.css",
      script = "js/chabudai.min.js"
    )
  )
}

fontAwesomeDep <- function() {
  list(
    htmlDependency(
      name = "font-awesome",
      version = "5.0.13",
      src = c(href = "yonder/font-awesome"),
      stylesheet = "css/fa-svg-with-js.css",
      script = "js/fontawesome-all.min.js"
    )
  )
}

featherDep <- function() {
  list(
    htmlDependency(
      name = "feather",
      version = "4.7.3",
      src = c(href = "yonder/feather"),
      script = "feather.min.js"
    )
  )
}

ionSliderDep <- function() {
  list(
    htmlDependency(
      name = "ion-slider",
      version = "2.2.0",
      src = c(href = "yonder/ion-rangeslider"),
      stylesheet = c("css/ion.rangeSlider.css", "css/ion.rangeSlider.skinFlat.css"),
      script = "js/ion.rangeSlider.min.js"
    )
  )
}

materialDesignDep <- function() {
  list(
    htmlDependency(
      name = "material-design",
      version = "3.0.1",
      src = c(href = "yonder/material-design"),
      stylesheet = "material-icons.css"
    )
  )
}

.onLoad <- function(lib, pkg) {
  shiny::addResourcePath(
    prefix = "yonder",
    directoryPath = system.file("www", package = "yonder", mustWork = TRUE)
  )
}
