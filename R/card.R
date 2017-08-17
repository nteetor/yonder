#' Cards, highly variable blocks of content
#'
#' Create cards. Use `cardBlock`, `cardList` to add components to a card.
#'
#' @param header A character string specifying a header for the card, defaults
#'   to `NULL`.
#'
#' @param title A character string specifying a title for the card, defaults
#'   to `NULL`.
#'
#' @param subtitle A character string specifying a subtitle for the card,
#'   defaults to `NULL`.
#'
#' @param text A character string specifying a body of the card, defaults to
#'   `NULL`.
#'
#' @param context One of `"primary"`, `"success"`, `"info"`, `"warning"`, or
#'   `"danger"`, used to add a visual context to the card, defaults to `NULL`.
#'
#' @param outline If `TRUE`, the card context is styled as an outline
#'   rather than the background of the card, defaults to `FALSE`.
#'
#' @param inverse If `TRUE`, the card has a dark background and light text as
#'   opposed to the default dark text on light background, defaults to `FALSE`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           card(
#'             align = "center",
#'             cardBlock(
#'               title = "Card One",
#'               text = "Hello, world!",
#'               buttonInput("Click me")
#'             )
#'           )
#'         ),
#'         col(
#'           card(
#'             align = "center",
#'             cardBlock(
#'               title = "Card Two",
#'               text = "Goodnight, moon!",
#'               buttonInput("Click me")
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
card <- function(..., context = NULL, outline = FALSE, align = "left") {
  if (!re(context, "primary|success|info|warning|danger")) {
    stop(
      '`card` argument `context` must be one of `"primary"`, `"success"`, ',
      '`"info"`, `"warning"`, or `"danger"`',
      call. = FALSE
    )
  }

  if (!re(align, "left|right|center")) {
    stop(
      'invalid `card` argument, `align` must be one of "left", "right", or ',
      '"center"',
      call. = FALSE
    )
  }

  tags$div(
    class = collate(
      "card",
      if (!is.null(context)) {
        if (outline) {
          paste0("card-outline-", context)
        } else {
          paste0("card-", context, " card-inverse")
        }
      },
      if (align != "left") paste0("text-", align)
    ),
    ...
  )
}

#' @rdname card
#' @export
cardBlock <- function(..., header = NULL, title = NULL, subtitle = NULL,
                      text = NULL, footer = NULL, context = NULL,
                      outline = FALSE) {
  tags$div(
    class = collate(
      "card-block"
    ),
    if (!is.null(header)) {
      tags$div(class = "card-header", header)
    },
    if (!is.null(title)) {
      tags$h4(class = "card-title", title)
    },
    if (!is.null(subtitle)) {
      tags$h6(class = "card-subtitle", subtitle)
    },
    if (!is.null(text)) {
      tags$p(class = "card-text", text)
    },
    ...,
    if (!is.null(footer)) {
      tags$div(class = "card-footer", footer)
    }
  )
}

#' @rdname card
#' @export
cardList <- function(...) {
  listGroupInput(
    class = "list-group-flush",
    ...
  )
}

#' Card groups and decks
#'
#' Group card objects together as groups or decks. Card groups placed cards
#' directly side by side. Card decks put space in between cards. When grouping
#' cards footers are aligned.
#'
#' @param ... Any number of card elements or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @export
cardGroup <- function(...) {
  tags$div(
    class = "card-group",
    ...
  )
}

#' @rdname cardGroup
#' @export
cardDeck <- function(...) {
  tags$div(
    class = "card-deck",
    ...
  )
}
