#' Grid System and Responsive Layout
#'
#' Flexbox, grid layout, containers, rows, and columns (oh my). Arguments `width` and
#' `order` can be applied depending on the width of the page, see the details
#' section for more information.
#'
#' @param ... Child elements of the `container`, `row`, or `col` parent element
#'   or additional named arguments passed as HTML attributes or additional
#'   classes to the respective parent element.
#'
#' @param width 1 through 12 or `"auto"`, defaults to `NULL`, alternate widths
#'   for different viewports may be specified using a named multi-length vector
#'   or list, see details section.
#'
#'   If the width of multiple columns totals more than 12, columns are greedily
#'   wrapped into multiple rows.
#'
#'   If **`"auto"`**, then the column fits to the width of the content.
#'
#'   If **`NULL`**, the column will fit to its parent container. When multiple
#'   columns have a `NULL` width, the parent element width is divided equally
#'   amongst all such columns. For example, two columns for which `width` is
#'   `NULL` will split their parent container's width equally in two.
#'
#' @param offset 1 through 12, defaults to `NULL`, alternate offsets for
#'   different viewports may be specified using a named multi-length vector
#'   or list, see details section. Use `offset` to move columns to the right by
#'   increasing the left margin of the column.
#'
#' @param align Vertical alignment of a row's columns or a particular column,
#'   one of `"start"`, `"center"`, or `"end"`, defaults to `NULL` in which case
#'   no vertical alignment is applied.
#'
#'   If **`"start"`**, the column or children columns align to top of row.
#'
#'   If **`"center"`**, the column or children columns align to middle of row.
#'
#'   If **`"end"`**, the column or children columns align to bottom of row.
#'
#' @param order One of `"first"`, `"last"`, or `"unordered"`, defaults to
#'   `NULL`. A column marked as `"first"` is *visually* rearranged and appears
#'   as the first column in its row. A column marked as `"last"` is *visually*
#'   rearranged and appears as the last column in its row.
#'
#' @param fluid If `TRUE`, the container is a fluid container and fits to the
#'   entire width of the viewport, defaults to `TRUE`.
#'
#' @details
#'
#' One can specify alternate column offsets or widths for different viewports by
#' using the following naming convention. A specific offset or width will be
#' applied when the viewport is **at least** the corresponding size, see below.
#'
#' - **unnamed**, applies to all viewports.
#'
#' - **`sm`**, at least 576 pixels wide.
#'
#' - **`md`**, at least 768 pixels wide.
#'
#' - **`lg`**, at least 992 pixels wide.
#'
#' - **`xl`**, at least 1200 pixels wide.
#'
#' See examples for more on how to make use of this functionality.
#'
#' @seealso
#'
#' For more information on and examples of containers, rows, and the grid
#' layout, please refer to the bootstrap
#' [grid system page](https://v4-alpha.getbootstrap.com/layout/grid).
#'
#' @export
#' @examples
#' # A column that,
#' #   - always has a width of 3
#' #   - is always offset by 3
#' col(
#'   width = 3,
#'   offset = 3
#' )
#'
#' # A column that,
#' #   - when viewport is small width is 2 and no offset
#' #   - when viewport is large width is 4 and offset is 3
#' col(
#'   width = c(sm = 2, lg = 4),
#'   offset = c(sm = 0, lg = 3)
#' )
#'
#' # A column that,
#' #   - always fits to its content
#' #   - has no offset up to medium
#' #   - when the viewport is medium offset is 2
#' #   - when the viewport is large offset is 3
#' #   - when the viewport is extra large offset is 5
#' col(
#'   width = "auto",
#'   offset = c(md = 2, lg = 3, xl = 5)
#' )
#'
#' # A column that,
#' #   - is 12 units wide (full width of parent) until medium viewport
#' #   - at medium viewport the column fits to the content
#' col(
#'   width = c(12, md = "auto")
#' )
#'
col <- function(..., width = NULL, offset = NULL, align = NULL, order = NULL) {
  tags$div(
    class = collate(
      "col",
      vapply(
        seq_along(width),
        function(i) {
          nm <- names2(width[i])
          when <- if (nm %in% c("", "xs")) NULL else nm

          collate("col", when, width[[i]], collapse = "-")
        },
        character(1)
      ),
      vapply(
        seq_along(offset),
        function(i) {
          nm <- names2(offset[i])
          when <- if (nm %in% c("", "xs")) NULL else nm

          collate("offset", when, offset[[i]], collapse = "-")
        },
        character(1)
      ),
      if (!is.null(order)) paste0("flex-", order),
      if (!is.null(align)) paste0("align-self-", align)
    ),
    ...,
    bootstrap()
  )
}

#' @param justify Horizontal alignment of row columns, one of `"start"`,
#'   `"end"`, `"center"`, `"between"`, or `"around"`, defaults to `NULL` in
#'   which case no horizontal alignment is applied.
#'
#'   If **`"start"`**, children columns align to left side of row.
#'
#'   If **`"end"`**, children columns align to right side of row.
#'
#'   If **`"center"`**, children columns align to center side of row.
#'
#'   If **`"between"`**, children columns are spread out equally across the width of
#'   the row, columns on the far left and right are flush with the edge of
#'   the row.
#'
#'   If **`"around"`**, children columns are spread equally across the width of the
#'   container, padding is added between columns and the edges of the parent row.
#'
#' @param gutters Defaults to `TRUE`, children columns receive horizontal
#'   padding for aesthetic spacing, to remove this padding specify `gutters` as
#'   `FALSE`.
#'
#' @rdname col
#' @export
row <- function(..., align = NULL, justify = NULL, gutters = TRUE) {
  if (!is.null(align) && !(align %in% c("start", "center", "end"))) {
    stop(
      'row `align` must be one of "start", "center", or "end"',
      call. = FALSE
    )
  }

  if (!is.null(justify) &&
      !(justify %in% c("start", "center", "end", "around", "between"))) {
    stop(
      'row argument `justify` must be one of "start", "center", "end", ',
      '"around", or "between"',
      call. = FALSE
    )
  }

  if (!is.null(align)) {
    align <- sprintf("align-items-%s", align)
  }

  if (!is.null(justify)) {
    justify <- sprintf("justify-content-%s", justify)
  }

  tags$div(
    class = collate(
      "row",
      align,
      justify,
      if (!gutters) "no-gutters"
    ),
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
    bootstrap()
  )
}
