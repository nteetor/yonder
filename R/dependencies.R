attach_dependencies <- function(x) {
  attachDependencies(x, dependency_yonder())
}

dependency_yonder <- function() {
  list(
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
      name = "yonder",
      version = "0.1.1",
      src = c(
        file = system.file("www/yonder", package = "yonder"),
        href = "yonder/yonder"
      ),
      stylesheet = "css/yonder.min.css",
      script = "js/yonder.min.js"
    ),
    htmlDependency(
      name = "popper",
      version = "1.14.7",
      src = c(
        file = system.file("www/popper", package = "yonder"),
        href = "yonder/popper"
      ),
      script = "popper.min.js"
    ),
    htmlDependency(
      name = "bootstrap",
      version = "4.3.1",
      src = c(
        file = system.file("www/bootstrap", package = "yonder"),
        href = "yonder/bootstrap"
      ),
      script = "js/bootstrap.min.js"
    ),
    htmlDependency(
      name = "bs-custom-file-input",
      version = "1.3.1",
      src = c(
        file = system.file("www/bs-custom-file-input", package = "yonder"),
        href = "yonder/bs-custom-file-input"
      ),
      script = "js/bs-custom-file-input.min.js"
    ),
    htmlDependency(
      name = "shiny",
      version = "3.3.3",
      src = c(
        file = system.file("www/shared/", package = "shiny"),
        href = "shared"
      ),
      script = "shiny.min.js"
    )
  )
}

.onLoad <- function(lib, pkg) {
  shiny::addResourcePath(
    prefix = "yonder",
    directoryPath = system.file("www", package = "yonder", mustWork = TRUE)
  )
}
