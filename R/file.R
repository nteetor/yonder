#' File inputs
#'
#' Upload files to the server.
#'
#' @inheritParams checkboxInput
#'
#' @param placeholder A character string specifying the text inside the file
#'   input, defaults to `"Choose file"`.
#'
#' @param browse A character string specifying the label of file input, defaults
#'   to `"Browse"`.
#'
#' @param multiple One of `TRUE` or `FALSE` specifying whether or not the user
#'   can upload multiple files at once, defaults to `TRUE`.
#'
#' @param accept A character vector of possible MIME types or file extensions,
#'   defaults to `NULL`, in which case any file type may be selected.
#'
#' @section **Example** uploading a file:
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
#' @family inputs
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
fileInput <- function(id, placeholder = "Choose file", browse = "Browse", ...,
                      multiple = TRUE, accept = NULL) {
  assert_id()

  if (!is.character(browse)) {
    stop(
      "invalid argument in `fileInput()`, `browse` must be a character string",
      call. = FALSE
    )
  }

  if (length(accept) > 1) {
    accept <- paste(accept, collapse = ",")
  }

  component <- tags$div(
    class = "yonder-file custom-file",
    id = id,
    tags$input(
      type = "file",
      class = "custom-file-input",
      accept = accept,
      multiple = if (multiple) NA,
      autocomplete = "off"
    ),
    tags$label(
      class = "custom-file-label",
      `data-browse` = browse,
      placeholder
    ),
    tags$div(
      class = "valid-feedback"
    ),
    tags$div(
      class = "invalid-feedback"
    ),
    ...
  )

  attach_dependencies(component)
}
