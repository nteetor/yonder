#' Button and submit inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' @param id A character string specifying the id of the reactive input.
#'
#' @param label A character string specifying the label text on the button
#'   input.
#'
#' @param stretch One of `TRUE` or `FALSE` specifying stretched behaviour for
#'   the button or link input, defaults to `FALSE`. If `TRUE`, the button or
#'   link will receive clicks from its containing block element. For example, a
#'   stretched button or link inside a [card()] would update whenever the user
#'   clicked on the card.
#'
#' @param download One of `TRUE` or `FALSE` specifying if the button or link
#'   input is used to trigger a download, defaults to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#' ### A simple button
#'
#' buttonInput(
#'   id = "button1",
#'   label = "Simple"
#' )
#'
#' # Alternatively, a button can fill the width of its parent element.
#'
#' buttonInput(
#'   id = "button2",
#'   label = "Full-width",
#'   fill = TRUE  # <-
#' ) %>%
#'   background("red")
#'
#' # Use design utilities to further adjust the width of a button.
#'
#' buttonInput(
#'   id = "button3",
#'   label = "Full and back again",
#'   fill = TRUE  # <-
#' ) %>%
#'   background("red") %>%
#'   width("3/4")  # <-
#'
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey"
#' )
#'
#' lapply(
#'   colors,
#'   function(color) {
#'     buttonInput(
#'       id = color,
#'       label = color
#'     ) %>%
#'       background(color) %>%
#'       margin(2)
#'   }
#' ) %>%
#'   div() %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
#' ### Reactive links
#'
#' div("Curabitur ", linkInput("link1", "vulputate"), " vestibulum lorem.")
#'
#' ### Stretched buttons and links
#'
#' card(
#'   header = "Card with stretched button",
#'   p("Notice when you hover over the card, the button also detects ",
#'     "the hover."),
#'   buttonInput(
#'     id = "go",
#'     label = "Go go go",
#'     stretch = TRUE
#'   ) %>%
#'     background("blue")
#' ) %>%
#'   width(20)
#'
#' ### Download button
#'
#' buttonInput(
#'   download = TRUE,
#'   id = "download1",
#'   label = "Download",
#'   icon("download")
#' )
#'
buttonInput <- function(id, label, ..., stretch = FALSE, download = FALSE) {
  assert_id()

  component <- (if (download) tags$a else tags$button)(
    class = str_collate(
      "yonder-button",
      "btn btn-grey",
      if (stretch) "stretched-link",
      if (download) "shiny-download-link"
    ),
    type = "button",
    role = "button",
    href = if (download) "",
    `_target` = if (download) NA,
    download = if (download) NA,
    id = id,
    label,
    ...,
    autocomplete = "off"
  )

  attach_dependencies(component)
}

#' @rdname buttonInput
#' @export
linkInput <- function(id, ..., stretch = FALSE, download = FALSE) {
  assert_id()

  component <- (if (download) tags$a else tags$button)(
    class = str_collate(
      "yonder-link",
      "btn",
      if (!download) "btn-link",
      if (stretch) "stretched-link",
      if (download) "shiny-download-link"
    ),
    href = if (download) "",
    `_target` = if (download) NA,
    download = if (download) NA,
    id = id,
    ...
  )

  attach_dependencies(component)
}

#' Button group inputs
#'
#' A set of buttons with custom values.
#'
#' @inheritParams buttonInput
#'
#' @param labels A character vector specifying the labels for each button in the
#'   group.
#'
#' @param values A vector of values specifying the values of each button in the
#'   group, defaults to `labels`.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default input
#'
#' buttonGroupInput(
#'   id = "group1",
#'   labels = c("Once", "Twice", "Thrice"),
#'   values = c(1, 2, 3)
#' )
#'
#' ### Styling the button group
#'
#' buttonGroupInput(
#'   id = "group2",
#'   labels = c("Button 1", "Button 2", "Button 3")
#' ) %>%
#'   background("blue") %>%
#'   width("1/3")
#'
buttonGroupInput <- function(id, labels, values = labels, ...) {
  assert_id()

  if (length(labels) != length(values)) {
    stop(
      "invalid `buttonGroupInput()` arguments, `labels` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  shiny::registerInputHandler(
    type = "yonder.buttonGroup",
    fun = function(x, session, name) {
      if (length(x) > 1) x[[2]]
    },
    force = TRUE
  )

  buttons <- Map(
    label = labels,
    value = values,
    function(label, value) {
      tags$button(
        type = "button",
        class = "btn btn-grey",
        value = value,
        label
      )
    }
  )

  component <- tags$div(
    class = "yonder-button-group btn-group",
    id = id,
    role = "group",
    buttons,
    ...
  )

  attach_dependencies(component)
}
