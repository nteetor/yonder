#' Input labels, help text, and formatting to inputs
#'
#' Form groups are a way of labeling an input. Form rows arrange form groups
#' into a row and include additional styles intended for forms. The
#' flexibility provided by form rows and groups means you can confidently
#' develop shiny applications for devices and screens of varying sizes.
#'
#' @param label A character string specifying a label for the input or `NULL`
#'   in which case a label is not added.
#'
#' @param input A tag element specifying the input to label.
#'
#' @param help A character string specifying help text for the input, defaults
#'   to `NULL`, in which case help text is not added.
#'
#' @param ... For **formGroup**, additional named arguments passed as HTML
#'   attributes to the parent element.
#'
#'   For **formRow**, any number of `formGroup`s or additional named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @family layout
#' @export
formGroup <-
  function(
    label,
    input,
    ...,
    help = NULL
  ) {
    check_character(label)
    check_required(input)

    if (!is_tag(input) && !is_bare_list(input)) {
      stop(
        "invalid argument in `formGroup()`, `input` must be a tag element or list",
        call. = FALSE
      )
    }

    dep_attach({
      if (!is_tag(label)) {
        label <- tags$label(label)
      }

      tags$div(
        class = "form-group",
        ...,
        label,
        input,
        if (!is.null(help)) {
          tags$small(
            class = "form-text text-muted",
            help
          )
        }
      )
    })
  }

#' @rdname formGroup
#' @export
formRow <-
  function(...) {
    dep_attach({
      tags$div(class = "form-row", ...)
    })
  }
