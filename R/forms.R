#' Forms
#'
#' @description
#'
#' A forms description stub. A form's reactive value is a list of all the
#' reactive inputs within it. Form groups within a form and *which have an ID*
#' cause the form's value to take on a nested structure. See details for more
#' information.
#'
#' **`forms$group`** helps visually organization and structure a form. On the
#' server side, a `forms$group` with an `id` argument becomes a composite
#' reactive value comprised of its underlying reactive inputs.
#'
#' @usage
#'
#' forms$form(...)
#'
#' forms$inline(...)
#'
#' forms$group(..., state = NULL, fieldset = FALSE, label = NULL)
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
#' @param label A character vector specifying a label for the form group, if
#'   `fieldset` is `TRUE`, the label is rendered inside a `<legend>` element
#'   instead of a `<label>` element, defaults to `NULL`.
#'
#' @param ... Named arguments passed as HTML attributes to the parent element.
#'
#' **`forms$group`**, argument is any number of form inputs, labels, form
#' text.
#'
#' **`forms$form`** and **`forms$inline`**, any number of inputs, form
#' groups, labels, or other elements to include in the form.
#'
#' @param id A character string specifying the HTML id of a button to update.
#'
#' @param session A `ShinySession` object, defaults to the default reactive
#'   domain, see [getDefaultReactiveDomain].
#'
#' @details
#'
#' **The value of a form**
#'
#' Below is a small sample form,
#'
#' ```
#' forms$form(
#'   id = "register",
#'   forms$group(
#'     id = "names",
#'     inputs$text(
#'       id = "first",
#'       label = "First name"
#'     ),
#'     inputs$text(
#'       id = "last",
#'       label = "Last name"
#'     )
#'   )
#' )
#' ```
#'
#' The initial value of this form, given `input` is the object passed to
#' the shiny server would be,
#'
#' ```
#' input
#' input$register
#' input$register$names
#' input$register$names$first
#' NULL
#'
#' input$register$names$last
#' NULL
#' ```
#'
#' An expanded form example,
#'
#' ```
#' forms$form(
#'   id = "register",
#'   forms$group(
#'     id = "names",
#'     inputs$text(
#'       id = "first",
#'       label = "First name"
#'     ),
#'     inputs$text(
#'       id = "last",
#'       label = "Last name"
#'     )
#'   ),
#'   forms$group(
#'     id = "contact",
#'     inputs$telephone(
#'       id = "mobile",
#'       label = "Cell phone"
#'     ),
#'     inputs$telephone(
#'       id = "home",
#'       label = "Home phone"
#'     )
#'   )
#' )
#' ```
#'
#' @aliases form inline
#' @format NULL
#' @name forms
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       forms$form(
#'         id = "user",
#'         submit = TRUE,
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
forms <- list()

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

forms$form <- function(..., submit = TRUE) {
  tags$form(
    class = "dull-form",
    ...,
    bootstrap()
  )
}

forms$inline <- function(...) {
  # note this is `forms$form`, not `tags$form`
  forms$form(
    class = "form-inline",
    ...
  )
}
