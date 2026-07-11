# Test app for input_multi_select(). Driven by
# tests/testthat/test-multi-select-e2e.R via {shinytest2}.

local({
  pkg_root <- normalizePath(
    file.path(getwd(), "..", "..", "..", ".."),
    mustWork = FALSE
  )

  if (
    file.exists(file.path(pkg_root, "DESCRIPTION")) &&
      requireNamespace("pkgload", quietly = TRUE)
  ) {
    pkgload::load_all(pkg_root, quiet = TRUE)
  } else {
    library(yonder)
  }
})

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_multi_select(id = "ms", placeholder = "Add a tag"),
    input_multi_select(id = "msmax", select = c("A", "B"), max = 3)
  ),
  server = function(input, output, session) {}
)
