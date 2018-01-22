#' Grid system and responsive layout
#'
#' Build apps using the grid layout: containers, rows, and columns (oh my).
#'
#' @param ... Any number of child elements or named arguments passed as HTML
#'   attributes to the parent element. `row`s need to be placed inside a
#'   `container`. A `row` typically contains only `col`s. A `col` may contain
#'   other `col`s or other elements.
#'
#' @param tag A tag element, for `col` this is typically `tags$div()`.
#'
#' @param default A number 1 through 12 or `"auto"` specifying the default
#'   width of the column. Columns with width `"auto"` equally divide space or
#'   fill remaining space when used with other columns.
#'
#' @param sm Like `default`, but the width is applied once the viewport is 576
#'   pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the width is applied once the viewport is 768
#'   pixels wide, think tablets.
#'
#' @param lg Like `default`, but the width is applied once the viewport is 992
#'   pixels wide, think desktop.
#'
#' @param xl Like `default`, but the width is applied once the viewport is 1200
#'   pixels wide, think large desktop.
#'
#' @param fluid One of `TRUE` or `FALSE` specifying if the container occupies
#'   the entire width of the viewport, defaults to `TRUE`, in which case the
#'   container occupies the full width of the viewport.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col("1 of 2") %>%
#'           border(),
#'         col("2 of 2") %>%
#'           border()
#'       ),
#'       row(
#'         lapply(
#'           1:3,
#'           . %>%
#'             paste("of 3") %>%
#'             col() %>%
#'             border()
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col("1 or 3") %>%
#'           border(),
#'         col("2 of 3", default = 6) %>%
#'           border(),
#'         col("3 of 3") %>%
#'           border()
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
col <- function(..., default = NULL, sm = NULL, md = NULL, lg = NULL,
                xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  if (length(args) == 0) {
    return(tagEnsureClass(tags$div(...), "col"))
  }

  classes <- responsives(
    prefix = "col",
    values = args,
    possible = c(as.character(1:12), "auto")
  )

  classes <- sub("-(sm|md|lg|xl)-auto", "", classes)
  classes <- sort(unique(c("col", classes)))

  tagAddClass(tags$div(...), collate(classes))
}

#' @rdname col
#' @export
row <- function(...) {
  tags$div(
    class = "row",
    ...,
    bootstrap()
  )
}

#' @rdname col
#' @export
container <- function(..., fluid = TRUE) {
  tags$div(
    class = if (fluid) "container-fluid" else "container",
    ...,
    bootstrap(),
    `font-awesome`()
  )
}
