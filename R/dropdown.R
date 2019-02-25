#' Dropdown menus
#'
#' Dropdown menus are a container for buttons, text, and form inputs. See
#' argument `...` for details on composing dropdown menus.
#'
#' @param label A character string specifying the label of the dropdown's
#'   button.
#'
#' @param ... Character strings or vectors, header tag elements, button inputs,
#'   or form inputs specifying the elements of the dropdown. These elements may
#'   be grouped into lists to create a menu with sections. `h6()` is the
#'   recommended heading level for menu headers. Character vectors are converted
#'   into paragraphs of text. To format menu text use `p()` and utility
#'   functions.
#'
#'   Additional named arguments are passed as HTML attributes to the parent
#'   element.
#'
#' @param direction One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
#'   the direction in which the menu opens, defaults to `"down"`.
#'
#' @param align One of `"left"` or `"right"` specifying which side of the button
#'   to align the dropdown menu to, defaults to `"left"`.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Simple options w/ buttons
#'
#' dropdown(
#'   label = "Choices",
#'   buttonInput("choice1", "Choice 1"),
#'   buttonInput("choice2", "Choice 2"),
#'   buttonInput("choice3", "Choice 3")
#' )
#'
#' ### Grouped sections
#'
#' dropdown(
#'   label = "Sections",
#'   list(
#'     h6("Section 1"),
#'     buttonInput("addA", "Add A"),
#'     buttonInput("addB", "Add B")
#'   ),
#'   list(
#'     h6("Section 2"),
#'     buttonInput("calcC", "Calculate C"),
#'     buttonInput("calcD", "Calculate D")
#'   )
#' )
#'
#' ### Direction variations
#'
#' div(
#'   lapply(
#'     c("up", "down", "left", "right"),
#'     function(d) {
#'       dropdown(
#'         label = d,
#'         direction = d,
#'         buttonInput(NULL, "Nam euismod"),
#'         buttonInput(NULL, "Nunc eleifend"),
#'         buttonInput(NULL, "Nullam eu")
#'       ) %>%
#'         margin(3)
#'     }
#'   )
#' ) %>%
#'   display("flex")
#'
#' ### Include forms
#'
#' dropdown(
#'   label = "Sign in",
#'   formInput(
#'     id = "login",
#'     formGroup(
#'       label = "Email address",
#'       textInput(
#'         id = "email",
#'         placeholder = "email@example.com"
#'       )
#'     ),
#'     formGroup(
#'       label = "Password",
#'       passwordInput(
#'         id = "password",
#'         placeholder = "*****"
#'       )
#'     ),
#'     submit = submitInput(
#'       label = "Sign in"
#'     )
#'   ) %>%
#'     padding(3, 4, 3, 4)
#' )
#'
dropdown <- function(label, ..., direction = "down", align = "left") {
  if (!re(direction, "up|right|down|left", len0 = FALSE)) {
    stop(
      "invalid `dropdown()` argument, `direction` must be one of ",
      '"up", "right", "down", or "left"',
      call. = FALSE
    )
  }

  if (!re(align, "left|right", len0 = FALSE)) {
    stop(
      "invalid `dropdown()` argument, `align` must be one of ",
      '"left" or "right"',
      call. = FALSE
    )
  }

  args <- list(...)

  items <- Reduce(
    x = lapply(elements(args), dropdownItem),
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

  this <- tags$div(
    class = collate(
      "dropdown",
      paste0("drop", direction)
    ),
    tags$button(
      class = collate(
        "btn",
        "btn-grey",
        "dropdown-toggle"
      ),
      type = "button",
      `data-toggle` = "dropdown",
      `aria-haspop` = "true",
      `aria-expanded` = "false",
      label
    ),
    tags$div(
      class = collate(
        "dropdown-menu",
        if (align == "right") "dropdown-menu-right"
      ),
      items
    )
  )

  this <- tagConcatAttributes(this, attribs(args))

  attachDependencies(
    this,
    yonderDep()
  )
}

dropdownItem <- function(base) {
  if (is_strictly_list(base)) {
    return(list(lapply(base, dropdownItem)))
  }

  if (is.character(base)) {
    return(tagAppendChildren(tags$p(class = "text-muted"), list = base))
  }

  if (tagIs(base, "p")) {
    return(base)
  }

  if (tagIs(base, c("h1", "h2", "h3", "h4", "h5", "h6"))) {
    return(tagAddClass(base, "dropdown-header"))
  }

  if (tagIs(base, "a") || tagIs(base, "button")) {
    cregex <- paste(.colors, collapse = "|")

    base <- tagDropClass(base, paste0("btn(-(", cregex, "))?"))
    base <- tagAddClass(base, "dropdown-item")

    return(base)
  }

  if (tagIs(base, "form")) {
    return(base)
  }

  stop(
    "invalid `dropdown()` argument, could not convert object of class ",
    class(base)[1], " into dropdown item",
    call. = FALSE
  )
}
