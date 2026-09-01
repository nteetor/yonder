#' Collapsible panes
#'
#' Create collapsible containers to hide and show content. Open and close a
#' panel with `toggle_collapse_panel()`.
#'
#' @inheritParams badge
#'
#' @inheritParams input_checkbox
#'
#' @param state A string. The default state of the panel.
#'
#' @param direction A string. The direction to open the panel.
#'
#' @param target A string. A panel id.
#'
#' @param text A string. The content of the button.
#'
#' @returns A [htmltools::tag] object.
#'
#' @family components
#'
#' @export
#'
#' @examples
#'
#' collapse_panel("panel1", "Hidden panel")
#'
#' collapse_panel_button("panel1", "Toggle the hidden panel")
#'
collapse_panel <-
  function(
    id,
    ...,
    state = c("closed", "open"),
    direction = c("vertical", "horizontal")
  ) {
    check_string(id)

    state <- arg_match(state)
    direction <- arg_match(direction)

    component <-
      tags$div(
        id = id,
        class = c(
          "bsides-collapse collapse",
          if (direction == "horizontal") "collapse-horizontal",
          if (state == "open") "show"
        ),
        ...
      )

    component <-
      dependency_append(component)

    component <-
      s3_class_add(component, "bsides_collapse_panel")

    component
  }

#' @rdname collapse_panel
#'
#' @export
collapse_panel_button <-
  function(
    target,
    text
  ) {
    check_string(target)

    tags$button(
      type = "button",
      class = "btn btn-primary",
      `data-bs-toggle` = "collapse",
      `data-bs-target` = sprintf("#%s", target),
      `aria-expanded` = "false",
      `aria-controls` = target,
      text
    )
  }

#' Collapse panel logic
#'
#' Server-side functions for [collapse_panel]s.
#'
#' @inheritParams update_checkbox
#'
#' @describeIn open_collapse_panel Open a collapse panel.
#'
#' @export
open_collapse_panel <-
  function(
    id,
    session = get_current_session()
  ) {
    check_string(id)

    msg <-
      list(
        method = "open"
      )

    session$sendInputMessage(id, msg)
  }

#' @describeIn open_collapse_panel Close a collapse panel.
#'
#' @export
close_collapse_panel <-
  function(
    id,
    session = get_current_session()
  ) {
    check_string(id)

    msg <-
      list(
        method = "close"
      )

    session$sendInputMessage(id, msg)
  }

#' @describeIn open_collapse_panel Toggle a collapse panel open or closed.
#'
#' @export
toggle_collapse_panel <-
  function(
    id,
    session = get_current_session()
  ) {
    check_string(id)

    msg <-
      list(
        method = "toggle"
      )

    session$sendInputMessage(id, msg)
  }
