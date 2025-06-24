#' Checkbox button
#'
#' A checkbox appearing as a button.
#'
#' @param id A string.
#'
#' @param choices A list.
#'
#' @param values A list. Defaults to `choices`.
#'
#' @param selected The default selected value or `NULL`.
#'
#' @family inputs
#' @export
input_checkbutton <- function(
    id,
    choices,
    values = choices,
    selected = NULL,
    ...
) {

  checkbuttons <-
    checkbutton_build(choices, values, selected)

  tag <-
    tags$div(
      id = id,
      class = "bsides-checkbutton",
      checkbuttons,
      ...
    )


  tag <-
    dependency_append(tag)

  tag
}

checkbutton_build <- function(
    choices,
    values,
    selected
) {

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      id <- generate_id("checkbox")

      list(
        tags$input(
          type = "checkbox",
          class = "btn-check",
          id = id,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        tags$label(
          class = "btn btn-primary",
          `for` = id,
          choice
        )
      )
    }
  )
}

checkbutton_handler <- function(
    value,
    session,
    name
) {
  value <- unlist(value, FALSE, TRUE)

  if (length(value) < 1 || !any(value)) {
    return(NULL)
  }

  value
}