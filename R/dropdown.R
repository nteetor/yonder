#' Dropdown input
#'
#' Dropdown inputs, or dropdown menus, a similar to form inputs. The dropdown
#' input has no value per say, but acts as an intelligent container for button
#' and form inputs.
#'
#' @param id A character string specifying the id of the dropdown input.
#'
#' @param label A character string specifying the label of the dropdown's
#'   button.
#'
#' @param ... Character strings or vectors, header tag elements, button inputs,
#'   or form inputs specifying the elements of the dropdown. These elements may
#'   be grouped into lists, in which case menu dividers are placed before,
#'   after, or between the lists of elements. `h6()` is the recommended heading
#'   level for menu headers. Character vectors are converted into paragraphs of
#'   text. To format menu text use `p()` and any utility functions instead.
#'   Named arguments are passed HTML attributes to the parent element.
#'
#' @param direction One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
#'   the direction in which the menu opens, defaults to `"down"`.
#'
#' @param split One of `TRUE` or `FALSE` specifying if the dropdown toggle button
#'   is split into two distinct buttons, defaults to `FALSE`. This is a stylistic
#'   modification which properly spaces the dropdown toggle icon and aligns the
#'   dropdown menu to the toggle icon.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           dropdownInput(
#'             id = NULL,
#'             label = "Dropdown",
#'             split = TRUE,
#'             formInput(
#'               id = NULL,
#'               submit = NULL,
#'               textInput(
#'                 id = "email",
#'                 placeholder = "email@example.com"
#'               ),
#'               textInput(
#'                 id = "password",
#'                 placeholder = "Password"
#'               )
#'             ) %>%
#'               padding(3),
#'             list(
#'               buttonInput(
#'                 id = "signup",
#'                 label = "New? Sign up"
#'               ),
#'               buttonInput(
#'                 id = "forgot",
#'                 label = "Forgot password?"
#'               )
#'             )
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("values")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$values <- renderPrint(
#'         list(
#'           email = input$email,
#'           password = input$password,
#'           signup = input$signup,
#'           forgot = input$forgot
#'         )
#'       )
#'     }
#'   )
#' }
#'
dropdownInput <- function(id, label, ..., direction = "down", split = FALSE) {
  if (!re(direction, "up|right|down|left", len0 = FALSE)) {
    stop(
      "invalid `dropdownInput` arguments, `direction` must be one of ",
      '"up", "right", "down", or "left"',
      call. = FALSE
    )
  }

  args <- dots_list(...)
  items <- elements(args)
  attrs <- attribs(args)

  tags$div(
    class = collate(
      "dull-dropdown-input",
      "btn-group",
      paste0("drop", direction)
    ),
    id = id,
    if (split) {
      tags$button(
        class = "btn btn-grey",
        label
      )
    },
    tags$button(
      class = collate(
        "btn",
        "btn-grey",
        "dropdown-toggle",
        if (split) "dropdown-toggle-split"
      ),
      type = "button",
      `data-toggle` = "dropdown",
      `aria-haspop` = "true",
      `aria-expanded` = "false",
      if (!split) label else tags$span(class = "sr-only", "Dropdown toggle")
    ),
    tags$div(
      class = "dropdown-menu",
      Reduce(
        x = lapply(items, dropdownItem),
        function(acc, obj) {
          if (is_tag(acc)) {
            acc <- list(acc)
          }

          if (is_strictly_list(acc[[length(acc)]]) ||
                is_strictly_list(obj)) {
            return(
              c(acc, list(tags$div(class = "dropdown-divider")), list(obj))
            )
          }

          return(c(acc, list(obj)))
        }
      )
    ),
    include("core")
  )
}

dropdownItem <- function(base) {
  if (is_strictly_list(base)) {
    return(list(lapply(base, dropdownItem)))
  }

  if (is.character(base)) {
    return(lapply(base, tags$p, class = "text-muted"))
  }

  if (tagIs(base, "p")) {
    return(base)
  }

  if (tagIs(base, paste0("h", 1:6))) {
    return(tagEnsureClass(base, "dropdown-header"))
  }

  if (tagIs(base, "a") || tagIs(base, "button")) {
    cregex <- paste(.colors, collapse = "|")

    base <- tagDropClass(base, paste0("btn(-", cregex, ")?"))
    base <- tagEnsureClass(base, "dropdown-item")

    return(base)
  }

  if (tagIs(base, "form")) {
    return(base)
  }

  stop(
    "problem converting object of class ", class(base)[1], " into ",
    "dropdown item",
    call. = FALSE
  )
}
