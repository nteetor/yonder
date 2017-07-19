.onLoad <- function(lib, pkg) {
  attached <- search()
  isAttached <- function(x) x %in% attached
  modules <- c("utils", "forms", "icons", "bs", "inputs")


  checkConflicts <- function(env) {
    dontMind <- c(
      "last.dump", "last.warning", ".Last.value",
      ".Random.seed", ".Last.lib", ".onDetach", ".packageName",
      ".noGenerics", ".required", ".no_S3_generics", ".requireCachedGenerics"
    )

    sp <- search()
    for (i in seq_along(sp)) {
      if (identical(env, as.environment(i))) {
        dbPos <- i
        break
      }
    }

    ob <- names(as.environment(dbPos))
    if (.isMethodsDispatchOn()) {
      these <- ob[startsWith(ob, ".__T__")]
      gen <- gsub(".__T__(.*):([^:]+)", "\\1", these)
      from <- gsub(".__T__(.*):([^:]+)", "\\2", these)
      gen <- gen[from != ".GlobalEnv"]
      ob <- ob[!(ob %in% gen)]
    }

    ipos <- seq_along(sp)[-c(dbPos, match(c("Autoloads", "CheckExEnv"), sp, 0L))]

    for (i in ipos) {
      objSame <- match(names(as.environment(i)), ob, nomatch = 0L)

      if (any(objSame > 0L)) {
        same <- ob[objSame]
        same <- same[!(same %in% dontMind)]
        classObjs <- which(startsWith(same, ".__"))
        if (length(classObjs)) {
          same <- same[-classObjs]
        }
        sameIsFn <- function(where) {
          vapply(same, exists, NA, where = where, mode = "function", inherits = FALSE)
        }
        same <- same[sameIsFn(i) == sameIsFn(dbPos)]
        if (length(same)) {
          pkg <- if (sum(sp == sp[i]) > 1L) {
            sprintf("%s (pos = %d)", sp[i], i)
          } else {
            sp[i]
          }

          if (i > dbPos) {
            packageStartupMessage(
              paste(
                "    -", paste0("`", sort(same), "`", collapse = ", "),
                "masked from", pkg
              )
            )
          }
        }
      }
    }
  }

  for (mod in modules) {
    opt <- paste0("dull.attach.", mod)
    nm <- paste0("dull:", mod)

    if (getOption(opt, FALSE) && !isAttached(nm)) {
      packageStartupMessage(paste0("  * attaching `", mod, "` module"))
      checkConflicts(
        eval(call("attach", as.name(mod), name = nm, warn.conflicts = FALSE))
      )
    }
  }
}

.onUnload <- function(path) {
  attached <- grep("^dull:[a-z]+$", search(), value = TRUE)

  for (att in attached) {
    detach(att, unload = TRUE, character.only = TRUE)
  }
}
