flags <- new.env(parent = emptyenv())

flag_get <- function(x) get0(x = x, envir = flags, inherits = FALSE)

flag_set <- function(x, value) assign(x = x, value = value, envir = flags)

dep_fetch <- function() {
  if (is.null(flag_get("deps")) || !flag_get("deps")) {
    flag_set("deps", 1)
    dep_yonder()
  }
}

dep_complete <- function() {
  flag_set("deps", NULL)
}

dep_attach <- function(tag) {
  deps <- dep_fetch()

  if (!is.null(deps)) {
    on.exit(dep_complete())
  }

  force(tag)

  if (length(deps)) {
    tag <- htmltools::attachDependencies(tag, deps)
    tag <- htmltools::tagAppendChild(tag, dep_meta())
    tag
  } else {
    tag
  }
}

dep_meta <- function() {
  tags$head(
    tags$meta(
      name = "viewport",
      content = "width=device-width, initial-scale=1, shrink-to-fit=no"
    )
  )
}

dep_yonder <- function() {
  list(
    htmlDependency(
      name = "jquery",
      version = "3.4.1",
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
