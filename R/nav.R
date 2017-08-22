#' Page Navigation
#'
#' Create a nav.
#'
#' @param ... `navItem`s or `navDropdown`s passed to `nav`, `dropdownItem`s
#'   passed to `navDropdown`, or named arguments passed as HTML attributes to
#'   the respective parent element.
#'
#' @param align One of `"left"`, `"right"`, `"center"`, or `"horizontal"`
#'   specifying the alignment of the nav, defaults to `"left"`.
#'
#' @param width If specified, one of `"fill"` or `"justify"` specifying how the
#'   nav will fill its parent element, defaults to `NULL`. If `"justify"` all
#'   nav links have equal width, when `"fill"` nav links are only equally
#'   spaced.
#'
#' @param vertical If `TRUE`, the nav is rendered vertically, defaults to
#'   `FALSE`.
#'
#' @param tabs If `TRUE`, the nav is rendered as a set of tabs for a tabbed
#'   interface, defaults to `FALSE`.
#'
#' @param pills If `TRUE`, `navItem`s are rendered as pills, defaults to
#'   `FALSE`.
#'
#' @param label A character vector specifying the label of a nav item,
#'   defaults to `NULL`.
#'
#' @param active If `TRUE`, the nav item renders in a an active state, defaults
#'   to `FALSE`.
#'
#' @param disabled If `TRUE`, the nav item renders in a disabled state and
#'   will not receive click events, defaults to `FALSE`.
#'
#' @param align One of `"left"`, `"right"`, or `"center"` specifying how the
#'   nav is aligned on the page, defaults to `"left"`.
#'
#' @details
#'
#' To center a horizontal nav specify `align = "horiztonal"` and `width =
#' "fill"` or `width = "justify"`.
#'
#' @seealso
#'
#' For more information about the Bootstrap nav please follow this
#' [link](http://v4-alpha.getbootstrap.com/components/navs/).
#'
#' @family navs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = linkNav(
#'       labels = c("Home", "Profile", "Messages", "Settings"),
#'       panes = list(
#'         tags$p(
#'           "To write, to rhyme, to put a slew of words to verse, these ",
#'           "powers I do not claim to fully grasp, but like a hem catching ",
#'           "the dew in the grey of early dawn, I catch a whisper ",
#'           "each chance I stumble from the dark."
#'         ),
#'         tags$p(
#'           "Stumbling down the mountain side I chanced to turn and look ",
#'           "upon the path I'd chanced to take."
#'         ),
#'         tags$p(
#'           ""
#'         ),
#'         tags$p(
#'           "A stone set in diamond."
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
linkNav <- function(labels, panes = labels, ids = NULL,
                    align = "right", block = FALSE, ...) {
  if (!re(align, "right|left|center", FALSE)) {
    stop(
      'invalid `nav` argument, `align` must be "right", "left", or "center"',
      call. = FALSE
    )
  }

  align <- switch(align, left = "start", right = "end", "center")
  ids <- ids %||% ID(rep.int("tab", length(labels)))

  container(
    row(
      tags$nav(
        class = collate(
          "nav",
          # "nav-pills",
          "flex-column",
          "flex-sm-row"
          # paste0("justify-content-", align)
        ),
        lapply(
          seq_along(labels),
          function(i) {
            tags$a(
              class = collate(
                "flex-sm-fill",
                "text-sm-center",
                "nav-link"
              ),
              `data-toggle` = "tab",
              href = paste0("#", ids[[i]]),
              role = "tab",
              labels[[i]]
            )
          }
        )
      )
    ),
    row(
      class = "tab-content",
      lapply(
        seq_along(labels),
        function(i) {
          col(
            class = collate(
              "tab-pane",
              if (i == 1) "active"
            ),
            id = ids[[i]],
            role = "tabpanel",
            panes[[i]]
          )
        }
      )
    ),
    bootstrap()
  )
}

