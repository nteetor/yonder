#' @importFrom htmltools HTML htmlDependency attachDependencies
#'   suppressDependencies resolveDependencies findDependencies tags
#'   tagAppendAttributes tagAppendChildren surroundSingletons takeSingletons
#' @importFrom shiny observe getDefaultReactiveDomain installExprFunction
#'   createRenderFunction createWebDependency
#' @importFrom rlang dots_list
NULL

#' A new approach to shiny applications
#'
#' Yonder is a set of tools for flexible and creative shiny application design.
#'
#' @section Inputs:
#'
#' Yonder provides many familiar inputs like [selectInput()] or [radioInput()].
#' There are also new inputs like [groupInput()] or [formInput()].
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
#' * `shiny::sliderInput()` has been split into three inputs: [rangeInput()],
#'   [intervalInput()], and [sliderInput()].
#'
#' **Familiar variants**
#'
#' Looking for ... ?
#'
#' * `radioButtons()` use [radioInput()]
#'
#' * `checkboxGroupInput()` use [checkbarInput()]
#'
#' * `numericInput()` use [numberInput()]
#'
#' * `submitButton()` use [submitInput()]
#'
#' * `updateRadioButtons()`, `updateTextInput()`, etc. use [updateInput()]
#'
#' @section Layout:
#'
#' Included are a handful of tools for building applications for devices and
#' screens of varying sizes. For real control over spacing elements be sure to
#' check out [flex()], which gives you the power of flexbox layout.
#'
#' **Familiar variants**
#'
#' Looking for ... ?
#'
#' * `fluidRow()` use [row()]
#'
#' * `fixedPage()`, `fluidPage()`, or `sidebarLayout()` use [container()],
#'   [row()], and [column()]
#'
#' * `navbarPage()` use [navbar()]
#'
"_PACKAGE"
