# Check for missing `id` argument errors

expect_missing_id_error <- function(object) {
  expect_error(object, "please specify `id`", fixed = TRUE)
}
