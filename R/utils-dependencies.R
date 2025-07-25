dependency_get <- function(x) {
  htmlDependency(
    name = "yonder",
    version = utils::packageVersion("yonder"),
    src = c(
      file = system.file("www/yonder", package = "yonder"),
      href = "yonder/yonder"
    ),
    stylesheet = "css/bsides.min.css",
    script = "js/bsides.js"
  )
}

dependency_append <- function(x) {
  tagAppendChild(
    x,
    dependency_get()
  )
}

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

dep_skip <- function() {
  opt <- getOption("yonder.deps", TRUE)

  is_false(opt) || is_na(opt)
}

dep_attach <- function(tag) {
  if (dep_skip()) {
    return(tag)
  }

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

dep_remove <- function(tag) {
  attr(tag, "html_dependecies") <- NULL
  tag
}

with_deps <- function(expr) {
  dep_attach(expr)
}

dep_meta <- function() {
  htmltools::singleton(tags$head(
    tags$meta(
      name = "viewport",
      content = "width=device-width, initial-scale=1, shrink-to-fit=no"
    )
  ))
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
      name = "shiny-javascript",
      version = "3.3.3",
      src = c(
        file = system.file("www/shared/", package = "shiny"),
        href = "shared"
      ),
      script = "shiny.min.js"
    )
  )
}
