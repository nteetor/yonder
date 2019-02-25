yonderDep <- function() {
  list(
    htmlDependency(
      name = "yonder",
      version = "0.0.5",
      src = c(
        file = system.file("www/yonder", package = "yonder"),
        href = "yonder/yonder"
      ),
      script = "js/yonder.min.js"
    ),
    htmlDependency(
      name = "file-saver",
      version = "1.3.8",
      src = c(
        file = system.file("www/file-save", package = "yonder"),
        href = "yonder/file-saver"
      ),
      script = "FileSaver.min.js"
    ),
    htmlDependency(
      name = "popper",
      version = "1.14.3",
      src = c(
        file = system.file("www/popper", package = "yonder"),
        href = "yonder/popper"
      ),
      script = "popper.min.js"
    ),
    htmlDependency(
      name = "jquery",
      version = "3.3.1",
      src = c(
        file = system.file("www/jquery", package = "yonder"),
        href = "yonder/jquery"
      ),
      script = "jquery.min.js"
    ),
    htmlDependency(
      name = "bootstrap",
      version = "4.2.1",
      src = c(
        file = system.file("www/bootstrap", package = "yonder"),
        href = "yonder/bootstrap"
      ),
      stylesheet = "css/bootstrap.min.css",
      script = c("js/bootstrap.min.js", "js/bs-custom-file-input.min.js")
    ),
    htmlDependency(
      name = "shiny",
      version = "3.3.3",
      src = c(href = "shared"),
      script = "shiny.min.js"
    )
  )
}

shinyDep <- function() {
  c(
    attr(suppressDependencies("shiny"), "html_dependencies")[[1]],
    list(

    )
  )
}

chabudaiDep <- function() {
  list(
    htmlDependency(
      name = "chabudai",
      version = "0.0.1",
      src = c(
        file = system.file("www/chabudai", package = "yonder"),
        href = "yonder/chabudai"
      ),
      stylesheet = "css/chabudai.min.css",
      script = "js/chabudai.min.js"
    )
  )
}

ionSliderDep <- function() {
  list(
    htmlDependency(
      name = "ion-slider",
      version = "2.2.0",
      src = c(
        file = system.file("www/ion-rangeslider", package = "yonder"),
        href = "yonder/ion-rangeslider"
      ),
      stylesheet = c(
        "css/ion.rangeSlider.css",
        "css/ion.rangeSlider.skinFlat.css"
      ),
      script = "js/ion.rangeSlider.min.js"
    )
  )
}

.onLoad <- function(lib, pkg) {
  shiny::addResourcePath(
    prefix = "yonder",
    directoryPath = system.file("www", package = "yonder", mustWork = TRUE)
  )
}
