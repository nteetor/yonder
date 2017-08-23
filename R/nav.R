#' Page Navigation
#'
#' Create a nav element. This is not a set of tabs, for creating a tabbed interface
#' of dynamic content see [tabsNav] or [pillsNav].
#'
#' @param labels A character vector or flat list of character strings specifying
#'   the labels of the nav.
#'
#' @param hrefs A character vector or flat list of character strings specifying
#'   the HTML href attributes for each nav link.
#'
#' @param ... Additional named arguments to pass as HTML attributes to the
#'   parent element.
#'
#' @seealso
#'
#' For more information about the Bootstrap nav please follow this
#' [link](http://v4-alpha.getbootstrap.com/components/navs/).
#'
#' @family navs
#' @export
#' @examples
#'
#' stub
#'
linksNav <- function(labels, hrefs, ...) {
  if (length(labels) != length(hrefs)) {
    stop(
      "invalid `linksNav` arguments, `labels` and `hrefs` must be the same ",
      "length",
      call. = FALSE
    )
  }

  tags$ul(
    class = collate(
      "nav"
    ),
    lapply(
      seq_along(labels),
      function(i) {
        tags$li(
          class = "nav-item",
          tags$a(
            class = collate(
              "nav-link"
            ),
            `data-toggle` = "tab",
            href = hrefs[[i]],
            role = "tab",
            `aria-expanded` = "true",
            labels[[i]]
          )
        )
      }
    ),
    ...,
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
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       pillsNav(
#'         labels = c("Home", "Profile", "Messages", "Settings"),
#'         panes = list(
#'           lapply(
#'             c(
#'               "To write, to rhyme, to put a slew of words to verse",
#'               "These powers I cannot claim to fully grasp",
#'               "But like my hem catches the dew in the grey of early dawn",
#'               "I catch a whisper each chance I stumble from the darkness."
#'             ),
#'             tags$p
#'           ),
#'           tags$p(
#'             "Stumbling down the mountain side I chanced to turn and look ",
#'             "upon the path I'd chanced to take."
#'           ),
#'           tags$p(
#'             ""
#'           ),
#'           tags$p(
#'             "A stone set in diamond."
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
tabsNav <- function(labels, panes, ids = NULL, ...) {
  if (length(unlist(labels)) != length(panes)) {
    stop(
      "invalid `tabsNav` arguments, `labels` and `panes` must have the same ",
      "number of items",
      call. = FALSE
    )
  }

  ids <- ids %||% `map*`(labels, function(x) ID("tab"))

  if (length(unlist(ids)) != length(panes)) {
    stop(
      "invalid `tabsNav` arguments, `labels` and `ids` must have the same ",
      "number of items",
      call. = FALSE
    )
  }

  row(
    tabbableTabs("tabs", labels, ids),
    tabbablePanes(panes, ids),
    ...,
    bootstrap()
  )
}


#' @rdname tabsNav
#' @export
pillsNav <- function(labels, panes, ids = NULL, ...) {
  if (length(unlist(labels)) != length(panes)) {
    stop(
      "invalid `pillsNav` arguments, `labels` and `panes` must have the same ",
      "number of items",
      call. = FALSE
    )
  }

  ids <- ids %||% `map*`(labels, function(x) ID("tab"))

  if (length(unlist(ids)) != length(panes)) {
    stop(
      "invalid `pillsNav` arguments, `labels` and `ids` must have the same ",
      "number of items",
      call. = FALSE
    )
  }

  row(
    tabbableTabs("pills", labels, ids),
    tabbablePanes(panes, ids),
    ...,
    bootstrap()
  )
}

tabbableTabs <- function(type, labels, ids) {
  toggle <- sub("s$", "", type)

  col(
    class = collate(
      "nav",
      paste0("nav-", type),
      "col-12",
      "col-lg-3",
      "flex-column",
      "flex-sm-row",
      "flex-lg-column",
      "mb-1",
      "mb-sm-3",
      "pr-0",
      "pr-sm-3"
    ),
    role = "tablist",
    lapply(
      seq_along(labels),
      function(i) {
        if (nchar(names2(labels[i]))) {
          tags$div(
            class = "dropdown",
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
                    `data-toggle` = toggle,
                    labels[[i]][[j]]
                  )
                }
              )
            )
          )
        } else {
          tags$a(
            class = collate(
              "flex-sm-fill",
              "nav-link",
              if (i == 1) "active"
            ),
            href = paste0("#", ids[[i]]),
            `data-toggle` = toggle,
            role = "tab",
            `aria-controls` = ids[[i]],
            `aria-expanded` = "true",
            labels[[i]]
          )
        }
      }
    )
  )
}

tabbablePanes <- function(panes, ids) {
  col(
    class = collate(
      "col-12",
      "col-lg-9",
      "tab-content"
    ),
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
}


#' List group nav
#'
#' A list group nav.
#'
#' @param labels A character vector or flast list of character strings
#'   specifying the nav tab labels.
#'
#' @param panes A list of character strings or custom elements specifying the
#'   nav panes.
#'
#' @param ids A character vector or flat list of character strings specifying
#'   the ids of the panes.
#'
#' @param selected One of `labels` indicating which tab is open by default,
#'  defaults to `NULL`, in which case the first tab is the default.
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
listGroupNav <- function(labels, panes, ids = NULL, selected = NULL,
                         context = "default", ...) {
  if (length(labels) != length(panes)) {
    stop(
      "invalid `listGroupNav` arguments, `labels` and `panes` must be the ",
      "same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, labels, default = TRUE)

  # vapply(labels, gsub, labels, pattern = "[.:# ]", replacement = "")
  ids <- ids %||% ID(rep.int("tab", length(labels)))

  if (length(ids) != length(labels)) {
    stop(
      "invalid `listGroupNav` argument, `ids` and `labels` must be the same ",
      "length",
      call. = FALSE
    )
  }

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
