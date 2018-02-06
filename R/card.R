#' Cards, highly variable blocks of content
#'
#' `textCard` a simple way to represent content as a standalone block.
#' `tabsCard` and `pillsCard` allow more content to be packed into a single
#' card. `deck` is used to group and ensure proper padding is placed around any
#' number of cards.
#'
#' @param title A character string specifying the title of the card's content.
#'
#' @param body A character string specifying the body of the card's content.
#'
#' @param align One of `"left"`, `"right"`, or `"center"` specifying the text
#'   alignment of the card, defaults to `"left"`.
#'
#' @param header A character string specifying header text of the card, defaults
#'   to `NULL`, in which case a header is not added.
#'
#' @param footer A character string specifying footer text of the card, defaults
#'   to `NULL`, in which case a footer is not added.
#'
#' @param labels A character vector or list of character strings specifying the
#'   tab labels of the navigation card.
#'
#' @param panes A list of custom tags specifying the tab content of the
#'   navigation card.
#'
#' @param ... Any number of cards or additional named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   library(ggplot2)
#'
#'   shinyApp(
#'     ui = container(
#'       tags$div(
#'         class = "card",
#'         style="width: 20rem;",
#'         tags$div(
#'           class = "shiny-plot-output",
#'           id = "plot",
#'           style = "width: 318px; height: 180px;",
#'           tags$div(
#'             class = "card-img-top",
#'             tags$img(
#'               alt = "Card image cap"
#'             )
#'           )
#'         ),
#'         tags$div(
#'           class = "card-body",
#'           tags$h4(class = "card-title", "Card title"),
#'           tags$p(class = "card-text", "card text, card text")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$plot <- renderPlot({
#'         ggplot(mtcars, aes(cyl, mpg)) +
#'           geom_point()
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
#'           textCard(
#'             title = "A special title",
#'             body = "Here is some supporting text"
#'           )
#'         ),
#'         col(
#'           textCard(
#'             title = "A special title",
#'             body = "Here is some supporting text"
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
#' #
#' #  with `deck` you can ensure proper spacing between cards
#' #
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       deck(
#'         textCard(
#'           title = "Long content",
#'           body = "This text is the long and where does the text go? How do you know when the text will end? Never fear. This is over."
#'         ),
#'         textCard(
#'           align = "right",
#'           title = "Longer content",
#'           body = c(
#'             "This text makes what you read look like childs play. Here goes the world and here comes the sun. There was an eclipse the other day, did you know? ",
#'             "In case you did not know I hope you will find someone to explain the majesty of it all."
#'           )
#'         ),
#'         textCard(
#'           align = "center",
#'           title = "Short content",
#'           body = "No rambling necessary for this card."
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
#'       deck(
#'         tabsCard(
#'           labels = c("Info", "Data", "Options"),
#'           panes = list(
#'             tags$p("Some info, the main content of this card"),
#'             tags$p(class = "card-text", "This tab describes the data behind what you saw on on the info tab"),
#'             tags$p("Here are some options")
#'           )
#'         ),
#'         pillsCard(
#'           labels = c("Info", "Data", "Options"),
#'           panes = list(
#'             tags$p("Some info, the main content of this card"),
#'             tags$p(class = "card-text", "This tab describes the data behind what you saw on on the info tab"),
#'             tags$p("Here are some options")
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
textCard <- function(title, body, header = NULL, align = "left", footer = NULL,
                     ...) {
  if (!re(align, "left|right|center", FALSE)) {
    stop(
      "invalid `textCard` argument, `align` must be one of ",
      '"left", "right", or "center"',
      call. = FALSE
    )
  }

  tags$div(
    class = collate(
      "card",
      if (align != "left") paste0("text-", align)
    ),
    if (!is.null(header)) {
      tags$div(class = "card-header", header)
    },
    tags$div(
      class = "card-body",
      tags$h4(class = "card-title", title),
      tags$p(class = "card-text", body)
    ),
    ...,
    if (!is.null(footer)) {
      tags$div(
        class = "card-footer",
        tags$small(class = "text-muted", footer)
      )
    }
  )
}

#' @rdname textCard
#' @export
tabsCard <- function(labels, panes, ...) {
  ids <- ID(rep.int("tab", length(labels)))

  tags$div(
    class = "card",
    tags$div(
      class = "card-header",
      tags$ul(
        class = "nav nav-tabs card-header-tabs",
        role = "tablist",
        lapply(
          seq_along(labels),
          function(i) {
            tags$li(
              class = "nav-item",
              tags$a(
                class = collate(
                  "nav-link",
                  if (i == 1) "active"
                ),
                href = paste0("#", ids[[i]]),
                `data-toggle` = "tab",
                labels[[i]]
              )
            )
          }
        )
      )
    ),
    tags$div(
      class = "card-body tab-content",
      lapply(
        seq_along(labels),
        function(i) {
          tags$div(
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
    ...
  )
}

#' @rdname textCard
#' @export
pillsCard <- function(labels, panes, ...) {
  ids <- ID(rep.int("tab", length(labels)))

  tags$div(
    class = "card",
    tags$div(
      class = "card-header",
      tags$ul(
        class = "nav nav-pills card-header-pills",
        role = "tablist",
        lapply(
          seq_along(labels),
          function(i) {
            tags$li(
              class = "nav-item",
              tags$a(
                class = collate(
                  "nav-link",
                  if (i == 1) "active"
                ),
                href = paste0("#", ids[[i]]),
                `data-toggle` = "pill",
                labels[[i]]
              )
            )
          }
        )
      )
    ),
    tags$div(
      class = "card-body tab-content",
      lapply(
        seq_along(labels),
        function(i) {
          tags$div(
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
    ...
  )
}

#' @rdname textCard
#' @export
deck <- function(...) {
  tags$div(
    class = "card-deck",
    ...
  )
}
