#' Placeholder
#'
#' A handy placeholder component.
#'
#' @param width A valid CSS width or number. Numbers are shorthand for
#'   percentages. The width of the placeholder.
#'
#' @param height A string. The height of the placeholder.
#'
#' @param container An [htmltools::tag] function.
#'
#' @param lines A number. The number of lines within the placeholder block.
#'
#' @param animate A string. An animation for the placeholders within the block.
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#'
#' placeholder()
#'
#' placeholder(height = "lg")
#'
#' card(
#'   class = "text-bg-info",
#'   card_body(
#'     card_title(placeholder()),
#'     placeholder_block(5)
#'   ),
#'   card_footer(
#'     placeholder_button(),
#'     placeholder(height = "xs")
#'   )
#' )
#'
#'
placeholder <- function(
  width = NULL,
  height = c("md", "xs", "sm", "lg"),
  container = htmltools::div
) {
  height <- arg_match(height)

  width <-
    placeholder_width(width)

  container(
    class = c(
      "placeholder",
      if (height != "md") sprintf("placeholder-%s", height)
    ),
    style = sprintf("width: %s", width)
  )
}

#' @rdname placeholder
#' @export
placeholder_button <- function(
  width = NULL
) {
  width <-
    placeholder_width(width)

  tags$a(
    class = "btn btn-primary disabled placeholder",
    style = sprintf("width: %s", width)
  )
}

#' @rdname placeholder
#' @export
placeholder_block <- function(
  lines = 3,
  width = NULL,
  height = c("md", "xs", "sm", "lg"),
  animate = c("none", "glow", "wave")
) {
  check_number_whole(lines)

  height <- arg_match(height)
  animate <- arg_match(animate)

  tags$div(
    class = if (animate != "none") sprintf("placeholder-%s", animate),
    replicate(
      lines,
      placeholder(width = width, height = height),
      simplify = FALSE
    )
  )
}

placeholder_width <- function(value) {
  if (is.null(value)) {
    sprintf("%s%%", sample(50:100, 1))
  } else if (is.numeric(value)) {
    sprintf("%s%%", value)
  } else {
    htmltools::validateCssUnit(value)
    value
  }
}
