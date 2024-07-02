#' @importFrom constructive .cstr_construct .cstr_apply
NULL

#' @export
.cstr_construct.tbl_df.data_frame <- function(x, ...) {
  # opts <- list(...)$opts$tbl_df %||% opts_tbl_df()
  args <- list()
  code <- .cstr_apply(args, fun = "tibble::data_frame", ...)
  .cstr_repair_attributes(
    x, code, ...,
    idiomatic_class = c("tbl_df", "tbl", "data.frame")
  )
}
