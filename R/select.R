#' Select input
#'
#' A select input.
#'
#' @param id A character string specifying the id of the select input.
#'
#' @param options A character vector specifying the labels of the select input
#'   options.
#'
#' @param values A character vector specifying the values of the select input
#'   options, defaults to `options`.
#'
#' @param selected One of `options` indicating the default value of the select
#'   input, defaults to `NULL`. If `NULL` the first value is selected by
#'   default.
#'
#' @param multiple If `TRUE` multiple options may be selected, defaults to
#'   `FALSE`, in which case only one option may be selected.
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
#'           selectInput(
#'             id = "select",
#'             options = c("Choose one", "One", "Two", "Three"),
#'             values = list(NULL, 1, 2, 3),
#'             multiple = TRUE
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
#'       output$value <- renderText({
#'         input$select
#'       })
#'     }
#'   )
#' }
#'
#'
selectInput <- function(id, options, values = options, selected = NULL,
                        multiple = FALSE, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `selectInput` argument, `id` must be a character string or NULL",
      call. = FALSE
    )
  }

  if (length(options) != length(values)) {
    stop(
      "invalid `selectInput` arguments, `options` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(selected)) {
    if (length(selected) > 1) {
      stop(
        "invalid `selectInput` argument, `selected` must be of length 1",
        call. = FALSE
      )
    }

    if (!(selected %in% options)) {
      stop(
        "invalid `selectInput` argument, `selected` must be one of `values`",
        call. = FALSE
      )
    }
  }

  selected <- match2(selected, values, default = TRUE)

  tags$div(
    class = collate(
      "dull-select-input",
      "dull-input",
      "form-group",
      if (multiple) "h-100"
    ),
    id = id,
    tags$select(
      class = collate(
        "custom-select",
        if (multiple) "h-100"
      ),
      lapply(
        seq_along(options),
        function(i) {
          tags$option(
            `data-value` = values[[i]],
            options[[i]],
            selected = if (selected[[i]]) NA
          )
        }
      ),
      multiple = if (multiple) NA
    ),
    tags$div(class = "invalid-feedback"),
    ...,
    bootstrap()
  )
}
