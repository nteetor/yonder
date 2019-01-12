#' Upload user files
#'
#' Upload files to the server.
#'
#' @param placeholder A character string specifying the text inside the file
#'   input, defaults to `"Choose file"`.
#'
#' @param browse A character string specifying the label of file input, defaults
#'   to `"Browse"`.
#'
#' @param left,right A character string or button element placed prepended or
#'   appended respectively to the file input. For more information refer to
#'   [groupInput()].
#'
#'   Clicking on an element specified by `right` also opens the file input
#'   dialog.
#'
#' @param multiple One of `TRUE` or `FALSE` specifying whether or not the user
#'   can upload multiple files at once, defaults to `TRUE`.
#'
#' @param accept A character vector of possible MIME types or file extensions,
#'   defaults to `NULL`, in which case any file type may be selected.
#'
#' @details
#'
#' Be careful when adjusting the right or left margin of a file input. In the
#' current version of Bootstrap file inputs can be pushed off the side of a
#' page.
#'
#' @section Uploading a file:
#'
#' ```R
#' shinyApp(
#'   ui = container(
#'     fileInput("upload") %>%
#'       margin(0, "auto", 0, "auto")
#'   ),
#'   server = function(input, output) {
#'     observe({
#'       req(input$upload)
#'
#'       print(input$upload)
#'     })
#'   }
#' )
#' ```
#'
#' @template input
#' @export
#' @examples
#'
#' ### Standard file input
#'
#' fileInput(id = "file1")
#'
#' ### Adding a button
#'
#' fileInput(
#'   id = "file2",
#'   left = buttonInput("upload", "Upload") %>%
#'     background("green")
#' )
#'
#' ### Customizing text
#'
#' fileInput(
#'   id = "file3",
#'   placeholder = "Pick a file",
#'   browse = "Go go go!"
#' )
#'
fileInput <- function(id, placeholder = "Choose file", browse = "Browse",
                      left = NULL, right = NULL, ...,
                      multiple = TRUE, accept = NULL) {
  if (is_tag(left) && !tagIs(left, "button")) {
    stop(
      "invalid `fileInput()` argument, `left` must be a button element or ",
      "character string",
      call. = FALSE
    )
  }

  if (is_tag(right) && !tagIs(right, "button")) {
    stop(
      "invalid `fileInput()` argument, `right` must be a button element or ",
      "character string",
      call. = FALSE
    )
  }

  if (!is.character(browse)) {
    stop(
      "invalid `fileInput()` argument, `browse` must be a character string",
      call. = FALSE
    )
  }

  if (!is.null(left)) {
    left <- tags$div(
      class = "input-group-prepend",
      if (is_tag(left)) {
        left
      } else {
        tags$span(class = "input-group-text", left)
      }
    )
  }

  if (!is.null(right)) {
    right <- tags$div(
      class = "input-group-append",
      if (is_tag(right)) {
        right
      } else {
        tags$span(class = "input-group-text", right)
      }
    )
  }

  input <- tags$div(
    class = "yonder-file input-group",
    id = id,
    ...,
    left,
    tags$div(
      class = "custom-file",
      tags$input(
        type = "file",
        class = "custom-file-input",
        multiple = if (multiple) NA
      ),
      tags$label(
        class = "custom-file-label",
        `data-browse` = browse,
        placeholder
      ),
      tags$div(
        class = "invalid-feedback"
      )
    ),
    right
  )

  attachDependencies(
    input,
    yonderDep()
  )
}
