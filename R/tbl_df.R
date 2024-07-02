#' @importFrom constructive .cstr_construct .cstr_apply
NULL

#' @export
.cstr_construct.tbl_df.data_frame <- function(x, ...) {
  args <- as.list(x)
  code <- .cstr_apply(args, fun = "tibble::data_frame", ...)
  .cstr_repair_attributes(
    x, code, ...,
    ignore = "row.names",
    idiomatic_class = c("tbl_df", "tbl", "data.frame")
  )
}
