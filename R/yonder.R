#' @importFrom htmltools HTML htmlDependency attachDependencies
#'   suppressDependencies resolveDependencies findDependencies tags
#'   tagAppendAttributes tagAppendChildren surroundSingletons takeSingletons
#' @importFrom shiny observe getDefaultReactiveDomain installExprFunction
#'   createRenderFunction createWebDependency
NULL

#' A new approach to shiny applications
#'
#' Yonder is a set of tools for flexible and creative shiny application
#' construction and design.
#'
#' @section Inputs:
#'
#' Yonder provides many familiar inputs like [selectInput()] or [radioInput()].
#' There are also new inputs like [groupTextInput()] or [formInput()].
#'
#' **Changes to be mindful of**
#'
#' * Input functions have an `id` argument instead of `inputId`.
#'
#' * Input functions do not include a `label` argument for the purpose of adding
#'   a label above the input. Button and menu inputs do include a `label`
#'   argument, but these arguments refer to button labels. If you would like to
#'   add a label above an input please use [formGroup()].
#'
#' **Familiar variants**
#'
#' Looking for ... ?
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
#' @section Layout and content:
#'
#' Included are a handful of utilities for building applications suited for
#' devices and screens of varying sizes. For real control over spacing elements
#' be sure to check out [flex()], which gives you the power of flexbox layout.
#'
#' **Familiar variants**
#'
#' Looking for ... ?
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
"_PACKAGE"
