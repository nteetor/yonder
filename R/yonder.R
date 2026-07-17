#' @importFrom htmltools HTML
#' @importFrom htmltools htmlDependency
#' @importFrom htmltools attachDependencies
#' @importFrom htmltools suppressDependencies
#' @importFrom htmltools resolveDependencies
#' @importFrom htmltools findDependencies
#' @importFrom htmltools tags
#' @importFrom htmltools div
#' @importFrom htmltools tagAppendAttributes
#' @importFrom htmltools tagAppendChildren
#' @importFrom htmltools surroundSingletons
#' @importFrom htmltools takeSingletons
#' @importFrom shiny observe
#' @importFrom shiny getDefaultReactiveDomain
#' @importFrom shiny installExprFunction
#' @importFrom shiny createRenderFunction
#' @importFrom shiny createWebDependency
#' @import rlang
NULL

#' A shiny framework
#'
#' Yonder is a set of tools for flexible and creative shiny application
#' construction and design.
#'
#' @section Getting started:
#'
#' ## Inputs
#'
#' Yonder provides many familiar inputs like [input_select()] or
#' [input_radio_group()]. There are also new inputs like [input_text_group()] or
#' [input_form()].
#'
#' * Input functions have an `id` argument instead of `inputId`.
#'
#' * Input functions do not include a `label` argument for the purpose of adding
#'   a label above the input. Button and menu inputs do include a `label`
#'   argument, but these arguments refer to button labels. If you would like to
#'   add a label above an input please use [formGroup()].
#'
#' ### Looking for ... ?
#'
#' * `actionButton()` or `actionLink()` use [input_button()] or [input_link()]
#'
#' * `radioButtons()` use [input_radio_group()]
#'
#' * `checkboxGroupInput()` use [input_checkbox_group()] or [input_checkbox()]
#'
#' * `numericInput()` use [input_numeric()]
#'
#' * `selectizeInput()` use [input_select()] or [input_multi_select()]
#'
#' * `submitButton()` use [input_form()] and [form_submit_button()]
#'
#' @name yonder
"_PACKAGE"
