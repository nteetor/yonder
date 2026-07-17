# Test app for input_multi_select(). Driven by
# tests/testthat/test-multi-select-e2e.R via {shinytest2}.

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    input_multi_select(
      id = "ms",
      choices = c("Red", "Green", "Blue"),
      values = c("r", "g", "b"),
      select = "r"
    ),
    input_multi_select(id = "msfree", edit = "free", placeholder = "Add a tag"),
    input_multi_select(
      id = "mshoriz",
      choices = c("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot"),
      select = c("Alpha", "Bravo", "Charlie", "Delta"),
      layout = "horizontal"
    ),
    # The clipping repro: a deliberately short bslib card (its card body
    # carries overflow: auto) with filler so the card body scrolls. The
    # open menu must escape the card via the top layer. Ten choices so
    # the menu also overflows its max-height (the active-option
    # scrolling tests need a scrollable menu).
    card(
      height = 150,
      input_multi_select(
        id = "msclip",
        choices = c(
          "One",
          "Two",
          "Three",
          "Four",
          "Five",
          "Six",
          "Seven",
          "Eight",
          "Nine",
          "Ten"
        ),
        values = as.character(1:10)
      ),
      htmltools::tags$div(style = "height: 300px;")
    )
  ),
  server = function(input, output, session) {
    trigger <- function(id, handler) {
      observeEvent(input[[id]], handler(), ignoreInit = TRUE)
    }

    trigger(
      "do_update_select",
      \() update_multi_select("ms", select = c("g", "b"))
    )
    trigger(
      "do_update_choices",
      \() {
        update_multi_select(
          "ms",
          choices = c("Crimson", "Blue"),
          values = c("r", "b")
        )
      }
    )
    trigger(
      "do_update_placeholder",
      \() update_multi_select("ms", placeholder = "Pick one")
    )
    trigger("do_update_max", \() update_multi_select("ms", max = 2))
    trigger("do_disable", \() update_multi_select("ms", disable = TRUE))
    trigger("do_enable", \() update_multi_select("ms", enable = TRUE))
  }
)
