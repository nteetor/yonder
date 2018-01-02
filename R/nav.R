#' Page Navigation
#'
#' Create a nav element. This is not a set of tabs. To create a tabbed interface
#' of dynamic content see [tabsNav] or [pillsNav].
#'
#' @param labels A character vector or flat list of character strings specifying
#'   the labels of the nav.
#'
#' @param ids A character vector or flat list of character strings specifying
#'   ids of the content linked to.
#'
#' @param vertical One of `TRUE` or `FALSE`, if `TRUE` the nav links are
#'   rendered as a column instead of a row, defaults to `FALSE`.
#'
#' @param ... Additional named arguments to pass as HTML attributes to the
#'   parent element.
#'
#' @seealso
#'
#' Bootstrap 4 nav documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/navs/}
#'
#' @family navs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       linksNav(
#'         labels = paste("Section", 1:5),
#'         ids = paste0("section", 1:5)
#'       ),
#'       tags$h5(id = "section1", "Section 1"),
#'       tags$p(
#'         "In sed minim reprimique, usu omnesque tincidunt disputando no, porro
#'         debitis adipisci qui an. An augue alterum qui. Nam ei debitis
#'         luptatum, usu munere docendi an, viderer disputando ut sed. Enim
#'         erant partiendo pri ei, mazim fierent mei et. Cum elit scripserit in,
#'         cu novum equidem officiis eum."
#'       ),
#'       tags$h5(id = "section2", "Section 2"),
#'       tags$p(
#'         "In sed minim reprimique, usu omnesque tincidunt disputando no, porro
#'         debitis adipisci qui an. An augue alterum qui. Nam ei debitis
#'         luptatum, usu munere docendi an, viderer disputando ut sed. Enim
#'         erant partiendo pri ei, mazim fierent mei et. Cum elit scripserit in,
#'         cu novum equidem officiis eum."
#'       ),
#'       tags$h5(id = "section3", "Section 3"),
#'       tags$p(
#'         "In sed minim reprimique, usu omnesque tincidunt disputando no, porro
#'         debitis adipisci qui an. An augue alterum qui. Nam ei debitis
#'         luptatum, usu munere docendi an, viderer disputando ut sed. Enim
#'         erant partiendo pri ei, mazim fierent mei et. Cum elit scripserit in,
#'         cu novum equidem officiis eum."
#'       ),
#'       tags$h5(id = "section4", "Section 4"),
#'       tags$p(
#'         "In sed minim reprimique, usu omnesque tincidunt disputando no, porro
#'         debitis adipisci qui an. An augue alterum qui. Nam ei debitis
#'         luptatum, usu munere docendi an, viderer disputando ut sed. Enim
#'         erant partiendo pri ei, mazim fierent mei et. Cum elit scripserit in,
#'         cu novum equidem officiis eum."
#'       ),
#'       tags$h5(id = "section5", "Section 5"),
#'       tags$p(
#'         "In sed minim reprimique, usu omnesque tincidunt disputando no, porro
#'         debitis adipisci qui an. An augue alterum qui. Nam ei debitis
#'         luptatum, usu munere docendi an, viderer disputando ut sed. Enim
#'         erant partiendo pri ei, mazim fierent mei et. Cum elit scripserit in,
#'         cu novum equidem officiis eum."
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
#'
linksNav <- function(labels, ids, ...) {
  if (length(labels) != length(ids)) {
    stop(
      "invalid `linksNav` arguments, `labels` and `ids` must be the same ",
      "length",
      call. = FALSE
    )
  }

  tags$ul(
    class = collate(
      "nav",
      if (vertical) "flex-column"
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
            href = paste0("#", ids[[i]]),
            labels[[i]]
          )
        )
      }
    ),
    ...,
    bootstrap()
  )

}

