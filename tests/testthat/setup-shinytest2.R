# chromote needs a Chromium-based browser. When none is installed, fall back
# to a downloaded "Chrome for Testing" headless binary (cached by chromote
# after the first download).
if (requireNamespace("chromote", quietly = TRUE)) {
  has_chrome <- tryCatch(
    !is.null(chromote::find_chrome()),
    error = function(e) FALSE
  )

  if (!has_chrome) {
    chromote::local_chrome_version(
      binary = "chrome-headless-shell",
      quiet = TRUE,
      .local_envir = testthat::teardown_env()
    )
  }
}
