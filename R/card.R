#' Cards, blocks of content
#'
#' Create blocks of content with `card`. `deck` is used to group and add padding
#' is placed around any number of cards. Additionally, grouping cards with
#' `deck` has the benefit of aligning the footer of each card.
#'
#' @param ... For **card**, `div()`s, tag elements, or list groups to include in
#'   the card or additional named arguments passed as HTML attributes to the
#'   card element.
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
#' @includeRmd man/roxygen/card.Rmd
#'
#' @family components
#' @export
card <- function(..., header = NULL, footer = NULL) {
  with_deps({
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

    card_mask <- list(
      p = function(...) tags$p(class = "card-text", ...),
      h1 = function(...) tags$h1(class = "card-title", ...),
      h2 = function(...) tags$h2(class = "card-title", ...),
      h3 = function(...) tags$h3(class = "card-title", ...),
      h4 = function(...) tags$h4(class = "card-title", ...),
      h5 = function(...) tags$h5(class = "card-title", ...),
      h6 = function(...) tags$h6(class = "card-subtitle", ...),
      a = function(...) tags$a(class = "card-link", ...),
      linkInput = function(...) linkInput(class = "card-link", ...)
    )

    args <- style_dots_eval(
      ...,
      .style = style_pronoun("yonder_card"),
      .mask = card_mask
    )

    is_named <- names2(args) != ""

    attrs <- args[is_named]
    args <- args[!is_named]

    grouped <- reduce(args, function(acc, arg) {
      if (is_tag(arg) && tag_class_re(arg, "row|list-group")) {
        acc[[length(acc) + 1]] <- arg
        acc[length(acc) + 1] <- list(NULL)
      } else {
        acc[[length(acc)]] <- c(acc[[length(acc)]], list(arg))
      }

      acc
    }, init = list(NULL))

    body <- lapply(grouped, function(grp) {
      if (is_bare_list(grp)) {
        div(class = "card-body", grp)
      } else {
        grp
      }
    })

    tag <- div(
      class = "card",
      !!!attrs,
      !!!drop_nulls(list2(
        header,
        !!!body,
        footer
      ))
    )

    s3_class_add(tag, "yonder_card")
  })
}

#' @rdname card
#' @export
deck <- function(...) {
  with_deps({
    tags$div(class = "card-deck", ...)
  })
}
