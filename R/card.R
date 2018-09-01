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
#' @param image An [img()] element specifying an image to add to the card,
#'   defaults to `NULL`, in which case an image is not added.
#'
#' @param footer A character string or tag element specifying the footer of the
#'   card, defaults to `NULL`, in which case a footer is not added.
#'
#' @family content
#' @export
#' @examples
#'
#' card("Praesent fermentum tempor tellus.")
#'
#'
#' card(
#'   title = "Mauris mollis tincidunt felis.",
#'   subtitle = "Phasellus at dui in ligula mollis ultricies.",
#'   "Nullam tempus. Mauris mollis tincidunt felis.",
#'   "Nullam libero mauris, consequat quis, varius et, dictum id, arcu."
#' )
#'
#'
#' card(
#'   listGroupThruput(
#'     id = NULL,
#'     listGroupItem(
#'       "Pellentesque tristique imperdiet tortor."
#'     ),
#'     listGroupItem(
#'       "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
#'     ),
#'     listGroupItem(
#'       "Phasellus purus."
#'     )
#'   )
#' )
#'
#'
#' card(
#'   header = "Nunc rutrum turpis sed pede.",
#'   title = "Sed bibendum.",
#'   "Etiam vel neque nec dui dignissim bibendum. Etiam vel neque nec dui dignissim bibendum.",
#'   buttonInput(id = NULL, label = "Phasellus purus")
#' )
#'
#'
#' card(
#'   header = tabTabs(
#'     id = "myCardTabs",
#'     labels = c("Phasellus", "Donec", "Fusce")
#'   ),
#'   tabContent(
#'     tabs = "myCardTabs",
#'     tabPane(
#'       "Phasellus purus. Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus."
#'     ),
#'     tabPane(
#'       "Donec at pede. Praesent augue."
#'     ),
#'     tabPanel(
#'       "Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio."
#'     )
#'   )
#' )
#'
#'
#' card(
#'   header = div("Donec pretium posuere tellus.") %>%
#'     background("teal"),
#'   "Donec hendrerit tempor tellus.",
#'   "Cras placerat accumsan nulla."
#' )
#'
card <- function(..., header = NULL, title = NULL, subtitle = NULL,
                 image = NULL, footer = NULL) {
  args <- list(...)
  attrs <- attribs(args)

  title <- if (!is.null(title)) {
    if (is_tag(title)) {
      tagAddClass(title, "card-title")
    } else {
      tags$h5(class = "card-title", title)
    }
  }

  subtitle <- if (!is.null(subtitle)) {
    if (is_tag(subtitle)) {
      tagAddClass(subtitle, "card-subtitle")
    } else {
      tags$h6(class = "card-subtitle", subtitle)
    }
  }

  isListGroup <- function(x) tagHasClass(x, "list-group")

  body <- lapply(
    dropNulls(c(list(title, subtitle), elements(args))),
    function(el) {
      if (isListGroup(el)) {
        return(tagAddClass(el, "list-group-flush"))
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

  if (length(body)) {
    body <- Reduce(
      x = body[-1],
      init = list(body[[1]]),
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
          tagAddClass(header, "card-header-tabs")
        )
      } else {
        tagAddClass(header, "card-header")
      }
    } else {
      tags$div(class = "card-header", header)
    }
  }

  image <- if (!is.null(image)) {
    tagAddClass(image, "card-img-top")
  }

  footer <- if (!is.null(footer)) {
    if (is_tag(footer)) {
      tagAddClass(footer, "card-footer")
    } else {
      tags$div(class = "card-footer", footer)
    }
  }

  tags$div(
    class = "card",
    header,
    body,
    footer
  )
}

#' @rdname card
#' @export
#' @examples
#'
#' deck(
#'   card(
#'     title = "Nullam tristique",
#'     "Fusce sagittis, libero non molestie mollis, magna orci ultrices dolor, at vulputate neque nulla lacinia eros.",
#'     "Nunc rutrum turpis sed pede.",
#'     footer = "Cras placerat accumsan nulla."
#'   ),
#'   card(
#'     title = "Integer placerat",
#'     "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec hendrerit tempor tellus.",
#'     footer = "Cras placerat accumsan nulla."
#'   ),
#'   card(
#'     title = "Phasellus neque",
#'     "Donec at pede. Etiam vel neque nec dui dignissim bibendum.",
#'     footer = "Cras placerat accumsan nulla."
#'   )
#' )
#'
deck <- function(...) {
  tags$div(
    class = "card-deck",
    ...
  )
}
