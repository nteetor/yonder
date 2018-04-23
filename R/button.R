#' Button and submit inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input is the number of times it has been
#' clicked.
#'
#' A submit input is a special type of button used to control HTML form
#' submission. Unlike shiny's `submitButton`, `submitInput` will not freeze all
#' reactive inputs on the page.
#'
#' @param id A character string specifying the id of the button or link input.
#'
#' @param label A character string specifying the label text on the button
#'   input.
#'
#' @param block If `TRUE`, the input is block-level instead of inline, defaults
#'   to `FALSE`. A block-level element will occupy the entire width of its
#'   parent element.
#'
#' @param disabled If `TRUE`, the input renders in a disabled state, defaults
#'   to `FALSE`.
#'
#' @param text A character string specifying the text displayed as part of the
#'   link input.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @details
#'
#' A submit input is automatically included as part of a [`formInput`].
#'
#' @seealso
#'
#' Bootstrap 4 button documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/buttons/}
#'
#' @family inputs
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(
#'             id = "button",
#'             label = "Click me!"
#'           ) %>%
#'             background("green")
#'         ),
#'         col(
#'           d4(
#'             textOutput("clicks")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$clicks <- renderText({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       buttonInput(
#'         id = "button",
#'         label = list(
#'           "Increment badge",
#'           badgeOutput(
#'             id = "badge",
#'             content = 0
#'           ) %>%
#'             background("green")
#'         )
#'       ) %>%
#'         background("amber")
#'     ),
#'     server = function(input, output) {
#'       output$badge <- renderBadge({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
buttonInput <- function(id, label, block = FALSE, ...) {
  shiny::registerInputHandler(
    type = "dull.button",
    fun = function(x, session, name) as.numeric(x),
    force = TRUE
  )

  tags$button(
    class = collate(
      "dull-button-input",
      "btn",
      if (block) "btn-block",
      "btn-grey"
    ),
    type = "button",
    role = "button",
    label,
    id = id,
    ...
  )
}

#' @rdname buttonInput
#' @export
submitInput <- function(label = "Submit", block = FALSE, ...) {
  tags$button(
    class = collate(
      "dull-submit",
      "btn",
      "btn-blue",
      if (block) "btn-block"
    ),
    # done to avoid the way Shiny handles submit buttons, will be
    # moved to HTML attribute `type` once shiny app is connected
    `data-type` = "submit",
    role = "button",
    label,
    ...
  )
}

#' @rdname buttonInput
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       "Curabitur ", linkInput("inline", "vulputate"), " vestibulum lorem."
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$inline, {
#'         showPopover(
#'           input$inline,
#'           content = "This means beef?",
#'           placement = "bottom"
#'         )
#'       })
#'     }
#'   )
#' }
#'
linkInput <- function(id, text, ...) {
  shiny::registerInputHandler(
    type = "dull.link",
    fun = function(x, session, name) {
      if (x$value == 0) {
        return(NULL)
      }

      id <- x$id
      attr(id, "clicks") <- x$value
      id
    },
    force = TRUE
  )

  tags$span(
    class = "dull-link-input",
    id = id,
    tags$u(text),
    ...
  )
}

#' Button group inputs
#'
#' Groups of buttons with a persisting value.
#'
#' @param id A character string specifying the id of the button group input.
#'
#' @param labels A character vector of labels, a button is added to the group
#'   for each label specified.
#'
#' @param values A character vector of values, one for each button specified,
#'   defaults to `labels`.
#'
#' @export
#' @examples
#'
#' buttonGroupInput("group", c("Once", "Twice"), c(1, 2))
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonGroupInput(
#'             id = "group",
#'             labels = c("Once", "Twice", "Thrice"),
#'             values = c(1, 2, 3)
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderPrint({
#'         input$group
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonGroupInput(
#'             id = "bg1",
#'             labels = c("Button 1", "Button 2", "Button 3")
#'           ) %>%
#'             background("blue", -2) %>%
#'             margins(3)
#'         ),
#'         col(
#'           buttonGroupInput(
#'             id = "bg2",
#'             labels = c("Groupee 1", "Groupee 2", "Groupee 3")
#'           ) %>%
#'             background("yellow", +1) %>%
#'             margins(3)
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$bg1)
#'       })
#'
#'       observe({
#'         print(input$bg2)
#'       })
#'     }
#'   )
#' }
#'
buttonGroupInput <- function(id, labels, values = labels) {
  if (length(labels) != length(values)) {
    stop(
      "invalid `buttonGroupInput` arguments, `labels` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  tags$div(
    class = "dull-button-group-input btn-group",
    id = id,
    role = "group",
    Map(
      label = labels,
      value = values,
      function(label, value, outline) {
        tags$button(
          type = "button",
          class = "btn",
          `data-value` = value,
          label
        )
      }
    ),
    include("core")
  )
}
