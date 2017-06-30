.onLoad <- function(lib, pkg) {
  attached <- search()
  isAttached <- function(x) x %in% attached
  modules <- c("utils", "forms", "icons", "bs", "inputs")

  for (mod in modules) {
    opt <- paste0("dull.attach.", mod)
    nm <- paste0("dull:", mod)

    if (getOption(opt, FALSE) && !isAttached(nm)) {
      packageStartupMessage(paste0("attaching ", mod))
      eval(call("attach", as.name(mod), name = nm))
    }
  }
}

.onUnload <- function(path) {
  attached <- grep("^dull:", search(), value = TRUE)

  for (att in attached) {
    detach(att, unload = TRUE, character.only = TRUE)
  }
}
