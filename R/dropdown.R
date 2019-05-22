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
#' @family components
#' @export
#' @examples
#'
#' ### Dropdown with buttons
#'
#' dropdown(
#'   label = "Choices",
#'   buttonInput("choice1", "Choice 1"),
#'   buttonInput("choice2", "Choice 2"),
#'   buttonInput("choice3", "Choice 3")
#' )
#'
#' ### Dropdown with links
#'
#' dropdown(
#'   label = "Choices",
#'   linkInput("link1", "Choice 1"),
#'   linkInput("link2", "Choice 2")
#' )
#'
#' ### Grouped sections
#'
#' dropdown(
#'   label = "Sections",
#'   h6("Section 1"),
#'   buttonInput("a", "Option A"),
#'   buttonInput("b", "Option B"),
#'   hr(),
#'   h6("Section 2"),
#'   buttonInput("c", "Option C"),
#'   buttonInput("d", "Option D")
#' )
#'
#' ### Direction variations
#'
#' dropdown(
#'   label = "Up!",
#'   direction = "up",
#'   buttonInput("up1", "Choice 1"),
#'   buttonInput("up2", "Choice 2")
#' )
#'
#' ### Dropdowns with forms
#'
#' dropdown(
#'   label = "Sign in",
#'   formInput(
#'     id = "login",
#'     formGroup(
#'       label = "Username / Email",
#'       textInput(
#'         type = "email",
#'         id = "user"
#'       )
#'     ),
#'     formGroup(
#'       label = "Password",
#'       textInput(
#'         type = "password",
#'         id = "pass"
#'       )
#'     ),
#'     formSubmit(
#'       label = "Sign in",
#'       value = "signin"
#'     )
#'   ) %>%
#'     padding(3, 4, 3, 4)
#' )
#'
dropdown <- function(label, ..., direction = "down", align = "left") {
  assert_possible(direction, c("up", "right", "down", "left"))
  assert_possible(align, c("right", "left"))

  args <- eval(substitute(alist(...)))

  formatted_tags <- list(
    h6 = function(...) tags$h6(class = "dropdown-header", ...),
    hr = function(...) tags$div(class = "dropdown-divider", ...),
    formInput = function(...) formInput(...)
  )

  items <- lapply(
    unnamed_values(args),
    eval,
    envir = list2env(formatted_tags, envir = parent.frame())
  )

  items <- lapply(
    items,
    function(i) {
      if (tag_name_is(i, "a") || tag_name_is(i, "button")) {
        tag_class_add(i, "dropdown-item")
      } else {
        i
      }
    }
  )

  component <- tags$div(
    class = str_collate(
      "dropdown",
      paste0("drop", direction)
    ),
    tags$button(
      class = str_collate(
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
      class = str_collate(
        "dropdown-menu",
        if (align == "right") "dropdown-menu-right"
      ),
      items
    )
  )

  component <- tag_attributes_add(component, named_values(list(...)))

  attach_dependencies(component)
}
