#' @export
.cstr_construct.integer.ones <- function(x, ...) {
  opts <- list(...)$opts$integer %||% opts_integer()
  curly <- opts$curly %||% FALSE
  code <- paste(rep("1L", x), collapse = " + ")
  code <- if (curly) sprintf("{%s}", code) else sprintf("(%s)", code)
  .cstr_repair_attributes(x, code, ...)
}
