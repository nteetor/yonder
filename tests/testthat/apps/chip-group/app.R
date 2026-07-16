# Test app for input_chip_group(). Driven by
# tests/testthat/test-chip-group-e2e.R via {shinytest2}.

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
    input_chip_group(
      id = "cg",
      choices = c("Red", "Green", "Blue"),
      values = c("r", "g", "b"),
      select = NULL
    ),
    input_chip_group(
      id = "cg2",
      choices = c("Small", "Medium", "Large"),
      values = c("s", "m", "l"),
      select = "m",
      type = "warning"
    ),
    input_chip_group(
      id = "cgall",
      choices = c("One", "Two"),
      values = c("one", "two")
    )
  ),
  server = function(input, output, session) {
    trigger <- function(id, handler) {
      shiny::observeEvent(input[[id]], handler(), ignoreInit = TRUE)
    }

    trigger(
      "do_select",
      \() update_chip_group("cg", select = c("r", "b"))
    )
    trigger(
      "do_select_clear",
      \() update_chip_group("cg", select = character(0))
    )
    trigger(
      "do_replace_choices",
      \() {
        update_chip_group(
          "cg2",
          choices = c("Medium", "Giant"),
          values = c("m", "xl")
        )
      }
    )
    trigger("do_disable", \() update_chip_group("cg", disable = TRUE))
    trigger("do_enable", \() update_chip_group("cg", enable = TRUE))
  }
)
