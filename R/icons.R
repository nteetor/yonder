globalVariables("icons")

#' Icon elements
#'
#' Include icons in your application UIs.
#'
#' @param name A character string specifying the name of the icon.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param set A character string specifying the icon set to choose from,
#'   defaults to `"NULL"`, in which case all icon sets are searched.
#'
#'   Possibles values include `"font awesome"`, `"material design"`, and
#'   `"feather"`.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Font awesome
#'
#' icon("clone")
#'
#' ### Material design
#'
#' icon("mail", "material design")
#'
#' ### Feather
#'
#' icon("mail", "feather")
#'
icon <- function(name, set = NULL, ...) {
  if (length(name) != 1) {
    stop(
      "invalid `icon()` argument, `name` must be a single character string",
      call. = FALSE
    )
  }

  if (!is.null(set)) {
    if (length(set) != 1) {
      stop(
        "invalid `icon()` argument, if specified `set` must be a single ",
        "character string",
        call. = FALSE
      )
    }

    if (!(set %in% icons$set)) {
      stop(
        "invalid `icon()` argument, unknown icon set",
        '"', set, '"',
        call. = FALSE
      )
    }
  }

  index <- which(
    icons$name == name & if (!is.null(set)) icons$set == set else TRUE
  )

  if (!length(index)) {
    stop(
      'in `icon()`, no icon found with name "', name, '"',
      if (!is.null(set)) paste0(' in set "', set, '"'),
      call. = FALSE
    )
  }

  icon <- icons[index[1], ]

  if (icon$set == "font awesome") {
    tags$i(
      class = collate(
        icon$prefix,
        sprintf("fa-%s", icon$name),
        "fa-fw"
      ),
      ...,
      include("font awesome")
      # include font awesome(?)
    )
  } else if (icon$set == "material design") {
    tags$i(
      class = "material-icons",
      ...,
      icon$name,
      include("material icons")
    )
  } else if (icon$set == "feather") {
    tags$i(
      `data-feather` = icon$name,
      ...,
      tags$script("feather.replace()"),
      include("feather")
    )
  }
}

#' Icon data
#'
#' Data frame of icon sets, keywords, names, and additional meta information.
#'
#' @format A data frame with 3563 rows and 4 columns:
#'
#' \describe{
#' \item{set}{the icon family name}
#' \item{keyword}{a keyword to identify the icon by}
#' \item{name}{the name of the icon}
#' \item{prefix}{used by the font awesome family}
#' }
#'
#' @keywords internal
#' @examples
#' icons
"icons"
