#' Button and link inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' @param id A character string. specifying the id of the reactive input.
#'
#' @param label A character string specifying the label text on the button or
#'   link input.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
input_button <- function(
  id,
  label,
  ...
) {
  assert_id()
  assert_label()

  tag <-
    tags$button(
      class = "bsides-button btn",
      type = "button",
      role = "button",
      id = id,
      label,
      ...
    )

  tag <-
    tagAppendChild(
      tag,
      htmlDependency(
        name = "yonder",
        version = utils::packageVersion("yonder"),
        src = c(
          file = system.file("www/yonder", package = "yonder"),
          href = "yonder/yonder"
        ),
        # stylesheet = "css/yonder.min.css",
        script = "js/bsides.js"
      ),
    )

  tag
}

#' @rdname input_button
#' @export
input_link <- function(
  id,
  label,
  stretch = FALSE,
  ...
) {
  assert_id()
  assert_label()

  tags$button(
    class = c(
      "btn",
      if (stretch) "stretched-link",
    ),
    label
  )
}

#' Change button
#'
#' Change button.
#'
#' @param value A number specifying a new value for the button, defaults to
#'   `NULL`.
#'
#' @param disable A boolean or `NULL`.
#'   * If `TRUE`, the button is disabled and will not react to clicks from the user.
#'   * If `FALSE`, the button is enabled.
#'   * If `NULL`, the argument is ignored.
#'
#' @param session A reactive context, defaults to [default_reactive_domain()].
#'
#' @export
update_button <- function(
  id,
  label = NULL,
  value = NULL,
  disable = NULL,
  session = default_reactive_domain()
) {
  assert_id()
  assert_session()

  stopifnot(
    is.null(value) || is.numeric(value)
  )

  content <- coerce_content(label)
  disable <- coerce_disable(disable)

  session$sendInputMessage(
    id,
    list(
      content = content,
      value = value,
      disable = disable,
      enable = enable,
      tooltip = tooltip
    )
  )
}


#' @rdname buttonInput
#' @export
updateLinkInput <- function(
  id,
  label = NULL,
  value = NULL,
  enable = NULL,
  disable = NULL,
  tooltip = NULL,
  session = getDefaultReactiveDomain()
) {
  assert_id()
  assert_session()

  if (!is.null(value) && !is.numeric(value)) {
    stop(
      "invalid argument in `updateLinkInput()`, `value` must be numeric or ",
      "NULL",
      call. = FALSE
    )
  }

  if (!is.null(value)) {
    value <- as.numeric(value)
  }

  content <- coerce_content(label)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(
    id,
    list(
      content = content,
      value = value,
      enable = enable,
      disable = disable,
      tooltip = tooltip
    )
  )
}
