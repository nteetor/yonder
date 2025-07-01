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

  button_input_register_handler()
  checkbox_group_input_register_handler()
  link_input_register_handler()

  TRUE
}
