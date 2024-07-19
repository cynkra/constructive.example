#' @exportS3Method constructive::.cstr_construct.tbl_df
.cstr_construct.tbl_df.data_frame <- function(x, ...) {
  # Uncomment if your constructor needs additional options from opts_tbl_df()
  # opts <- list(...)$opts$tbl_df %||% opts_tbl_df()

  # Instead of the call below we need to fetch the args of the constructor in `x`.
  args <- list()

  # This creates a call data_frame(...) where ... is the constructed code
  # of the arguments stored in `args`
  # Sometimes we want to construct the code of the args separately, i.e. store
  # code rather than objects in `args`, and use `recurse = FALSE` below
  code <- constructive::.cstr_apply(args, fun = "tibble::data_frame", ...)

  # .cstr_repair_attributes() makes sure that attributes that are not built
  # by the idiomatic constructor are generated
  constructive::.cstr_repair_attributes(
    x, code, ...,
    # attributes built by the constructor
    # ignore =,

    # not necessarily just a string, but the whole class(x) vector
    idiomatic_class = c("tbl_df", "tbl", "data.frame")
  )
}
