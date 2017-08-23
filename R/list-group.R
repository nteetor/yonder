#' List group inputs
#'
#' A way of handling and outlining content as a list. List groups function
#' similarly to checkbox groups. A list group returns a reactive vector of the
#' values from its active (selected) list group items. List group items are
#' selected or unselected by clicking on them. While list groups may be used as
#' reactive inputs they may also be used to simply display content, in which
#' case do not specify a list group id.
#'
#' @param id A character string specifying the id of the list group input, the
#'   reactive value of the list group input is available to the shiny server
#'   function as part of the `input` object. When creating a list group to
#'   only display information pass `NULL` as the `id`, in this case an id is not
#'   added and a reactive input is not created.
#'
#' @param items A character vector or list of character strings specifying the
#'   text of the list group items, defaults to `items`.
#'
#' @param values A character string or list of character strings specifying the
#'   values of the list group items.
#'
#' @param selected One or more of `values` indicating the default list group
#'   items selected, defaults to `NULL`, in which case no items are selected and
#'   the default value of the list group input is `NULL`.
#'
#' @param badges A list of [`badgeOutput`]s added to the list group's items,
#'   defaults to `NULL`. See `badgeOutput` for more information on rendering
#'   badges.
#'
#' @param state One of `"valid"`, `"warning"`, or `"danger"` indicating the
#'   state of the list group items. If `"valid"` then the visual context is
#'   removed.
#'
#' @param validate One or more of `values` indicating which list group items
#'   to mark with `state`, defaults to `NULL`. If `NULL` then the all list group
#'   items are updated.
#'
#' @param disabled,enabled One or more of `values` indicating which list group
#'   items to disable or enable, defaults to `NULL`. If `NULL` then
#'   `disableListGroup` and `enableListGroup` will disable or enable all the
#'   list group items, respectively.
#'
#' @param increment One or more of `values` indicating which list group items to
#'   increment, defaults to `NULL`. If `NULL` then all list group items are
#'   incremented. If the list group items do not include badges there is no
#'   effect.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @seealso
#'
#' Boostrap 4 list group documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/list-group/}
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           listGroupInput(
#'             id = "listgroup",
#'             items = paste("Item", 1:5),
#'             values = 1:5,
#'             selected = 2
#'           )
#'         ),
#'         col(
#'           textOutput("selected")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$selected <- renderText({
#'         paste0(input$listgroup, collapse = ", ")
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           listGroupInput(
#'             id = "sets",
#'             items = c(
#'               "red, blue, yellow",
#'               "silver, gold, crystal",
#'               "sapphire, ruby, emerald"
#'             )
#'           )
#'         ),
#'         col(
#'           listGroupInput(
#'             id = "stub",
#'             items = NULL
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         updateListGroupInput("stub", input$sets)
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   teams <- c(
#'     `avengers` = "iron man, thor, hulk, ant-man, wasp",
#'     `west coast avengers` = "hawkeye, mockingbird, wonder man, tigra, iron man",
#'     `new avengers` = "luke cage, captain america, iron man, spider-man, spider-woman"
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tags$p(
#'             "Select teams and click a button to highlight them or remove ",
#'             "the highlighting from them"
#'           )
#'         )
#'       ),
#'       row(
#'         col(
#'           listGroupInput(
#'             id = "teams",
#'             items = names(teams),
#'             values = teams
#'           )
#'         ),
#'         col(
#'           row(
#'             buttonInput("clear", "valid", block = TRUE)
#'           ),
#'           row(
#'             buttonInput("warning", "warning", block = TRUE)
#'           ),
#'           row(
#'             buttonInput("danger", "danger", block = TRUE)
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$clear, {
#'         validateListGroupInput(
#'           id = "teams",
#'           state = input$clear$value,
#'           validate = input$teams
#'         )
#'       })
#'
#'       observeEvent(input$warning, {
#'         validateListGroupInput(
#'           id = "teams",
#'           state = input$warning$value,
#'           validate = input$teams
#'         )
#'       })
#'
#'       observeEvent(input$danger, {
#'         validateListGroupInput(
#'           id = "teams",
#'           state = input$danger$value,
#'           validate = input$teams
#'         )
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           width = 2,
#'           buttonInput(
#'             id = "enable",
#'             label = "Enable",
#'             block = TRUE
#'           )
#'         ),
#'         col(
#'           row(
#'             col(
#'               listGroupInput(
#'                 id = "listgroup",
#'                 items = c(
#'                   "One fish", "Two fish",
#'                   "Red fish", "Blue fish"
#'                 )
#'               )
#'             ),
#'             col(
#'               display4(
#'                 textOutput("value")
#'               )
#'             )
#'           )
#'         ),
#'         col(
#'           width = 2,
#'           buttonInput(
#'             id = "disable",
#'             label = "Disable",
#'             block = TRUE
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$enable, {
#'         enableListGroupInput("listgroup")
#'       })
#'
#'       observeEvent(input$disable, {
#'         disableListGroupInput("listgroup")
#'       })
#'
#'       output$value <- renderText({
#'         paste0(input$listgroup, collapse = ", ")
#'       })
#'     }
#'   )
#' }
#'
listGroupInput <- function(id, items, values = items, selected = NULL,
                           disabled = NULL, badges = NULL, ...) {
  if (length(items) != length(values)) {
    stop(
      "invalid `listGroupInput` arguments, `items` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(badges)) {
    if (any(class(badges) != "list")) {
      stop(
        "invalid `listGroupInput` argument, `badges` must be a list",
        call. = FALSE
      )
    }

    if (length(badges) != length(items)) {
      stop(
        "invalid `listGroupInput` argument, `badges` must be the same length ",
        "as `items`",
        call. = FALSE
      )
    }
  }

  selected <- match2(selected, values)
  disabled <- match2(disabled, values)

  tags$ul(
    class = collate(
      "dull-list-group-input",
      "list-group",
      "list-group-flush"
    ),
    id = id,
    if (!is.null(items)) {
      lapply(
        seq_along(items),
        function(i) {
          tags$button(
            class = collate(
              "list-group-item",
              if (!length(id)) "list-group-item-action",
              if (selected[[i]]) "active",
              if (!is.null(badges)) "justify-content-between"
            ),
            `data-value` = values[[i]],
            disabled = if (disabled[[i]]) NA,
            items[[i]],
            if (!is.null(badges)) {
              badges[[i]]
            }
          )
        }
      )
    },
    ...,
    bootstrap()
  )
}

#' @rdname listGroupInput
#' @export
updateListGroupInput <- function(id, items, values = items, selected = NULL,
                                 disabled = NULL,
                                 session = getDefaultReactiveDomain()) {
  if (length(items) != length(values)) {
    stop(
      "invalid `updateListGroupInput` arguments, `items` and `values` must ",
      "be the same length",
      call. = FALSE
    )
  }

  if (is.null(items)) {
    return(NULL)
  }

  selected <- match2(selected, values)
  disabled <- match2(disabled, values)

  items <- htmltools::tagList(
    lapply(
      seq_along(items),
      function(i) {
        tags$button(
          class = collate(
            "list-group-item",
            "list-group-item-action",
            if (selected[[i]]) "active",
            if (badges) "justify-content-between"
          ),
          `data-value` = values[[i]],
          disabled = if (disabled[[i]]) NA,
          items[[i]],
          if (badges) {
            tags$span(
              class = "badge badge-default badge-pill",
              0
            )
          }
        )
      }
    )
  )

  session$sendInputMessage(
    id,
    list(
      items = as.character(items)
    )
  )
}

#' @rdname listGroupInput
#' @export
validateListGroupInput <- function(id, state, validate = NULL,
                                   session = getDefaultReactiveDomain()) {
  if (!re(state, "valid|success|info|warning|danger", len0 = FALSE)) {
    stop(
      "`invalid `validateListGroupItem` argument, `state` must be one of ",
      '"valid", "warning", or "danger"',
      call. = FALSE
    )
  }

  validate <- unname(validate)

  session$sendInputMessage(
    id,
    list(
      state = state,
      filter = if (!is.null(validate)) as.list(validate)
    )
  )
}

#' @rdname listGroupInput
#' @export
disableListGroupInput <- function(id, disabled = NULL,
                                  session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = if (is.null(disabled)) TRUE else as.list(disabled)
    )
  )
}

#' @rdname listGroupInput
#' @export
enableListGroupInput <- function(id, enabled = NULL,
                                 session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = if (is.null(enabled)) TRUE else as.list(enabled)
    )
  )
}

#' @rdname listGroupInput
#' @export
incrementListGroupInput <- function(id, increment = NULL,
                                    session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      increment = if (is.null(increment)) TRUE else as.list(increment)
    )
  )
}
