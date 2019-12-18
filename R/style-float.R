#' Float
#'
#' Use `float()` to float an element to the left or right side of its parent
#' element. A newspaper layout is a classic example where an image is floated
#' with text wrapped around.
#'
#' @param tag A tag element.
#'
#' @param side A [responsive] argument. One of `"left"` or `"right"` specifying
#'   the side to float the element.
#'
#' @family design utilities
#' @export
#' @examples
#'
#' ### Float an alert
#'
#' div(
#'   .style %>%
#'     padding(2),
#'   alert("This just in!") %>%
#'     margin(3) %>%
#'     background("warning") %>%
#'     float("left"),
#'   p("Fusce commodo. Nullam tempus. Nunc rutrum turpis sed pede.",
#'     "Phasellus lacus.  Cras placerat accumsan nulla.",
#'     "Fusce sagittis, libero non molestie mollis, ",
#'     "magna orci ultrices dolor, at vulputate neque nulla lacinia eros."),
#'   p("Nulla facilisis, risus a rhoncus fermentum, tellus tellus",
#'     "lacinia purus, et dictum nunc justo sit amet elit."),
#'   p("Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
#'     "Aliquam posuere.",
#'     "Sed id ligula quis est convallis tempor."),
#'   p("Fusce dapibus, tellus ac cursus commodo, ",
#'     "tortor mauris condimentum nibh, ut fermentum massa justo sit",
#'     "amet risus.")
#' )
#'
float <- function(tag, side) {
  UseMethod("float", tag)
}

#' @export
float.yonder_style_pronoun <- function(tag, side) {
  UseMethod("float.yonder_style_pronoun", tag)
}

#' @export
float.shiny.tag <- function(tag, side) {
  tag_class_add(tag, float_side(side))
}

#' @export
float.yonder_style_pronoun.default <- function(tag, side) {
  style_class_add(tag, float_side(side))
}

float_side <- function(side) {
  side <- resp_construct(side, c("left", "right"))
  resp_classes(side, "float")
}