#' Navigation tabs
#'
#' A set of navigation tabs.
#'
#' @param labels A character vector or list of character vectors specifying
#'   the labels of the nav's tabs, named items are converted into dropdown tabs.
#'
#' @param panes A list of custom tags specifying the panes controlled by the
#'   nav. Unlike `labels` or `ids` this is a flat list of items.
#'
#' @param ids A character vector or list of character vectors mimicing the
#'   structure of `labels`, but specifying the HTML ids to use for each tab and
#'   pane pair, defaults to `NULL`, in which case ids are automatically
#'   generated.
#'
#' @family navs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       tabsNav(
#'         labels = list(
#'           "Home",
#'           "Profile",
#'           "Other" = c("Action", "Another action")
#'         ),
#'         panes = list(
#'           row(
#'             col(
#'               formInput(
#'                 id = "form",
#'                 numberInput(
#'                   id = "columns",
#'                   label = "Number of columns",
#'                   value = 1,
#'                   min = 0,
#'                 ),
#'                 numberInput(
#'                   id = "rows",
#'                   label = "Number of rows",
#'                   value = 5,
#'                   min = 0
#'                 )
#'               )
#'             ),
#'             col(
#'               tableThruput(id = "table")
#'             )
#'           ),
#'           tags$p(
#'             "The window, the window, the second story window."
#'           ),
#'           tags$p(
#'             "We must away, ere break of day, ",
#'             "To find our long-forgotten gold."
#'           ),
#'           tags$div(
#'             lead("This text is stylized"),
#'             tags$p(
#'               "This is the body of the whole text and nothing but the ",
#'               "text."
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$table <- renderTable({
#'         req(input$form)
#'
#'         form <- input$form
#'
#'         df <- as.data.frame(
#'           matrix(
#'             data = rep.int("Hello, world!", form$columns * form$rows),
#'             nrow = form$rows,
#'             ncol = form$columns
#'           )
#'         )
#'
#'         colnames(df) <- paste("Column", seq_len(form$columns))
#'
#'         df
#'       })
#'     }
#'   )
#' }
#'
tabsNav <- function(labels, panes, ids = NULL, align = "right") {
  if (length(unlist(labels)) != length(panes)) {
    stop(
      "invalid `tabsNav` arguments, `labels` and `panes` must have the same ",
      "number of itesm",
      call. = FALSE
    )
  }

  ids <- ids %||% each(labels, function() ID("tab"))

  tagList(
    row(
      col(
        tags$ul(
          class = "nav nav-tabs",
          role = "tablist",
          lapply(
            seq_along(labels),
            function(i) {
              if (nchar(names2(labels[i]))) {
                tags$li(
                  class = "nav-item dropdown",
                  tags$a(
                    class = "nav-link dropdown-toggle",
                    href = "#",
                    `data-toggle` = "dropdown",
                    role = "button",
                    `aria-haspopup` = "true",
                    `aria-expanded` = "false",
                    names(labels[i])
                  ),
                  tags$div(
                    class = "dropdown-menu",
                    lapply(
                      seq_along(labels[[i]]),
                      function(j) {
                        tags$a(
                          class = "dropdown-item",
                          href = paste0("#", ids[[i]][[j]]),
                          role = "tab",
                          `data-toggle` = "tab",
                          labels[[i]][[j]]
                        )
                      }
                    )
                  )
                )
              } else {
                tags$li(
                  class = "nav-item",
                  tags$a(
                    class = collate(
                      "nav-link",
                      if (i == 1) "active"
                    ),
                    href = paste0("#", ids[[i]]),
                    `data-toggle` = "tab",
                    role = "tab",
                    `aria-controls` = ids[[i]],
                    `aria-expanded` = "true",
                    labels[[i]]
                  )
                )
              }
            }
          )
        )
      )
    ),
    row(
      col(
        class = "tab-content",
        lapply(
          seq_along(panes),
          function(i) {
            tags$div(
              class = collate(
                "tab-pane",
                "fade",
                if (i == 1) c("show", "active")
              ),
              id = unlist(ids)[[i]],
              role = "tabpanel",
              panes[[i]]
            )
          }
        )
      )
    ),
    bootstrap()
  )
}


#' @rdname tabsNav
#' @export
pillsNav <- function(labels, panes = labels, ids = NULL, align = "right",
                     block = FALSE) {
  stop("not implemented")
}


#' List group nav
#'
#' A list group nav.
#'
#' @param labels A character vector specifying the nav tab labels.
#'
#' @param panes A list of character strings or custom elements specifying the
#'   nav panes.
#'
#' @param selected One of `labels` indicating which tab is open by default,
#'  defaults to `NULL`, in which case the first tab is the default.
#'
#' @param ids
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`. `"danger"`, `"light"`, `"dark"`, or `"default"`, specifying
#'   the visual context of the list group nav, defaults to `"default"`.
#'
#' @family navs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listGroupNav(
#'         labels = c("Home", "Profile", "Messages", "Settings"),
#'         panes = list(
#'           tags$p(
#'             "When all is said and done, the sun's brow dipped below the ",
#'             "horizon, then shall we rest ourselves, and then shall we ",
#'             "share a smile, for our hardwork is behind us for a while, ",
#'             "and for a while can we admire the life we build together."
#'           ),
#'           tags$p(
#'             "How, when the field is laid low, how, when the snow begins to ",
#'             "fall, shall I find you once again? I have let this wonderful ",
#'             "life slip through my fingers and so I am left with none, but ",
#'             "empty fists clenched against my sides"
#'           ),
#'           tags$p(
#'
#'           ),
#'           tags$p(
#'
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
listGroupNav <- function(labels, panes = labels, selected = NULL, ids = NULL,
                         context = "default", ...) {
  if (length(labels) != length(panes)) {
    stop(
      "invalid `listGroupNav` arguments, `labels` and `panes` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(ids) && length(ids) != length(labels)) {
    stop(
      "invalid `listGroupNav` argument, if `ids` is not NULL, `ids` must be ",
      "the same length as `labels`",
      call. = FALSE
    )
  }

  selected <- match2(selected, labels, default = TRUE)
  # vapply(labels, gsub, labels, pattern = "[.:# ]", replacement = "")
  ids <- ids %||% ID(rep.int("tab", length(labels)))

  row(
    col(
      width = 4,
      tags$div(
        class = "list-group",
        role = "tablist",
        lapply(
          seq_along(labels),
          function(i) {
            tags$a(
              class = collate(
                "list-group-item",
                "list-group-item-action",
                paste0("list-group-item-", context),
                if (selected[[i]]) "active"
              ),
              `data-toggle` = "list",
              href = paste0("#", ids[[i]]),
              role = "tab",
              labels[[i]]
            )
          }
        )
      )
    ),
    col(
      tags$div(
        class = "tab-content",
        lapply(
          seq_along(labels),
          function(i) {
            tags$div(
              class = collate(
                "tab-pane",
                if (selected[[i]]) "active"
              ),
              id = ids[[i]],
              role = "tabpanel",
              panes[[i]]
            )
          }
        )
      )
    ),
    ...,
    bootstrap()
  )
}
