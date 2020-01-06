#' @importFrom htmltools HTML htmlDependency attachDependencies
#'   suppressDependencies resolveDependencies findDependencies tags div
#'   tagAppendAttributes tagAppendChildren surroundSingletons takeSingletons
#' @importFrom shiny observe getDefaultReactiveDomain installExprFunction
#'   createRenderFunction createWebDependency
#' @importFrom lifecycle deprecate_soft deprecated
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
#' Yonder provides many familiar inputs like [selectInput()] or [radioInput()].
#' There are also new inputs like [groupTextInput()] or [formInput()].
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
#' * `actionButton()` or `actionLink()` use [buttonInput()] or [linkInput()]
#'
#' * `radioButtons()` use [radioInput()]
#'
#' * `checkboxGroupInput()` use [checkbarInput()] or [checkboxInput()]
#'
#' * `numericInput()` use [numberInput()]
#'
#' * `selectizeInput()` use [selectInput()] or [chipInput()]
#'
#' * `submitButton()` use [formInput()] and [formSubmit()]
#'
#' ## Layout and content
#'
#' Included are a handful of utilities for building applications suited for
#' devices and screens of varying sizes. For real control over spacing elements
#' be sure to check out [flex()], which gives you the power of flexbox layout.
#'
#' ### Looking for ... ?
#'
#' * `fluidRow()` or `fixedRow()` use [columns()]
#'
#' * `fixedPage()`, `fluidPage()`, or `sidebarLayout()` use [container()],
#'   [columns()], and [column()]
#'
#' * `navbarPage()` use [navbar()]
#'
#' * `tabPanel()` use [navContent()] and [navPane()]
#'
#' * `modalDialog()` use [modal()]
#'
#' @name yonder
"_PACKAGE"
