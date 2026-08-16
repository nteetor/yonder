is_tag <-
  function(x) {
    inherits(x, "shiny.tag")
  }

tag_extend_with <-
  function(x, pieces) {
    stopifnot(is_tag(x))

    x <- tag_children_add(x, unnamed_values(pieces))
    x <- tag_attributes_add(x, named_values(pieces))

    x
  }

tag_children_add <-
  function(x, ...) {
    stopifnot(
      is_tag(x)
    )

    htmltools::tagQuery(x)$append(...)$allTags()
  }

tag_attributes_add <-
  function(x, ...) {
    stopifnot(
      is_tag(x)
    )

    htmltools::tagQuery(x)$addAttrs(...)$allTags()
  }

tag_class_add <-
  function(x, class) {
    stopifnot(
      is_tag(x)
    )

    htmltools::tagQuery(x)$addClass(class)$allTags()
  }

tag_class_remove <-
  function(x, class) {
    stopifnot(
      is_tag(x)
    )

    htmltools::tagQuery(x)$removeClass(class)$allTags()
  }

# htmltools joins duplicate attributes with a space. That is correct for
# `class` and wrong for `style`: two style attributes render as
# 'style="color: red --x: 1rem"', one malformed declaration. Merge every
# style entry already on the tag, plus the declarations given here (passed
# through htmltools::css(), so NULL values drop out), into a single
# properly separated declaration list.
tag_style_add <-
  function(x, ...) {
    stopifnot(is_tag(x))

    declarations <- htmltools::css(...)

    if (is.null(declarations)) {
      return(x)
    }

    is_style <- names2(x$attribs) == "style"
    existing <- unlist(x$attribs[is_style], use.names = FALSE)

    x <- htmltools::tagQuery(x)$removeAttrs("style")$allTags()

    htmltools::tagQuery(x)$addAttrs(
      style = style_join(c(existing, declarations))
    )$allTags()
  }

style_join <-
  function(x) {
    x <- trimws(as.character(x))
    x <- x[nzchar(x)]
    x <- sub(";\\s*$", "", x)

    paste0(paste(x, collapse = "; "), ";")
  }
