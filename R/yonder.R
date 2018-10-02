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
#' * Input functions have an `id` argument instead of `inputId`.
#'
#' * Inputs do not include a `label` argument to add a text label. To add a
#'   label to an input please use [formGroup()].
#'
#' * `shiny::sliderInput()` has been split into three inputs: [rangeInput()],
#'   [intervalInput()], and [sliderInput()].
#'
#' @section Familiar variants:
#'
#' Looking for ...
#'
#' * `radioButtons()` use [radioInput()]
#'
#' * `fluidRow()` use [row()]
#'
#' * `fixedPage()`, `fluidPage()` or `sidebarLayout()` use [container()],
#'   [row()], and [column()]
#'
#' * `withProgress()` use [progressOutlet()]
#'
#' * `checkboxGroupInput()` use [checkbarInput()]
#'
#' * `updateRadioButtons()` or `updateTextInput()` use [updateChoices()] or
#'   [updateValues()]
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