#' Tabbable content
#'
#' Create tabbable content with headers stylized as tabs, pills, or a list
#' group. Tab sets or tab panels are distinct from navs. `tabsTabs` and
#' `pillsTabs` may include nested tabs as dropdowns by passing named character
#' vectors or lists as elements of the `labels` argument. However, `listTabs`
#' does not allow nested tabs.
#'
#' @param labels A character vector or list of character vectors specifying
#'   the labels of the nav's tabs. `tabsTabs` and `pillsTabs` understand named
#'   items which are converted into dropdown tabs.
#'
#' @param panes A list of custom tags specifying the panes controlled by the
#'   nav. Unlike `labels` or `ids` this is a flat list of items.
#'
#' @param ids A character vector or list of character vectors mimicing the
#'   structure of `labels`, but specifying the HTML ids to use for each tab and
#'   pane pair, defaults to `NULL`, in which case ids are automatically
#'   generated.
#'
#' @param selected One of `labels` indicating which tab is open by default,
#'   defaults to `NULL`, in which case the first tab is the default.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`. `"danger"`, `"light"`, `"dark"`, or `NULL`, specifying
#'   the visual context of the list nav, defaults to `NULL`, in which case a
#'   visual context is not applied.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @seealso
#'
#' Bootstrap 4 nav documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/navs/}
#'
#' @family tabs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       tabsTabs(
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
#'             tags$p(
#'               class = "lead",
#'               "This text is stylized"
#'             ),
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
#'       pillsTabs(
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listTabs(
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
tabsTabs <- function(labels, panes, ids = NULL, ...) {
  if (length(unlist(labels)) != length(panes)) {
    stop(
      "invalid `tabsTabs` arguments, `labels` and `panes` must have the same ",
      "number of items",
      call. = FALSE
    )
  }

  ids <- ids %||% `map*`(labels, function(x) ID("tab"))

  if (length(unlist(ids)) != length(panes)) {
    stop(
      "invalid `tabsTabs` arguments, `labels` and `ids` must have the same ",
      "number of items",
      call. = FALSE
    )
  }

  tagList(
    tabs("tabs", labels, ids),
    panes(panes, ids),
    ...,
    bootstrap()
  )
}


#' @rdname tabsTabs
#' @export
pillsTabs <- function(labels, panes, ids = NULL, ...) {
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
    tabs(
      "pills",
      labels,
      ids,
      class = "col-12"
    ),
    panes(
      panes,
      ids
    ),
    ...,
    bootstrap()
  )
}

