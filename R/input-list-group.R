#' List group inputs
#'
#' List group inputs are an actionable list of items. They behave similarly to
#' checkboxes or radios, that is, users may select one or more items from the
#' list. However, list group items may include highly variable content.
#'
#' @inheritParams input_checkbox_group
#'
#' @param layout <[responsive]> A character vector. The layout of the list
#'   group, `"column"` or `"row"`.
#'
#' @param flush One of `TRUE` or `FALSE` specifying if the list group is
#'   rendered without an outside border, defaults to `FALSE`. Removing the list
#'   group border is useful when rendering a list group inside a custom parent
#'   container, e.g. inside a [card()].
#'
#' @family inputs
#' @export
input_list_group <- function(
  id,
  choices,
  ...,
  values = choices,
  selected = NULL,
  layout = "vertical",
  flush = FALSE
) {
  assert_id()
  assert_choices()
  assert_possible(layout, c("vertical", "horizontal"))
  assert_possible(flush, c(TRUE, FALSE))

  with_deps({
    layout <- resp_construct(layout, c("vertical", "horizontal"))
    classes <- resp_classes(layout, "list-group")

    # drop vertical classes as they do not actually exist
    classes <- classes[!grepl("vertical", classes, fixed = TRUE)]

    items <- map_listitems(choices, values, selected)

    args <- style_dots_eval(..., .style = style_pronoun("yonder_list_group"))

    tag <- div(
      class = str_collate(
        "yonder-list-group",
        "list-group",
        classes,
        if (flush) "list-group-flush"
      ),
      id = id,
      items,
      !!!args
    )

    s3_class_add(tag, c("yonder_list_group", "yonder_input"))
  })
}

#' @rdname input_list_group
#' @export
update_list_group <- function(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  enable = NULL,
  disable = NULL,
  session = getDefaultReactiveDomain()
) {
  assert_id()
  assert_choices()
  assert_session()

  items <- map_listitems(choices, values, selected)

  content <- coerce_content(items)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(
    id,
    list(
      content = content,
      selected = selected,
      enable = enable,
      disable = disable
    )
  )
}

map_listitems <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = str_collate(
          "list-group-item",
          "list-group-item-action",
          # if (fill && length(classes) > 0) "flex-fill",
          if (select) "active"
        ),
        value = value,
        choice
      )
    }
  )
}
