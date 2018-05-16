#' Flex layout direction
#'
#' Use the `direction()` and `reverse()` utilities to specify how a flex
#' element's children are placed. By default, browsers will place items
#' horizontally. Changing the flex direction changes how [justify()] and .
#'
#' @param tag A tag element.
#'
#' @param default One of `"row"` or `"column"` specifying the default placement
#'   of an element's flex items.
#'
#' @param sm Like `default`, but the placement is applied once the viewport is
#'   576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the placement is applied once the viewport is
#'   768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the placement is applied once the viewport is
#'   992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the placement is applied once the viewport is
#'   1200 pixels wide, think large desktop.
#'
#' @section Rows:
#'
#' Because horizontal placement the browser default you may not often use
#' `direction(.., "row")`.  The responsive arguments are potentially more
#' useful. Take the following example. On small screens the flex items are
#' placed vertically and can occupy the full width of the device. On medium
#' screens and up the items are placed horizontally once again.
#'
#' ```
#' div(
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border(),
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border(),
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border()
#' ) %>%
#'   display("flex") %>%
#'   direction("column", md = "row") %>%
#'   background("grey") %>%
#'   border()
#' ```
#'
#' @section Columns:
#'
#' Here is an example of a flex element with its children placed into columns.
#'
#' ```
#' div(
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border(),
#'    div("A flex item") %>%
#'     padding(3) %>%
#'      border(),
#'     div("A flex item") %>%
#'     padding(3) %>%
#'       border()
#' ) %>%
#'   display("flex") %>%
#'   direction("column")
#' ```
#'
#' @family flex
#' @export
#' @examples
#'
direction <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                      xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  classes <- responsives("flex", args, c("row", "column"))

  tagAddClass(tag, collate(classes))
}

#' @family flex
#' @rdname direction
#' @export
reverse <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  classes <- responsives("flex", args, c("row", "column"))

  classes <- paste0(classes, "-reverse")

  tagAddClass(tag, collate(classes))
}

#' Flex layout main axis
#'
#' The `justify()` function allows you to control how elements or flex items
#' inside a flex element are aligned along the main axis. For more on the main
#' and cross axis see below.
#'
#' @param tag A tag element.
#'
#' @param default One of `"start"`, `"end"`, `"center"`, `"between"` or
#'   `"around"` specifying the default alignment of the element's flex items.
#'
#' @param sm Like `default`, but the alignment is applied once the viewport is
#'   576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the alignment is applied once the viewport is
#'   768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the alignment is applied once the viewport is
#'   992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the alignment is applied once the viewport is
#'   1200 pixels wide, think large desktop.
#'
#' @details
#'
#' The diagrams below demonstrate how `justify()` changes the alignment of flex
#' items.
#'
#' `"start"`
#'
#' * `| Item 1 | Item 2 | Item 3 | ============= |`
#'
#' `"end"`
#'
#' * `| ============= | Item 1 | Item 2 | Item 3 |`
#'
#' `"center"`
#'
#' * `| ===== | Item 1 | Item 2 | Item 3 | ===== |`
#'
#' `"between"`
#'
#' * `| Item 1 | ===== | Item 2 | ===== | Item 3 |`
#'
#' `"around"`
#'
#' * `| = | Item 1 | = | Item 2 | = | Item 3 | = |`
#'
#' @section Main and cross axis:
#'
#'
#' @family flex
#' @export
#' @examples
#' lapply(1:5, tags$div) %>%
#'   tags$div() %>%
#'   display("flex") %>%
#'   content("center")
#'
justify <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  classes <- responsives(
    "justify-content", args, c("start", "end", "center", "between", "around")
  )

  tagAddClass(tag, collate(classes))
}

