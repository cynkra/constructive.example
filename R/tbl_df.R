#' @export
.cstr_construct.tbl_df.data_frame <- function(x, ...) {
  # construct idiomatic code
  # iterate on elements of x to construct them, and wrap them in a tibble::data_frame() call
  code <- .cstr_apply(x, fun = "tibble::data_frame", ...)

  # in case attributes are different than canonical, .cstr_repair_attributes fixes them
  .cstr_repair_attributes(
    x, code, ...,
    ignore = "row.names",
    idiomatic_class = c("tbl_df", "tbl", "data.frame")
  )
}
