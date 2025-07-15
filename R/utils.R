# necessary for `createRenderFunction()`
globalVariables("func")

non_null <- function(x) {
  !is.null(x)
}

drop_nulls <- function(x) {
  if (length(x) == 0) {
    x
  } else {
    x[vapply(x, non_null, logical(1))]
  }
}

mapply2 <- function(f, ...) {
  args <- lapply(list(...), function(arg) {
    if (is.null(arg)) {
      list(NULL)
    } else {
      arg
    }
  })

  .mapply(f, args, NULL)
}

build_input_options <- function(
  f,
  choices,
  values,
  ...
) {
  stopifnot(
    length(choices) == length(values)
  )

  htmltools::tagList(
    !!!.mapply(
      f,
      list(choices, values),
      list(...)
    )
  )
}

wrap_items <- function(
  items,
  predicate,
  wrapper
) {
  needs_wrap <- !vapply(items, predicate, logical(1))

  if (!any(needs_wrap)) {
    return(items)
  }

  wrap_rle <- rle(needs_wrap)
  start_indeces <- c(1, head(cumsum(wrap_rle$lengths) + 1, -1))

  items <-
    Map(
      start = start_indeces,
      length = wrap_rle$length,
      wrap = wrap_rle$value,
      function(start, length, wrap) {
        subset_items <- items[start:(start + length - 1)]

        if (wrap) {
          list(wrapper(subset_items))
        } else {
          subset_items
        }
      }
    )

  unlist(items, recursive = FALSE)
}

str_conjoin <- function(x, con = "or") {
  if (length(x) == 1) {
    return(as.character(x))
  }

  if (length(x) == 2) {
    return(paste(x[1], con, x[2]))
  }

  paste0(paste(x[-length(x)], collapse = ", "), ", ", con, " ", x[length(x)])
}

str_collate <- function(..., collapse = " ") {
  args <- unique(c(...))

  if (is.null(args)) {
    return(NULL)
  }

  args <- args[nzchar(args) & !is_na(args)]

  if (length(args) == 0) {
    return(NULL)
  }

  paste(args, collapse = collapse)
}

str_re <- function(string, pattern, len0 = TRUE) {
  if (length(string) == 0) {
    return(len0)
  }

  grepl(paste0("^(?:", pattern, ")$"), string)
}

generate_id <- function(prefix) {
  paste(c(prefix, sample(1000, 2, TRUE)), collapse = "-")
}

keep_named <- named_values <- function(x) {
  x[rlang::names2(x) != ""]
}

keep_unnamed <- unnamed_values <- function(x) {
  x[rlang::names2(x) == ""]
}

s3_class_add <- function(x, new) {
  class(x) <- c(new, class(x))
  x
}

# https://github.com/rstudio/shiny/blob/c332c051f33fe325f6c2e75426daaabb6366d50a/R/html-deps.R#L43
dependency_process <- function(tags, session) {
  ui <- htmltools::takeSingletons(
    tags,
    session$singletons,
    desingleton = FALSE
  )$ui

  ui <- htmltools::surroundSingletons(ui)

  dependencies <- lapply(
    htmltools::resolveDependencies(htmltools::findDependencies(ui)),
    createWebDependency
  )
  names(dependencies) <- NULL

  list(
    html = htmltools::doRenderTags(ui),
    deps = dependencies
  )
}

is_breakpoints <- function(x) {
  inherits(x, "bslib_breakpoints")
}

get_current_session <- function() {
  shiny::getDefaultReactiveDomain()
}
