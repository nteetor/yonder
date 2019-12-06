# necessary for `createRenderFunction()`
globalVariables("func")

# plain utils ----
`%||%` <- function(a, b) if (is.null(a)) b else a

encode_commas <- function(x) {
  gsub(",", "&#44;", x, fixed = TRUE)
}

is_strictly_list <- function(x) {
  length(class(x)) == 1 && class(x) == "list"
}

drop_nulls <- function(x) {
  if (length(x) == 0) {
    x
  } else {
    x[!vapply(x, is.null, logical(1))]
  }
}

# Included until rlang exports `is_present()`
is_present <- function(arg) {
  !rlang::is_missing(rlang::maybe_missing(arg))
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
    NULL
  } else if (all(args == "")) {
    NULL
  } else if (all(is.na(args))) {
    NA_character_
  } else {
    paste(args, collapse = collapse)
  }
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

named_values <- function(x) {
  x[rlang::names2(x) != ""]
}

unnamed_values <- function(x) {
  x[rlang::names2(x) == ""]
}

obj_class_add <- function(x, new) {
  full <- unique(c(new, class(x)))
  class(x) <- full
  x
}

# https://github.com/rstudio/shiny/blob/c332c051f33fe325f6c2e75426daaabb6366d50a/R/html-deps.R#L43
processDeps <- function(tags, session) {
  ui <- takeSingletons(tags, session$singletons, desingleton = FALSE)$ui
  ui <- surroundSingletons(ui)

  dependencies <- lapply(
    resolveDependencies(findDependencies(ui)),
    createWebDependency
  )
  names(dependencies) <- NULL

  # list(
  #   html = doRenderTags(ui),
  #   deps = dependencies
  # )
  dependencies
}
