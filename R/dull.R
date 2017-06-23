#' A new approach to shiny applications
#'
#' More freedom to the programmer, more to come.
#'
#' @section Q and A:
#'
#' **Where are the input functions?**
#'
#' Unlike shiny, dull does not include explicit input functions. Instead an `id`
#' argument must be specified as an HTML attribute, passed to a function through
#' `...`. Once an `id` attribute is specified a reactive input value is
#' available.
#'
#' For example, a [listGroup] may be used to display series of items, but by
#' passing an `id` attribute the `listGroup` still displays a series of items
#' can function similar to shiny `checkboxGroupInput`.
#'
#' **What is the `inputs` object?**
#'
#' Similar to the `tags` object in `htmltools`, the `inputs` object bundles
#' together many HTML form input elements. Functions like `inputs$text` and
#' `inputs$select` are similar to shiny's `textInput` and `selectInput`. Additionally,
#' there are new, specific inputs like `inputs$datetime`, `inputs$color`, and
#' more.
#'
#' **Is there a checkboxGroupInput equivalent?**
#'
#' There is no dull equivalent of shiny's `checkboxGroupInput`.
#' `inputs$checkbox` is available and performs like `checkboxInput`. This choice
#' was made to increase the accessibility of shiny applications.
#'
#' An alternative to `checkboxGroupInput` is `listGroup`.
#'
#' @importFrom shiny getDefaultReactiveDomain
#'
#' @name dull
"_PACKAGE"
