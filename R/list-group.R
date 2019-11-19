#' List group inputs
#'
#' List group inputs are an actionable list of items. They behave similarly to
#' checkboxes or radios, that is, users may select one or more items from the
#' list. However, list group items may include highly variable content.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A vector of character strings or list of tag elements specifying
#'   the content of the list group's items.
#'
#' @param values A character vector specifying the values of the list items,
#'   defaults to `choices`.
#'
#' @param selected One or more of `values` specifying which choices are selected
#'   by default, defaults to `NULL`, in which case no choice is selected.
#'
#' @param layout A [responsive] argument. One of `"vertical"` or `"horizontal"`
#'   specifying how list items are laid out, defaults to `"vertical"`. Note, if
#'   `layout` is `"horizontal"` and the `flush` argument is ignored.
#'
#' @param flush One of `TRUE` or `FALSE` specifying if the list group is
#'   rendered without an outside border, defaults to `FALSE`. Removing the list
#'   group border is useful when rendering a list group inside a custom parent
#'   container, e.g. inside a [card()].
#'
#' @section Navigation with a list group:
#'
#' A list group can also control a set of panes. Be sure to set `multiple =
#' FALSE`. This layout is reminiscent of a table of contents.
#'
#' ```R
#' ui <- container(
#'   columns(
#'     column(
#'       width = 3,
#'       listGroupInput(
#'         id = "nav",
#'         selected = "pane1",
#'         choices = c(
#'           "Item 1",
#'           "Item 2",
#'           "Item 3"
#'         ),
#'         values = c(
#'           "pane1",
#'           "pane2",
#'           "pane3"
#'         )
#'       )
#'     ),
#'     column(
#'       navContent(
#'         navPane(
#'           id = "pane1",
#'           p("Pellentesque tristique imperdiet tortor.")
#'         ),
#'         navPane(
#'           id = "pane2",
#'           p("Sed bibendum. Donec pretium posuere tellus.")
#'         ),
#'         navPane(
#'           id = "pane3",
#'           p("Pellentesque tristique imperdiet tortor.")
#'         )
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$nav, {
#'     showPane(input$nav)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### An actionable list group
#'
#' listGroupInput(
#'   id = "list1",
#'   choices = paste("Item", 1:5)
#' )
#'
#' ### List group within a card
#'
#' card(
#'   header = h6("Pick an item"),
#'   listGroupInput(
#'     id = "list2",
#'     flush = TRUE,
#'     choices = paste("Item", 1:5),
#'   )
#' )
#'
#' ### Horizontal list group
#'
#' listGroupInput(
#'   id = "list3",
#'   choices = paste("Item", 1:4),
#'   layout = "horizontal"
#' )
#'
listGroupInput <- function(id, choices = NULL, values = choices,
                           selected = NULL, ..., layout = "vertical",
                           flush = FALSE) {
  assert_id()
  assert_choices()
  assert_possible(layout, c("vertical", "horizontal"))
  assert_possible(flush, c(TRUE, FALSE))

  dep_attach({
    layout <- resp_construct(layout, c("vertical", "horizontal"))
    classes <- resp_classes(layout, "list-group")

    # drop vertical classes as they do not actually exist
    classes <- classes[!grepl("vertical", classes, fixed = TRUE)]

    items <- map_listitems(choices, values, selected)

    tags$div(
      class = str_collate(
        "yonder-list-group",
        "list-group",
        classes,
        if (flush) "list-group-flush"
      ),
      id = id,
      items,
      ...
    )
  })
}

#' @rdname listGroupInput
#' @export
updateListGroupInput <- function(id, choices = NULL, values = choices,
                                 selected = NULL, enable = NULL, disable = NULL,
                                 session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_session()

  items <- map_listitems(choices, values, selected)

  content <- coerce_content(items)
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
