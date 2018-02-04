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
#' reactive inputs.
#'
#' @param id A character string specifying the id of the button input.
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
#'       row(
#'         col(
#'           buttonInput(
#'             id = "change",
#'             text = "Change other button"
#'           )
#'         ),
#'         col(
#'           buttonInput(
#'             id = "button",
#'             text = "Button",
#'             outline = TRUE
#'           )
#'         ),
#'         col(
#'           d4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$change, {
#'         updateButtonInput(
#'           id = "button",
#'           text = paste("Button", input$change)
#'         )
#'
#'         resetButtonInput("button")
#'       })
#'
#'       output$value <- renderText({
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
#'             background("lime") %>%
#'             darken(4)
#'         )
#'       ) %>%
#'         background("amber") %>%
#'         lighten(2)
#'     ),
#'     server = function(input, output) {
#'       output$badge <- renderBadge({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
buttonInput <- function(id, label, block = FALSE, disabled = FALSE, ...) {
  tags$button(
    class = collate(
      "dull-button-input",
      "dull-input",
      "btn",
      if (block) "btn-block",
      "bg-grey"
    ),
    type = "button",
    role = "button",
    `data-clicks` = 0,
    label,
    id = id,
    ...,
    disabled = if (disabled) NA
  )
}

#' @rdname buttonInput
#' @export
updateButtonInput <- function(id, label,
                              session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      label = label
    )
  )
}

#' @rdname buttonInput
#' @export
disableButtonInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = TRUE
    )
  )
}

#' @rdname buttonInput
#' @export
enableButtonInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = TRUE
    )
  )
}

#' @rdname buttonInput
#' @export
resetButtonInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      reset = TRUE
    )
  )
}

#' @rdname buttonInput
#' @export
submitInput <- function(label = "Submit", block = FALSE, disabled = FALSE,
                        ...) {
  tags$button(
    class = collate(
      "dull-submit",
      "btn",
      "bg-blue",
      if (block) "btn-block"
    ),
    # done to avoid the way Shiny handles submit buttons, will be
    # moved to HTML attribute `type` once shiny app is connected
    `data-type` = "submit",
    role = "button",
    label,
    ...,
    disabled = if (disabled) NA
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
#'             background("light-blue") %>%
#'             darken(3) %>%
#'             margins(3)
#'         ),
#'         col(
#'           buttonGroupInput(
#'             id = "bg2",
#'             labels = c("Groupee 1", "Groupee 2", "Groupee 3")
#'           ) %>%
#'             background("yellow") %>%
#'             lighten(2) %>%
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
    class = "dull-button-group-input btn-group bg-grey",
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
    includes()
  )
}
