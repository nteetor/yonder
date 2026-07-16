# Demo app for input_chip_group()'s `type` argument: one chip group per
# Bootstrap theme color. Each group starts with its middle chip unchecked
# (select names the checked values) so both looks show side by side —
# solid `type` fill when checked, body background with a `type` border
# when unchecked.

library(yonder)
library(bslib)

types <- c(
  "primary",
  "secondary",
  "success",
  "danger",
  "warning",
  "info",
  "light",
  "dark"
)

type_input <- function(type) {
  tagList(
    tags$h5(type, class = "mb-1 mt-3"),
    input_chip_group(
      id = type,
      choices = c("One", "Two", "Three"),
      values = c("one", "two", "three"),
      select = c("one", "three"),
      type = type
    )
  )
}

shinyApp(
  ui = page_fluid(
    title = "input_chip_group() types",
    card(
      card_header("Chip types"),
      !!!lapply(types, type_input)
    )
  ),
  server = function(input, output, session) {}
)
