#' Cards
#'
#' Handy card tools.
#'
#' @param header Card header, a character vector or tag, defaults to `NULL`.
#'
#' @param block The card body, a character vector or tag(s), defaults to `NULL`.
#'
#' @param footer Card footer, a character vector or tag, defaults to `NULL`.
#'
#' @param text One of `"left"`, `"right"`, or `"center"`, specifying the text
#'   alignment of the card, defaults to `"left"`.
#'
#' @param context One of `"primary"`, `"success"`, `"info"`, `"warning"`, or
#'   `"danger"`, used to add a visual context to the card, defaults to `NULL`.
#'
#' @param outline If `TRUE`, the card context is styled as the card outline
#'   rather than the card background, defaults to `FALSE`.
#'
#' @param inverse If `TRUE`, the card has a dark background and light text as
#'   opposed to the default dark text on light background, defaults to `FALSE`.
#'
#' @export
card <- function(header = NULL, block = NULL, footer = NULL, text = "left",
                 context = NULL, outline = FALSE, inverse = FALSE) {
  if (bad_context(context, extra = "primary")) {
    stop(
      '`card` argument `context` must be one of `"primary"`, `"success"`, ',
      '`"info"`, `"warning"`, or `"danger"`',
      call. = FALSE
    )
  }

  tags$div(
    class = collate(
      "card",
      if (text %in% c("right", "center")) paste0("text-", text),
      if (!is.null(context)) {
        collate("card", if (outline) "outline", context, collapse = "-")
      },
      if (inverse) "card-inverse"
    ),
    if (!is.null(header)) {
      tags$div(
        class = "card-header",
        header
      )
    },
    if (!is.null(block)) {
      tags$div(
        class = "card-block",
        block
      )
    },
    if (!is.null(footer)) {
      tags$div(
        class = "card-footer",
        footer
      )
    }
  )
}
