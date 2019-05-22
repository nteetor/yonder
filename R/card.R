#' Cards, blocks of content
#'
#' Create blocks of content with `card`. `deck` is used to group and add padding
#' is placed around any number of cards. Additionally, grouping cards with
#' `deck` has the benefit of aligning the footer of each card.
#'
#' @param ... For **card**, `tag$div()`s, tag elements, or list groups to
#'   include in the card or additional named arguments passed as HTML attributes
#'   to the parent element.
#'
#'   For **deck**, any number of `card()`s or additional named arguments passed
#'   as HTML attributes to the parent element.
#'
#' @param header A character string or tag element specifying the header of the
#'   card, defaults to `NULL`, in which case a header is not added.
#'
#' @param footer A character string or tag element specifying the footer of the
#'   card, defaults to `NULL`, in which case a footer is not added.
#'
#' @family components
#' @export
#' @examples
#'
#' ### A simple card
#'
#' column(
#'   width = 4,
#'   card(
#'     p("Praesent fermentum tempor tellus.")
#'   )
#' )
#'
#' ### Adding a title, subtitle
#'
#' column(
#'   width = 4,
#'   card(
#'     h5("Mauris mollis tincidunt felis."),
#'     h6("Phasellus at dui in ligula mollis ultricies."),
#'     p("Nullam tempus. Mauris mollis tincidunt felis."),
#'     p("Nullam libero mauris, consequat quis, varius et, dictum id, arcu.")
#'   )
#' )
#'
#' ### Styling cards
#'
#' deck(
#'   card(
#'     header = "Donec pretium posuere tellus",
#'     p("Donec hendrerit tempor tellus."),
#'     p("Cras placerat accumsan nulla.")
#'   ) %>%
#'     font(color = "teal"),
#'   card(
#'     p("Aliquam posuere."),
#'     p("Phasellus neque orci, porta a, aliquet quis, semper a, massa."),
#'     p("Pellentesque dapibus suscipit ligula.")
#'   ) %>%
#'     border("orange"),
#'   card(
#'     header = "Phasellus lacus",
#'     p("Etiam laoreet quam sed arcu."),
#'     p("Etiam vel tortor sodales tellus ultricies commodo."),
#'     footer = "Nam euismod tellus id erat."
#'   ) %>%
#'     background("grey") %>%
#'     font(color = "indigo")
#' )
#'
#' ### Cards with list groups
#'
#' column(
#'   width = 4,
#'   card(
#'     listGroupInput(
#'       id = "lg1",
#'       flush = TRUE,
#'       choices = c(
#'         "Pellentesque tristique imperdiet tortor.",
#'         "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
#'         "Phasellus purus."
#'       ),
#'       values = c(
#'         "choice1",
#'         "choice2",
#'         "choice3"
#'       )
#'     )
#'   )
#' )
#'
#' ### Tabbed content in cards
#'
#' card(
#'   header = navInput(
#'     id = "tabs",
#'     choices = c("Tab 1", "Tab 2", "Tab 3"),
#'     appearance = "tabs"
#'   ),
#'   navContent(
#'     navPane(
#'       "Phasellus purus.",
#'       "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
#'       "Phasellus purus."
#'     ),
#'     navPane(
#'       "Donec at pede. Praesent augue.",
#'       "Pellentesque tristique imperdiet tortor."
#'     ),
#'     navPane(
#'       "Fusce suscipit, wisi nec facilisis facilisis,",
#'       "est dui fermentum leo, quis tempor ligula erat quis odio.",
#'       "Donec hendrerit tempor tellus."
#'     )
#'   )
#' )
#'
#' ### Deck of cards
#'
#' deck(
#'   card(
#'     title = "Nullam tristique",
#'     p("Fusce sagittis, libero non molestie mollis, magna orci ultrices ",
#'       "dolor, at vulputate neque nulla lacinia eros."),
#'     p("Nunc rutrum turpis sed pede."),
#'     footer = "Cras placerat accumsan nulla."
#'   ),
#'   card(
#'     title = "Integer placerat",
#'     p("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec ",
#'       "hendrerit tempor tellus."),
#'     footer = "Cras placerat accumsan nulla."
#'   ),
#'   card(
#'     title = "Phasellus neque",
#'     p("Donec at pede. Etiam vel neque nec dui dignissim bibendum."),
#'     footer = "Cras placerat accumsan nulla."
#'   )
#' )
#'
card <- function(..., header = NULL, footer = NULL) {
  args <- eval(substitute(alist(...)))

  if (!is.null(header)) {
    if (is_tag(header) && tag_class_re(header, "nav-tabs")) {
      header <- tags$div(
        class = "card-header",
        tag_class_add(header, "card-header-tabs")
      )
    } else if (is_tag(header) && tag_class_re(header, "nav-pills")) {
      header <- tags$div(
        class = "card-header",
        tag_class_add(header, "card-header-pills")
      )
    } else {
      header <- tags$div(class = "card-header", header)
    }
  }

  if (!is.null(footer)) {
    footer <- tags$div(class = "card-footer", footer)
  }

  formatted_tags <- list(
    p = function(...) tags$p(class = "card-text", ...),
    h1 = function(...) tags$h1(class = "card-title", ...),
    h2 = function(...) tags$h2(class = "card-title", ...),
    h3 = function(...) tags$h3(class = "card-title", ...),
    h4 = function(...) tags$h4(class = "card-title", ...),
    h5 = function(...) tags$h5(class = "card-title", ...),
    h6 = function(...) tags$h6(class = "card-subtitle", ...),
    linkInput = function(...) linkInput(class = "card-link", ...)
  )

  body <- lapply(
    unnamed_values(args),
    eval,
    envir = list2env(formatted_tags, envir = parent.frame())
  )

  body <- lapply(body, function(x) {
    if (is_strictly_list(x)) {
      tags$div(class = "card-body", x)
    } else {
      x
    }
  })

  if (any(!vapply(body, is_tag, logical(1)))) {
    stop(
      "invalid arguments in `card()`, all top-level arguments must be tag ",
      "elements",
      call. = FALSE
    )
  }

  flags <- vapply(body, tag_class_re, logical(1), regex = "row|list-group")

  if (!any(flags)) {
    body <- tags$div(class = "card-body", body)
  }

  component <- tags$div(
    class = "card",
    header,
    body,
    footer
  )

  component <- tag_attributes_add(component, named_values(list(...)))

  attach_dependencies(component)
}

#' @rdname card
#' @export
deck <- function(...) {
  attach_dependencies(
    tags$div(class = "card-deck", ...)
  )
}
