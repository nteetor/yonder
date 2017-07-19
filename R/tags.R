#' @importFrom htmltools tags
#' @export
htmltools::tags

#' Bootstrap Builder Functions
#'
#' @description
#'
#' These functions are alternatives to the builder functions found in [tags]. In
#' the past, Bootstrap would automatically style a tag. Bootstrap version 4 has
#' taken a step back and does not automatically style tags. Instead they offer
#' classes like `.table` which will apply the previously standard styles. To
#' clue the user into possible, available styles and options new arguments have
#' been added to these rebooted builder functions.
#'
#' The following rebooted builder functions are bundled into the `bs` object
#' and, include specific arguments in addition to `...`,
#'
#' - [table, thead, tr, th, td][table]
#' - [ol, ul, dl, dt, dd][lists]
#' - [img, figure][img]
#' - [blockquote][blockquote]
#'
#' @usage bs
#'
#' @format NULL
#' @name bs
#' @export
bs <- structure(
  list(),
  name = "bs",
  class = c("module", "list")
)

#' Responsive Images and Figures
#'
#' A small update to `<img>` and `<figure>`. Additional arguments has been added
#' to the `img` builder function. Figures have specific arguments for an `img`
#' child element and caption.
#'
#' @usage
#'
#' bs$img(..., fluid = TRUE, align = NULL, thumbnail = FALSE)
#'
#' bs$figure(..., image = NULL, caption = NULL, align = "left")
#'
#' @param fluid If `TRUE`, the image will scale with its parent element,
#'   defaults to `TRUE`.
#'
#' @param align For `img`, one of `"left"` or `"right"` specifying which side of
#'   the parent element the image should align to, defaults to `NULL` in which
#'   case no alignment is applied.
#'
#'   For `figure`, one of `"left"`, `"right"`, or `"center"` specifying which
#'   side of the figure the figure caption is aligned to, defaults to `"left"`.
#'
#' @param thumbnail If `TRUE`, the image is rendered with a small border,
#'   defaults to `FALSE`.
#'
#' @param image An `img` element, it is best to leave the image as fluid,
#'   defaults to `NULL`.
#'
#' @param caption A character vector specifying a caption for the image,
#'   defaults to `NULL`.
#'
#' @aliases figure
#' @name img
#' @examples
#'
#' # A figure with a,
#' #   - fluid image
#' #   - left-aligned caption
#' bs$figure(
#'   image = bs$img(src = "http://bit.ly/2qchbEB"),
#'   caption = "Stock cat photo."
#' )
#'
bs$img <- function(..., fluid = TRUE, align = NULL, thumbnail = FALSE) {
  htmltools::tag(
    "img",
    list(
      if (fluid) "img-fluid",
      if (thumbnail) "img-thumbnail",
      if (!is.null(align)) paste0("float-", align),
      ...,
      bootstrap()
    )
  )
}

bs$figure <- function(..., image = NULL, caption = NULL, align = "left") {
  htmltools::tag(
    "figure",
    list(
      ...,
      if (!is.null(image)) tagEnsureClass(image, "figure-img"),
      if (!is.null(caption)) {
        tags$figcaption(
          class = collate(
            "figure-caption",
            if (align %in% c("center", "right")) paste0("text-", align)
          ),
          caption
        )
      },
      bootstrap()
    )
  )
}

#' Cleaner Blockquotes
#'
#' Stylized blockquotes, an updated builder function for `<blockquote>`.
#'
#' @param source The quote source, use `tags$cite` to format the source title,
#'   defaults to `NULL`.
#'
#' @param align One of `"left"` or `"right"`, defaults to `"left"`.
#'
#' @name blockquote
#' @examples
#' bs$blockquote(
#'   "Anyone can love a thing because.",
#'   "That's as easy as putting a penny in your pocket.",
#'   "But to love something despite.",
#'   "To know the flaws and love them too.",
#'   "That is rare and pure and perfect.",
#'   source = tags$span(
#'     "Patrick Rothfuss,", tags$cite("The Wise Man's Fear")
#'   )
#' )
#'
bs$blockquote <- function(..., source = NULL, align = "left") {
  htmltools::tag(
    "blockquote",
    list(
      class = collate(
        "blockquote",
        if (align == "right") "blockquote-reverse"
      ),
      ...,
      if (!is.null(source)) {
        tags$footer(class = "blockquote-footer", source)
      }
    ),
    bootstrap()
  )
}

#' List Styling and Unstyling
#'
#' Rebooted builder functions for `<ul>`, `<ol>`, `<dl>`, `<dt>`, and `<dd>`.
#' Ordered and unordered lists can now be unstyled, removing bullets and some
#' margins. Description lists make use of the container system.
#'
#' @usage
#'
#' bs$ul(..., styled = TRUE, inline = FALSE)
#'
#' bs$ol(..., styled = TRUE, inline = FALSE)
#'
#' bs$dl(...)
#'
#' bs$dt(..., width = NULL, truncate = FALSE)
#'
#' bs$dd(..., width = NULL)
#'
#' @param styled When `FALSE` the default list style is removed and left margins
#'   are removed, but this applies only to the *direct children elements*,
#'   defaults to `TRUE`.
#'
#' @param inline When `TRUE`, list bullets are removed and the list is rendered
#'   inline, defaults to `FALSE`.
#'
#' @param width Description lists can make use of the row, column grid system. 1
#'   through 12, defaults to `NULL`, alternate widths for different viewports
#'   may be specified using a named multi-length vector or list, see details
#'   section.
#'
#' @param truncate When `TRUE` long description titles are shortened and a "..."
#'   is added, defaults to `FALSE`.
#'
#' @details
#'
#' One can specify alternate column offsets or widths for different viewports by
#' using the following naming convention. A specific offset or width will be
#' applied when the viewport is **at least** the corresponding size, see below.
#'
#' - **unnamed**, applies to all viewports.
#'
#' - **`sm`**, at least 576 pixels wide.
#'
#' - **`md`**, at least 768 pixels wide.
#'
#' - **`lg`**, at least 992 pixels wide.
#'
#' - **`xl`**, at least 1200 pixels wide.
#'
#' See examples for more on how to make use of this functionality.
#'
#' @aliases ul ol dl dt dd
#' @name lists
#' @examples
#'
bs$ul <- function(..., styled = TRUE, inline = FALSE) {
  htmltools::tag(
    "ul",
    c(
      list(
        class = collate(
          if (!styled) "list-unstyled",
          if (inline) "list-inline"
        )
      ),
      lapply(
        list(...),
        function(i) if (is_tag(i)) tagEnsureClass(i, "list-inline-item") else i
      ),
      bootstrap()
    )
  )
}

