#' Forms
#'
#' A forms description stub.
#'
#' @aliases form inline
#' @format NULL
#' @export
#' @examples
#'
forms <- list()

#' @description
#'
#' **`forms$group`** helps visually organization and structure a form. On the
#' server side, a `forms$group` with an `id` argument becomes a composite
#' reactive value comprised of its underlying reactive inputs.
#'
#' @usage forms$group(..., state = NULL, fieldset = FALSE, label = NULL)
#'
#' @param state What is the state of the group of form elements? One of
#'   `"success"`, `"warning"`, or `"danger"`, specifying the state of the
#'   form group.
#'
#' @param fieldset If `TRUE`, the form group is rendered inside a `<fieldset>`
#'   instead of a `<div>`, defaults to `FALSE`. When building a form group
#'   multiple inputs it is recommended to set `fieldset` to `TRUE` so that
#'   `label` properly renders as a `<legend>`.
#'
#' @param label A character vector specifying a label for the form group,
#'   if `fieldset` is `TRUE`, the label is rendered inside a `<legend>` element
#'   instead of a `<label>` element, defaults to `NULL`.
#'
#' @details
#'
#' **`forms$group`**, `...` argument is any number of form inputs, labels, form
#' text. or named arguments passed as HTML attributes to the parent element.
#'
#' @name forms
#' @examples
#'
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       forms$form(
#'         id = "user",
#'         forms$group(
#'           id = "names",
#'           label = "Form group",
#'           inputs$text(id = "first", placeholder = "first name"),
#'           inputs$text(id = "last", placeholder = "last name")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$user)
#'       })
#'     }
#'   )
#' }
#'
forms$group <- function(..., state = NULL, fieldset = FALSE, label = NULL) {
  if (!is.null(state) && !(state %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `forms$group` argument, `state` must be one of "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  args <- list(...)
  eles <- args[elodin(args) == ""]

  eleID <- if (length(eles) == 1) eles[[1]]$attribs$id else NULL

  parent <- if (fieldset) tags$fieldset else tags$div

  parent(
    class = collate(
      "dull-form-group form-group",
      if (!is.null(state)) paste0("has-", state)
    ),
    if (!is.null(label)) {
      if (fieldset) tags$legend(class = "col-form-legend", label) else
        tags$label(class = "col-form-label", `for` = eleID, label)
    },
    ...,
    bootstrap()
  )
}

#' @param id A character string specifying the HTML id of the element to update.
#'
#' @param session A `ShinySession` object, defaults to the default reactive
#'   domain, see [getDefaultReactiveDomain].
#'
#' @name forms
updateFormGroup <- function(id, state, session = getDefaultReactiveDomain()) {
  if (!(state %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `updateFormGroup` argument, `state` must be one of "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      state = if (!is.null(state)) paste0("has-", state)
    )
  )
}

#' @description
#'
#' **`forms$form`**
#'
#' @usage forms$form(..., submit = TRUE)
#'
#' @param submit If `TRUE`, a submit button is added to the form, the reactive
#'   value of the form will only trigger and update when the submit button is
#'   clicked, otherwise the reactive value of the form triggers each time one
#'   of its child inputs changes, defaults to `TRUE`.
#'
#' @details
#'
#' **`forms$form`** and **`forms$inline`**, `...` any number of inputs, form
#' groups, labels, or other elements to include in the form or named arguments
#' passed as HTML attributes to the parent element.
#'
#' @name forms
forms$form <- function(..., submit = TRUE) {
  tags$form(
    class = "dull-form",
    ...,
    bootstrap()
  )
}

#' @usage forms$inline(..., submit = TRUE)
#'
#' @name forms
forms$inline <- function(..., submit = TRUE) {
  # note this is `forms$form`, not `tags$form`
  forms$form(
    class = "form-inline",
    ...
  )
}
