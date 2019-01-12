#' Grid layout
#'
#' These functions are the foundation of any application. Grid elements are
#' nested as follows: `container > row > column ~ column`. Columns may be nested
#' within columns. Columns may be created with an explicit width, 1 through 12.
#' To fit a column automatically to its content use `width = "auto"`. To divide
#' the space in a row evenly amongst all columns leave `width` as `NULL`. For
#' examples and usage tips see the sections below.
#'
#' @param ... Any number of tags elements passed as child elements or named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @param width A [responsive] argument. One of `1:12` or `"auto"`, defaults to
#'   `NULL`.
#'
#' @param gutters One of `TRUE` or `FALSE` specifying if columns inside the row
#'   are padded, defaults to `TRUE`. If `FALSE` column content renders flush
#'   against the border of the column. Most often you will want to leave this
#'   `gutters` as `TRUE`.
#'
#' @param center One of `TRUE` or `FALSE` specifying if the container is
#'   responsively centered or if the container occupies the entire width of the
#'   viewport, defaults to `FALSE`.
#'
#' @family layout
#' @export
#' @examples
#'
#' ### Equal width columns
#'
#' container(
#'   row(
#'     column(
#'       "Aliquam erat volutpat."
#'     ),
#'     column(
#'       "Mauris mollis tincidunt felis."
#'     ),
#'     column(
#'       "Cum sociis natoque penatibus et magnis dis parturient montes,",
#'       "nascetur ridiculus mus."
#'     )
#'   )
#' )
#'
#' ###  Shiny's panel with sidebar layout
#'
#' container(
#'   row(
#'     column(
#'       width = 4,
#'       card(
#'         title = "Sidebar",
#'         formGroup(
#'           label = "Control 1",
#'           selectInput("control1", "...")
#'         ),
#'         formGroup(
#'           label = "Control 2",
#'           selectInput("control2", "...")
#'         ),
#'         formGroup(
#'           label = "Control 3",
#'           selectInput("control3", "...")
#'         )
#'       )
#'     ),
#'     column(
#'       d4("Main panel")
#'     )
#'   )
#' )
#'
#' ### Mobile friendly grids
#'
#' # Use `column()`s [responsive] `width` argument to make mobile friendly
#' # applications.
#'
#' container(
#'   row(
#'     column(
#'       width = c(sm = 4),
#'       "Mauris ac felis vel velit tristique imperdiet."
#'     ),
#'     column(
#'       width = c(sm = 4),
#'       "Nam vestibulum accumsan nisl."
#'     ),
#'     column(
#'       width = c(sm = 4),
#'       "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus."
#'     )
#'   )
#' )
#'
#' # or
#'
#' container(
#'   row(
#'     column(
#'       width = c(sm = 4),
#'       "Aenean in sem ac leo mollis blandit."
#'     ),
#'     column(
#'       width = c(sm = 8),
#'       "Nulla posuere. In id erat non orci commodo lobortis."
#'     )
#'   )
#' )
#'
#' ### Fit columns to their content
#'
#' container(
#'   row(
#'     column(),
#'     column(
#'       width = "auto",
#'       "Cras placerat accumsan nulla. Aenean in sem ac leo mollis blandit."
#'     ),
#'     column()
#'   )
#' )
#'
column <- function(..., width = NULL) {
  width <- ensureBreakpoints(width, c(1:12, "auto"))

  classes <- createResponsiveClasses(width, "col")

  if (!length(classes)) {
    classes <- "col"
  }

  attachDependencies(
    tagAddClass(tags$div(...), classes),
    yonderDep()
  )
}

#' @rdname column
#' @export
row <- function(..., gutters = TRUE) {
  attachDependencies(
    tags$div(
      class = collate(
        "row",
        if (!gutters) "no-gutter"
      ),
      ...
    ),
    yonderDep()
  )
}

#' @rdname column
#' @export
container <- function(..., center = FALSE) {
  attachDependencies(
    tags$div(
      class = if (center) "container" else "container-fluid",
      ...
    ),
    yonderDep()
  )
}
