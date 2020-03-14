#' Checkbar input
#'
#' A stylized checkbox input. The checkbar input appears similar to a group of
#' buttons, but with a checked or highlighted state.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list of tag element specifying the
#'   input's choices, defaults to `NULL`.
#'
#' @param values A vector of values specifying the values of the input's
#'   choices, defaults to `choices`.
#'
#' @param selected One or more of `values` specifying the input's default
#'   selected values, defaults to `NULL`.
#'
#' @includeRmd man/roxygen/checkbar.Rmd
#'
#' @family inputs
#' @export
checkbarInput <- function(..., id, choices = NULL, values = choices,
                          selected = NULL) {
  assert_id()
  assert_choices()

  tag <- dep_attach({
    checkboxes <- map_checkbuttons(choices, values, selected)

    tags$div(
      class = "yonder-checkbar btn-group btn-group-toggle d-flex",
      id = id,
      `data-toggle` = "buttons",
      checkboxes,
      ...
    )
  })

  s3_class_add(tag, c("yonder_checkbar", "yonder_input"))
}

#' @rdname checkbarInput
#' @export
updateCheckbarInput <- function(id, choices = NULL, values = choices,
                                selected = NULL, enable = NULL, disable = NULL,
                                session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  checkboxes <- map_checkbuttons(choices, values, selected)

  content <- coerce_content(checkboxes)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    content = content,
    selected = selected,
    enable = enable,
    disable = disable
  ))
}

map_checkbuttons <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$label(
        class = str_collate(
          "btn",
          if (select) "active"
        ),
        tags$input(
          type = "checkbox",
          autocomplete = "off",
          value = value,
          checked = if (select) NA
        ),
        choice
      )
    }
  )
}
