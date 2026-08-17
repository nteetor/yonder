# `MockShinySession$sendInputMessage()` is a warning no-op, so updates are
# checked against a session that simply records what it was sent.
recording_session <- function() {
  session <- new.env(parent = emptyenv())
  session$sent <- list()

  session$sendInputMessage <- function(id, message) {
    session$sent[[length(session$sent) + 1]] <- list(
      id = id,
      message = message
    )
    invisible()
  }

  session
}
