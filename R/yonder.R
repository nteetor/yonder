#' A new approach to shiny applications
#'
#' More freedom to the programmer, more to come.
#'
#' @importFrom htmltools htmlDependency attachDependencies suppressDependencies
#' @importFrom shiny observe getDefaultReactiveDomain tagAppendAttributes tags
#'   HTML installExprFunction createRenderFunction
#' @importFrom rlang dots_list
#'
#' @name yonder
"_PACKAGE"

#' Inputs
#'
#' Yonder provides many familiar inputs like [selectInput()] or [radioInput()].
#' There are also new inputs like [groupInput()] or [formInput()].
#'
#' @section Changes to be mindful of:
#'
#' * Included input functions have an `id` argument instead of `inputId`.
#'
#'   A `NULL` value may be used to add an input element without binding it, i.e.
#'   a value is not passed back to the shiny server.
#'
#' * Inputs do not include a `label` argument. To add a label to an input please
#'   use [formGroup()].
#'
#' @noRd
#' @family inputs
#' @name index
#' @layout index
NULL

#' Outputs
#'
#' Reactive outputs.
#'
#' @noRd
#' @family outputs
#' @name index
#' @layout index
NULL

#' Thruputs
#'
#' Yonder includes new reactive *thruputs*.
#'
#' @noRd
#' @family thruputs
#' @name index
#' @layout index
NULL
