#' Cards, blocks of content
#'
#' Create blocks of content with `card`. `deck` is used to group and add padding
#' is placed around any number of cards. Additionally, grouping cards with
#' `deck` has the benefit of aligning the footer of each card.
#'
#' @param ... For **card**, character strings, tag elements, or list groups to
#'   include as the body of a card or additional named arguments passed as HTML
#'   attributes to the parent element.
#'
#'   For **deck**, any number of cards or additional named arguments passed as
#'   HTML attributes to the parent element.
#'
#' @param header A character string or tag element specifying the header of the
#'   card, defaults to `NULL`, in which case a header is not added.
#'
#' @param title A character string or tag element specifying the title of the
#'   card, defaults to `NULL`, in which case a title is not added.
#'
#' @param subtitle A character string or tag element specifying the subtitle of
#'   the card, defaults to `NULL`, in which case a subtitle is not added.
#'
#' @param footer A character string or tag element specifying the footer of the
#'   card, defaults to `NULL`, in which case a footer is not added.
#'
#' @export
#' @examples
#'
card <- function(..., header = NULL, title = NULL, subtitle = NULL,
                 footer = NULL) {
  args <- list(...)
  attrs <- attribs(args)

  isListGroup <- function(x) tagHasClass(x, "list-group")

  elems <- lapply(
    elements(args),
    function(el) {
      if (isListGroup(el)) {
        return(tagEnsureClass(el, "list-group-flush"))
      }

      tags$div(
        class = "card-body",
        if (!is_tag(el)) {
          tags$p(class = "card-text", el)
        } else {
          el
        }
      )
    }
  )

  if (length(elems)) {
    elems <- Reduce(
      x = elems[-1],
      init = list(elems[[1]]),
      function(acc, el) {
        if (isListGroup(acc[[length(acc)]])) {
          c(acc, list(el))
        } else {
          acc[[length(acc)]][["children"]] <- c(
            acc[[length(acc)]][["children"]],
            el$children
          )

          acc
        }
      }
    )
  }

  header <- if (!is.null(header)) {
    if (is_tag(header)) {
      if (tagHasClass(header, "nav-tabs")) {
        tags$div(
          class = "card-header",
          tagEnsureClass(header, "card-header-tabs")
        )
      } else {
        tagEnsureClass(header, "card-header")
      }
    } else {
      tags$div(class = "card-header", header)
    }
  }

  title <- if (!is.null(title)) {
    if (is_tag(title)) {
      tagEnsureClass(title, "card-title")
    } else {
      tags$h5(class = "card-title", title)
    }
  }

  subtitle <- if (!is.null(subtitle)) {
    if (is_tag(subtitle)) {
      tagEnsureClass(subtitle, "card-subtitle")
    } else {
      tags$h6(class = "card-subtitle", subtitle)
    }
  }

  footer <- if (!is.null(footer)) {
    if (is_tag(footer)) {
      tagEnsureClass(footer, "card-footer")
    } else {
      tags$div(class = )
    }
  }

  tags$div(
    class = "card",
    if (!is.null(header)) header,
    if (!is.null(title) || !is.null(subtitle)) {
      tags$div(
        class = "card-body",
        title,
        subtitle
      )
    },
    elems,
    if (!is.null(footer)) footer
  )
}

#' @rdname card
#' @export
deck <- function(...) {
  tags$div(
    class = "card-deck",
    ...
  )
}