#' @rdname tabsTabs
#' @export
listTabs <- function(labels, panes, ids = NULL, selected = NULL,
                     context = NULL, ...) {
  if (!all(vapply(labels, is.character, logical(1)))) {
    stop(
      "invalid `listTabs` argument, `labels` must be a character vector or ",
      "flat list of character strings",
      call. = FALSE
    )
  }

  if (length(labels) != length(panes)) {
    stop(
      "invalid `listTabs` arguments, `labels` and `panes` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!re(context, "primary|secondary|success|info|warning|danger|light|dark")) {
    stop(
      "invalid `listTabs` argument, `context` must be one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", "dark", or NULL',
      call. = FALSE
    )
  }

  selected <- match2(selected, labels, default = TRUE)

  # vapply(labels, gsub, labels, pattern = "[.:# ]", replacement = "")
  ids <- ids %||% `map*`(labels, function(e) ID("tab"))

  if (length(ids) != length(labels)) {
    stop(
      "invalid `listTabs` argument, `ids` and `labels` must be the same ",
      "length",
      call. = FALSE
    )
  }

  tabslist(labels, panes, ids, selected, context, ...)
}

tabs <- function(type, labels, ids, ...) {
  toggle <- sub("s$", "", type)

  col(
    class = collate(
      "nav",
      paste0("nav-", type)
    ),
    role = "tablist",
    ...,
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

panes <- function(panes, ids, ...) {
  col(
    class = collate(
      "tab-content"
    ),
    ...,
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

tabslist <- function(labels, panes, ids, selected, context, ...) {
  row(
    col(
      default = "auto",
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

#' Create dynamic tabbed content
#'
#' Content with tabs.
#'
#' @param id A character string specifying the id of the tabbed content. The
#'   reactive value of tabbed content is the label of the currently selected tab
#'   or a custom value if `values` is not `NULL`.
#'
#' @param labels A character vector of labels, one for each tab panel.
#'
#' @param ... Any number of `tabPanel`'s or named attributes passed as HTML
#'   attributes to the parent element.
#'
#' @param style One of `"tabs"`, `"pills"`, or `"vertical"` specifying the
#'   visual style of the tabs, defaults to `"tabs"`.
#'
#' @param selected One of `labels` specifying which tab is selected by default,
#'   defaults to `NULL`, in which case the first tab is selected by default.
#'
#' @param values A character vector specifying the possible values of the tabs,
#'   defaults to `labels`. The reactive value of the tabbed content is the
#'   corresponding value of the active tab. Values are matched to tabs by
#'   position.
#'
#' @param ids A character vector of ids to use for each tab, defaults to `NULL`
#'   in which case ids will be generated.
#'
#' @param fade One of `TRUE` or `FALSE`, if `TRUE` the tab pane fades in,
#'   defaults to `TRUE`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           default = 3,
#'           tabContent(
#'             id = "tabs",
#'             labels = c("Hello", "Goodnight"),
#'             tabPanel(
#'               d4("World")
#'             ),
#'             tabPanel(
#'               d4("Moon")
#'             )
#'           )
#'         ),
#'         col(
#'           default = 3,
#'           tabContent(
#'             id = "pills",
#'             style = "pills",
#'             labels = c("One", "Red"),
#'             tabPanel(
#'               d4("fish, two fish")
#'             ),
#'             tabPanel(
#'               d4("fish, blue fish")
#'             )
#'           )
#'         ),
#'         col(
#'           tabContent(
#'             id = "vert",
#'             style = "vertical",
#'             labels = c("How", "Brown"),
#'             tabPanel(
#'               d4("now")
#'             ),
#'             tabPanel(
#'               d4("cow")
#'             )
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tabContent(
#'             id = "tabs",
#'             labels = c("One", "Two", "Three"),
#'             values = c("first tab", "second tab", "third tab"),
#'             tabPanel(
#'               "A tab"
#'             ),
#'             tabPanel(
#'               "Another tab"
#'             ),
#'             tabPanel(
#'               "A final tab"
#'             )
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("which")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$which <- renderPrint({
#'         input$tabs
#'       })
#'     }
#'   )
#' }
#'
tabContent <- function(id, labels, ..., style = "tabs", selected = NULL,
                       values = labels, ids = NULL) {
  if (!re(style, "tabs|pills|vertical", len0 = NULL)) {
    stop(
      "invalid `tabContent` argument, `style` must be one of",
      '"tabs", "pills", or "vertical"',
      call. = FALSE
    )
  }

  args <- list(...)
  eles <- elements(args)
  attrs <- attribs(args)

  if (length(eles) != length(labels)) {
    stop(
      "invalid `tabContent` argument, `labels` must be the same length",
      "as the number of tab panels",
      call. = FALSE
    )
  }

  if (!is.null(values) && (length(values) != length(eles))) {
    stop(
      "inavlid `tabContent` argument, if `values` is not NULL, a value must",
      "be specified for each tab panel",
      call. = FALSE
    )
  }

  if (!is.null(ids) && (length(ids) != length(eles))) {
    stop(
      "invalid `tabContent` argument, if `ids` is not NULL, an id must be",
      "specified for each tab panel",
      call. = FALSE
    )
  }

  ids <- ids %||% ID(rep.int("tab", length(eles)))
  selected <- match2(selected %||% labels[[1]], labels)
  values <- values %||% labels

  tabs <- tags$ul(
    class = collate(
      "nav",
      paste0("nav-", if (style == "vertical") "pills" else style),
      if (style == "vertical") "flex-column"
    ),
    role = "tablist",
    Map(
      id = ids,
      label = labels,
      active = selected,
      value = values,
      f = function(id, label, active, value) {
        tags$li(
          class = "nav-item",
          tags$a(
            class = collate(
              "nav-link",
              if (active) "active"
            ),
            `data-toggle` = "tab",
            href = paste0("#", id),
            role = "tab",
            `aria-controls` = id,
            `aria-selected` = if (active) "true" else "false",
            `data-value` = if (!is.null(values)) value,
            label
          )
        )
      }
    )
  )

  tabs <- tagConcatAttributes(tabs, attrs)

  panes <- tags$div(
    class = "tab-content",
    Map(
      id = ids,
      pane = eles,
      active = selected,
      f = function(id, pane, active) {
        if (active) {
          pane <- tagEnsureClass(pane, "show")
          pane <- tagEnsureClass(pane, "active")
        }

        pane$attribs$id <- id

        pane
      }
    )
  )

  if (style == "vertical") {
    tabs <- col(default = 3, tabs)
    panes <- col(default = 9, panes)
  }

  parent <- if (style == "vertical") row else tags$div

  parent(
    id = id,
    class = "dull-tabs",
    tabs,
    panes,
    bootstrap()
  )
}

#' @rdname tabContent
#' @export
tabPanel <- function(..., fade = TRUE) {
  tags$div(
    class = collate(
      "tab-pane",
      if (fade) "fade"
    ),
    role = "tabpanel",
    ...
  )
}
