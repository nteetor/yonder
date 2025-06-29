.onLoad <- function(lib, pkg) {
  add_resource_paths()

  if (!register_input_handlers()) {
    setHook(packageEvent("shiny", "onLoad"), function(...) {
      register_input_handlers()
    })
  }
}

add_resource_paths <- function() {
  shiny::addResourcePath(
    prefix = "yonder",
    directoryPath = system.file("www", package = "yonder", mustWork = TRUE)
  )
}

# approach borrowed from {bslib}
register_input_handlers <- function() {
  if (!"shiny" %in% loadedNamespaces()) {
    return(FALSE)
  }

  if (!"registerInputHandler" %in% names(asNamespace("shiny"))) {
    return(FALSE)
  }

  shiny::registerInputHandler(
    "bsides.checkbox",
    checkbox_input_handler,
    force = TRUE
  )

  shiny::registerInputHandler(
    "bsides.checkboxbutton",
    checkbox_button_input_handler,
    force = TRUE
  )

  TRUE
}
