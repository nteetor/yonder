#' Button and link inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' @param id A character string specifying the id of the reactive input.
#'
#' @param label A character string specifying the label text on the button or
#'   link input.
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
#' @param tooltip A call to [tooltip()] specifying a tooltip for the button or
#'   link input, defaults to `NULL`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param value A number specifying a new value for the button, defaults to
#'   `NULL`.
#'
#' @param enable If `TRUE` the button is enabled and will react to clicks from
#'   the user,  defaults to `NULL`.
#'
#' @param disable if `TRUE` the button is disabled and will not react to clicks
#'   from the user, default to `NULL`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @details
#'
#' ### Tooltips
#'
#' To remove a button or link input's tooltip pass an empty tooltip,
#' `tooltip()`, to `updateButtonInput()` or `updateLinkInput()`.
#'
#' @includeRmd man/roxygen/button.Rmd
#'
#' @family inputs
#' @export
buttonInput <- function(..., id, label, stretch = FALSE, download = FALSE,
                        tooltip = NULL) {
  assert_id()
  assert_label()

  with_deps({
    tag <- (if (download) tags$a else tags$button)(
      class = str_collate(
        "yonder-button",
        "btn",
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
      autocomplete = "off"
    )

    ## tag <- tag_tooltip_add(tag, tooltip)
    args <- style_dots_eval(..., .style = style_pronoun("yonder_button"))
    tag <- tag_extend_with(tag, args)

    s3_class_add(tag, c("yonder_button", "yonder_input"))
  })
}

#' @rdname buttonInput
#' @export
updateButtonInput <- function(id, label = NULL, value = NULL,
                              disable = NULL, enable = NULL,
                              tooltip = NULL,
                              session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!is.null(value) && !is.numeric(value)) {
    stop(
      "invalid argument in `updateButtonInput()`, `value` must be numeric or ",
      "NULL",
      call. = FALSE
    )
  }

  content <- coerce_content(label)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    value = value,
    disable = disable,
    enable = enable,
    tooltip = tooltip
  ))
}


#' @rdname buttonInput
#' @export
linkInput <- function(..., id, label, stretch = FALSE, download = FALSE,
                      tooltip = NULL) {
  assert_id()
  assert_label()

  with_deps({
    tag <- (if (download) tags$a else tags$button)(
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
      label
    )

    ## tag_tooltip_add(, tooltip)
    args <- style_dots_eval(...)
    tag <- tag_extend_with(tag, args)

    tag
  })
}

#' @rdname buttonInput
#' @export
updateLinkInput <- function(id, label = NULL, value = NULL,
                            enable = NULL, disable = NULL,
                            tooltip = NULL,
                            session = getDefaultReactiveDomain())  {
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

  session$sendInputMessage(id, list(
    content = content,
    value = value,
    enable = enable,
    disable = disable,
    tooltip = tooltip
  ))
}
