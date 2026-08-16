dependency_get <-
  function(x) {
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

dependency_append <-
  function(x) {
    tagAppendChild(
      x,
      dependency_get()
    )
  }
