#' Radio inputs
#'
#' Create a reactive radio input of one or more radio controls.
#'
#' @param id A character string specifying the id of the radio input, the
#'   reactive value of the radio input is available to the shiny server
#'   function as part of the `input` object.
#'
#' @param choices A character vector specifying labels for the radio input's
#'   choices.
#'
#' @param values A character vector, list of character strings, vector of values
#'   to coerce to character strings, or list of values to coerce to character
#'   strings specifying the values of the radio input's choices, defaults to
#'   `choices`.
#'
#' @param selected One of `values` indicating the default selected value of the
#'   radio input, defaults to `NULL`, in which case the first choice is
#'   selected by default.
#'
#' @param help A character string specifying a small help label which appears
#'   below the input, defaults to `NULL` in which case help text is not added.
#'
#' @param inline If `TRUE`, the radio input renders inline, defaults to `FALSE`,
#'   in which case the radio controls render on separate lines.
#'
#' @param disabled,enabled One or more of `values` indicating which radio
#'   choices to disable or enable, defaults to `NULL`. If `NULL` then
#'   `disableRadioInput` and `enableRadioInput` will disable or enable all
#'   the radio input's choices, respectively.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           radioInput(
#'             id = "radio",
#'             choices = c(
#'               "(A) Ice cream",
#'               "(B) Pumpkin pie",
#'               "(C) 3 turtle doves",
#'               "(D) (A) and (C)",
#'               "(E) All of the above"
#'             ),
#'             values = LETTERS[1:5]
#'           )
#'         ),
#'         col(
#'           d4(
#'             textOutput("selected")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$selected <- renderText({
#'         input$radio
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
#'           tags$h2("Stacked"),
#'           radioInput(
#'             id = "groups",
#'             choices = c("le guin", "rothfuss", "traviss"),
#'             values = c(
#'               "rocannon, exile, illusion",
#'               "wind, fear",
#'               "contact, zero, colors"
#'             )
#'           )
#'         ),
#'         col(
#'           tags$h2("Inline"),
#'           radioInput(
#'             id = "choices",
#'             choices = NULL,
#'             inline = TRUE
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         updateRadioInput(
#'           id = "choices",
#'           choices = strsplit(input$groups, ", ", fixed = TRUE)[[1]]
#'         )
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
#'           tags$h2("Disable inputs"),
#'           radioInput(
#'             id = "disabled",
#'             choices = c("one & three", "two", "two & three")
#'           )
#'         ),
#'         col(
#'           tags$h2("The inputs"),
#'           radioInput(
#'             id = "other",
#'             choices = c("one", "two", "three")
#'           )
#'         ),
#'         col(
#'           tags$h2("Input value"),
#'           textOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         req(input$disabled)
#'
#'         disableRadioInput(
#'           id = "other",
#'           disabled = switch(
#'             input$disabled,
#'             `one & three` = c("one", "three"),
#'             `two` = "two",
#'             `two & three` = c("two", "three")
#'           )
#'         )
#'       })
#'
#'       observe({
#'         req(input$disabled)
#'
#'         enableRadioInput(
#'           id = "other",
#'           enabled = switch(
#'             input$disabled,
#'             `one & three` = "two",
#'             `two` = c("one", "three"),
#'             `two & three` = "one"
#'           )
#'         )
#'       })
#'
#'       output$value <- renderText({
#'         if (is.null(input$other)) {
#'           "<NULL>"
#'         } else {
#'           input$other
#'         }
#'       })
#'     }
#'   )
#' }
#'
radioInput <- function(id, choices, values = choices, selected = NULL,
                       disabled = NULL, help = NULL, inline = FALSE) {
  if (!is.null(selected) && !(selected %in% values)) {
    stop(
      "invalid `radioInput` argument, `selected` must be one of `values`",
      call. = FALSE
    )
  }

  if (!is.null(disabled) && !(disabled %in% values)) {
    stop(
      "invalid `radioInput` argument, `disabled` must be one of `values`",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `radioInput` arguments, `choices` and `values` must be the same ",
      "length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values, default = TRUE)
  disabled <- match2(disabled, values)
  ids <- ID(rep.int("radio", length(choices)))

  tags$div(
    class = collate(
      "dull-radio-input",
      "dull-input",
      "form-group"
    ),
    id = id,
    if (!is.null(choices)) {
      lapply(
        seq_along(choices),
        function(i) {
          tags$div(
            class = collate(
              "custom-control",
              "custom-radio",
              if (inline) "custom-control-inline"
            ),
            tags$input(
              class = "custom-control-input",
              type = "radio",
              id = ids[[i]],
              name = id,
              `data-value` = values[[i]],
              checked = if (selected[[i]]) NA,
              disabled = if (disabled[[i]]) NA
            ),
            tags$label(
              class = "custom-control-label",
              `for` = ids[[i]],
              choices[[i]]
            )
          )
        }
      )
    },
    tags$div(class = "invalid-feedback"),
    if (!is.null(help)) {
      tags$small(
        class = "form-text text-muted",
        help
      )
    },
    includes()
  )
}

#' @rdname radioInput
#' @export
updateRadioInput <- function(id, choices, values = choices, selected = NULL,
                             disabled = NULL,
                             session = getDefaultReactiveDomain()) {
  if (!is.null(selected) && !(selected %in% values)) {
    stop(
      "invalid `updateRadioInput` argument, `selected` must be one of `values`",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `updateRadioInput` arguments, `choices` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)
  disabled <- match2(disabled, values, default = FALSE)

  choices <- htmltools::tagList(
    lapply(
      seq_along(choices),
      function(i) {
        tags$div(
          class = collate(
            "custom-control",
            "custom-radio"
          ),
          tags$input(
            class = "custom-control-input",
            type = "radio",
            name = id,
            `data-value` = values[[i]],
            checked = if (selected[[i]]) NA,
            disabled = if (disabled[[i]]) NA
          ),
          tags$label(
            class = "custom-control-label",
            choices[[i]]
          )
        )
      }
    )
  )

  session$sendInputMessage(
    id,
    list(
      choices = as.character(choices)
    )
  )
}

#' @rdname radioInput
#' @export
disableRadioInput <- function(id, disabled = NULL,
                              session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = if (is.null(disabled)) TRUE else as.list(disabled)
    )
  )
}

#' @rdname radioInput
#' @export
enableRadioInput <- function(id, enabled = NULL,
                             session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = if (is.null(enabled)) TRUE else as.list(enabled)
    )
  )
}
