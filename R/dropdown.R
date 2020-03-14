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
#' @includeRmd man/roxygen/dropdown.Rmd
#'
#' @family components
#' @export
dropdown <- function(label, ..., direction = "down", align = "left") {
  assert_found(label)
  assert_possible(direction, c("up", "right", "down", "left"))
  assert_possible(align, c("right", "left"))

  with_deps({
    dropdown_mask <- list(
      h6 = function(...) tags$h6(class = "dropdown-header", ...),
      hr = function(...) tags$div(class = "dropdown-divider", ...),
      linkInput = function(...) linkInput(class = "dropdown-item", ...),
      buttonInput = function(...) buttonInput(class = "dropdown-item", ...),
      formInput = function(...) formInput(...)
    )

    args <- style_dots_eval(
      ...,
      .style = style_pronoun("yonder_dropdown"),
      .mask = dropdown_mask
    )

    tag <- tags$div(
      class = str_collate(
        "dropdown",
        paste0("drop", direction)
      ),
      tags$button(
        class = str_collate(
          "btn",
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
        unnamed_values(args)
      )
    )

    tag <- tag_attributes_add(tag, named_values(args))

    s3_class_add(tag, "yonder_dropdown")
  })
}
