is_tag <- function(x) {
  inherits(x, "shiny.tag")
}

tag_extend_with <- function(x, pieces) {
  stopifnot(is_tag(x))

  x <- tag_children_add(x, unnamed_values(pieces))
  x <- tag_attributes_add(x, named_values(pieces))

  x
}

tag_children_add <- function(x, ...) {
  stopifnot(
    is_tag(x)
  )

  htmltools::tagQuery(x)$append(...)$allTags()
}

tag_attributes_add <- function(x, ...) {
  stopifnot(
    is_tag(x)
  )

  htmltools::tagQuery(x)$addAttrs(...)$allTags()
}

tag_class_add <- function(x, class) {
  stopifnot(
    is_tag(x)
  )

  htmltools::tagQuery(x)$addClass(class)$allTags()
}

tag_class_remove <- function(x, class) {
  stopifnot(
    is_tag(x)
  )

  htmltools::tagQuery(x)$removeClass(class)$allTags()
}
