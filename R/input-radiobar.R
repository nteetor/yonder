#' Radiobar inputs
#'
#' A stylized group of radio inputs. A radiobar input is similar to a button
#' group, but with a checked or highlighted stated. Additionally, only one value
#' at most may be selected at any given time.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector or list of tag elements specifying the
#'   labels of the input's choices.
#'
#' @param values A vector specifying the values of the input's choices,
#'   defaults to `choices`.
#'
#' @param selected One of `values` specifying the input's default selected
#'   choice, defaults to `values[[1]]`.
#'
#' @includeRmd man/roxygen/radiobar.Rmd
#'
#' @family inputs
#' @export
radiobarInput <- function(..., id, choices, values = choices,
                          selected = values[[1]]) {
  assert_id()
  assert_choices()
  assert_selected(len = 1)

  dep_attach({
    radios <- map_radiobuttons(choices, values, selected, id)

    tags$div(
      class = "yonder-radiobar btn-group btn-group-toggle d-flex",
      id = id,
      `data-toggle` = "buttons",
      ...,
      radios
    )
  })
}

#' @rdname radiobarInput
#' @export
updateRadiobarInput <- function(id, choices = NULL, values = choices,
                                selected = NULL, enable = NULL, disable = NULL,
                                session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_selected(len = 1)
  assert_session()

  radios <- map_radiobuttons(choices, values, selected, id)

  content <- coerce_content(radios)
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

map_radiobuttons <- function(choices, values, selected, parent_id) {
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
          name = parent_id,
          type = "radio",
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        choice
      )
    }
  )
}
