#' Progress bars
#'
#' Create simple or composite progress bars. To create a composite progress bar
#' pass multiple calls to `bar` to a progress output. Each `bar` component has
#' its own id, value, label, and attributes. Furthermore, utility functions may
#' be applied to individual bars for added customization.
#'
#' @param id A character string specifying the HTML id of a progress output.
#'
#' @param ... One or more `bar` elements passed to a progress output or named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @param value An integer between 0 and 100 specifying the initial value
#'   of a bar.
#'
#' @param label A character string specifying the label of a bar, defaults to
#'   `NULL`, in which case a label is not added.
#'
#' @param striped If `TRUE`, the progress bar has a striped gradient, defaults
#'   to `FALSE`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @family content
#' @export
#' @examples
#'
progressOutlet <- function(id, ...) {
  attachDependencies(
    tags$div(
      class = "yonder-progress progress",
      ...
    ),
    c(shinyDep(), yonderDep(), bootstrapDep())
  )
}

#' @rdname progressOutlet
#' @export
bar <- function(id, value, label = NULL, striped = FALSE, ...) {
  if (!is.character(id) && !is.null(id)) {
    stop(
      "invalid `bar` argument, `id` must be a character string or NULL",
      call. = FALSE
    )
  }

  value <- round(value)

  tags$div(
    class = collate(
      "progress-bar",
      if (striped) "progress-bar-striped"
    ),
    id = id,
    role = "progressbar",
    style = paste0("width: ", value, "%"),
    `aria-valuemin` = "0",
    `aria-valuemax` = "100",
    label,
    ...
  )
}

#' @rdname progressOutlet
#' @export
showBar <- function(id, bar,
                    session = getDefaultReactiveDomain()) {
  session$sendProgress(
    "yonder-progress",
    dropNulls(
      list(
        id = id,
        value = value,
        label = label
      )
    )
  )
}