bs$ol <- function(..., styled = TRUE, inline = FALSE) {
  htmltools::tag(
    "ol",
    c(
      list(
        class = collate(
          if (!styled) "list-unstyled",
          if (inline) "list-inline"
        )
      ),
      lapply(
        list(...),
        function(i) if (is_tag(i)) tagEnsureClass(i, "list-inline-item") else i
      ),
      bootstrap()
    )
  )
}

bs$dl <- function(...) {
  htmltools::tag(
    "dl",
    list(
      class = collate(
        "row"
      ),
      ...,
      bootstrap()
    )
  )
}

bs$dt <- function(..., width = NULL, truncate = FALSE) {
  htmltools::tag(
    "dt",
    list(
      class = collate(
        vapply(
          seq_along(width),
          function(i) {
            nm <- names(width[i])

            collate(
              "col",
              if (nm %in% c("", "xs")) NULL else nm,
              width[[i]],
              collapse = "-"
            )
          },
          character(1)
        ),
        if (truncate) "text-truncate"
      ),
      ...,
      bootstrap()
    )
  )
}

bs$dd <- function(..., width = NULL) {
  htmltools::tag(
    "dd",
    list(
      class = vapply(
        seq_along(width),
        function(i) {
          nm <- names(width[i])

          collate(
            "col",
            if (nm %in% c("", "xs")) NULL else nm,
            width[[i]],
            collapse = "-"
          )
        },
        character(1)
      ),
      ...,
      bootstrap()
    )
  )
}


#' Bootstrap Tables
#'
#' New and improved tables, table headers, and table rows. Additional arguments
#' have been added to help indicate and add shortcuts for possible Bootstrap
#' stylizations.
#'
#' @usage
#'
#' bs$table(..., inverse = FALSE, striped = FALSE, borders = FALSE,
#'   hover = FALSE, compact = FALSE, scrollable = FALSE)
#'
#' bs$thead(..., inverse = FALSE)
#'
#' bs$tr(..., context = NULL, inverse = FALSE)
#'
#' bs$th(..., context = NULL, inverse = FALSE)
#'
#' bs$td(..., context = NULL, inverse = FALSE)
#'
#' @param context One of `"active"`, `"primary"`, `"success"`, `"info"`,
#'   `"warning"`, or `"danger"`, applies contextual styling to table rows or
#'   cells, defaults to `NULL`.
#'
#'   Please be aware that `"active"` will not work when `inverse` is `TRUE` and
#'   `"primary"` only works when `inverse` is `TRUE`.
#'
#' @param inverse Table or table header renders with light text on a dark
#'   background, defaults to `FALSE`.
#'
#' @param striped Render table with zebra striped rows, defaults to `FALSE`.
#'
#' @param borders Render table with all borders, defaults to `FALSE`.
#'
#' @param hover Enable hover state on table rows, defaults to `FALSE`.
#'
#' @param compact Cut cell padding to make the table more compact, defaults to
#'   `FALSE`.
#'
#' @param scrollable If `TRUE`, the table has horizontal scroll on small
#'   viewports, defaults to `FALSE`.
#'
#' @aliases thead
#' @name table
#' @examples
#'
bs$table <- function(..., inverse = FALSE, striped = FALSE, borders = FALSE,
                     hover = FALSE, compact = FALSE, scrollable = FALSE) {
  htmltools::tag(
    "table",
    list(
      class = collate(
        if (!is.null(context)) paste0("table-", context),
        if (inverse) "table-inverse",
        if (striped) "table-striped",
        if (borders) "table-bordered"
      ),
      ...,
      bootstrap()
    )
  )
}

bs$thead <- function(..., inverse = FALSE) {
  htmltools::tag(
    "th",
    list(
      if (inverse) "thead-inverse" else "thead-default",
      ...,
      bootstrap()
    )
  )
}

bs$tr <- function(..., context = NULL, inverse = FALSE) {
  htmltools::tag(
    "tr",
    list(
      class = collate(
        if (!is.null(context)) {
          paste0(if (inverse) "bg" else "table", "-", context)
        }
      ),
      ...,
      bootstrap()
    )
  )
}

bs$th <- function(..., context = NULL, inverse = FALSE) {
  htmltools::tag(
    "th",
    list(
      class = collate(
        if (!is.null(context)) {
          paste0(if (inverse) "bg" else "table", "-", context)
        }
      ),
      ...,
      bootstrap()
    )
  )
}

bs$td <- function(..., context = NULL, inverse = FALSE) {
  htmltools::tag(
    "td",
    list(
      class = collate(
        if (!is.null(context)) {
          paste0(if (inverse) "bg" else "table", "-", context)
        }
      ),
      ...,
      bootstrap()
    )
  )
}