#' Flex layout, cross axis alignment
#'
#' The `items()` utility function applies Bootstrap classes to a tag element in
#' order to change the cross axis alignment of its flex items. The element must
#' must use a flex display. To change the display property of a tag, see
#' [display()] for more information.
#'
#' @param tag A tag element.
#'
#' @param default One of `"start"`, `"end"`, `"center"`, `"baseline"` or
#'   `"stretch"` specifying the default cross axis alignment of the element's
#'   flex items.
#'
#' @param sm Like `default`, but the alignment is applied once the viewport is
#'   576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the alignment is applied once the viewport is
#'   768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the alignment is applied once the viewport is
#'   992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the alignment is applied once the viewport is
#'   1200 pixels wide, think large desktop.
#'
#' @details
#'
#' When the flex direction is row, see [direction], the cross axis is the
#' y-axis. When the flex direction is column, see [direction], the cross axis is
#' the x-axis. The default direction is row. In this case, use `items` to
#' control where flex items are placed vertically within the tag element.
#'
#' @section Alignments:
#'
#' **`"start"`**, flex items are aligned at the top of the parent element.
#'
#' ```
#' | Item 1 | Item 2 | Item 3 | ============= |
#' |        |        |        |               |
#' |        |        |        |               |
#' ```
#'
#' **`"end"`**, flex items are aligned at the bottom of the parent element.
#'
#' ```
#' |        |        |        |               |
#' |        |        |        |               |
#' | Item 1 | Item 2 | Item 3 | ============= |
#' ```
#'
#' **`"center"`**, flex items are aligned at the center of the parent element.
#'
#' ```
#' |        |        |        |               |
#' | Item 1 | Item 2 | Item 3 | ============= |
#' |        |        |        |               |
#' ```
#'
#' **`"baseline"`**, flex items are aligned by font size.
#'
#' ```
#' | Item 1 | Item 2 | Item 3 | ============= |
#' |        |        |        |               |
#' |        |        |        |               |
#' ```
#'
#' **`"stretch"`**, flex items stretch to fill the height of their parent
#' element. This is the browser defalut.
#'
#' ```
#' | It     | It     | It     | ============= |
#' |   em   |   em   |   em   |               |
#' |      1 |      2 |      3 |               |
#' ```
#'
#' @family flex
#' @export
#' @examples
#'
align <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                  xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  classes <- responsives(
    "align-items", args, c("start", "end", "center", "baseline", "stretch")
  )

  tagAddClass(tag, collate(classes))
}

#' Wrapping flex items
#'
#' This function applies bootstrap classes to a tag element to change how the
#' element's flex items wrap or do not wrap. By default items will not wrap
#' onto new lines. See the *Wrapping* section below for more information on
#' the possible wrapping behaviors.
#'
#' @param tag A tag element.
#'
#' @param default One of `"nowrap"`, `"wrap"`, or `"reverse"` specifying how the
#'   flex items of an element wrap.
#'
#' @param sm Like `default`, but the wrapping behavior is applied once the
#'   viewport is 576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the wrapping behavior is applied once the
#'   viewport is 768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the wrapping behavior is applied once the
#'   viewport is 992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the wrapping behavior is applied once the
#'   viewport is 1200 pixels wide, think large desktop.
#'
#' @section Wrapping:
#'
#' **`"nowrap"`**, flex items do not wrap onto a new line and will extend
#' beyond the boundaries of the parent element. This is the browser default.
#'
#' ```
#' | Item | Item | Item | Item | Item | Item |
#' | 1    | 2    | 3    | 4    | 5    | 6    |
#' ```
#'
#' **`"wrap"`**, flex items will wrap onto a new line.
#'
#' ```
#' | Item 1 | Item 2 | Item 3 | Item 4 | === |
#' | Item 5 | Item 6 | ===================== |
#' ```
#'
#' **`"reverse"`**, rows of flex items appear in reverse order wrapping from the
#' bottom of the parent element up.
#'
#' ```
#' | Item 5 | Item 6 | ===================== |
#' | Item 1 | Item 2 | Item 3 | Item 4 | === |
#' ```
#'
#' @family flex
#' @export
#' @examples
#' # Make sure to try resizing the browser or viewer window after running
#' # the following examples.
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tags$p("No wrap") %>%
#'             font(style = "italics"),
#'           lapply(
#'             1:15,
#'             . %>%
#'               paste("Flex item", .) %>%
#'               tags$div() %>%
#'               width(25) %>%
#'               border()
#'           ) %>%
#'             tags$div() %>%
#'             width(100) %>%
#'             display("flex")
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
#'         col(
#'           tags$p("wrap") %>%
#'             font(style = "italics"),
#'           lapply(
#'             1:15,
#'             . %>%
#'               paste("Flex item", .) %>%
#'               tags$div() %>%
#'               width(25) %>%
#'               border()
#'           ) %>%
#'             tags$div() %>%
#'             width(100) %>%
#'             display("flex") %>%
#'             wrap("wrap")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
wrap <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                 xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  args <- lapply(
    args,
    function(a) switch(a, reverse = "wrap-reverse", a)
  )

  classes <- responsives("flex", args, c("wrap", "nowrap", "wrap-reverse"))

  tagAddClass(tag, collate(classes))
}
