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
#' For example, a [listGroupInput] may be used to display series of items, but by
#' passing an `id` attribute the `listGroup` still displays a series of items
#' can function similar to shiny `checkboxGroupInput`.
#'
#' **What is the `bs` object?**
#'
#' Similar to the `tags` object in `htmltools`, the `inputs` object bundles
#' together many HTML form input elements. Functions like `textInput` and
#' `selectInput` are similar to shiny's `textInput` and `selectInput`.
#' Additionally, there are new, specific inputs like `datetimeInput`,
#' `colorInput`, and more.
#'
#' The `bs` object bundles together builder functions, like those found in
#' `tags`, which have received distinct parameters corresponding to
#' functionality provided by the bootstrap library.
#'
#' @importFrom shiny getDefaultReactiveDomain
#'
#' @name dull
"_PACKAGE"
