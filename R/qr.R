#' @importFrom constructive .cstr_options .cstr_construct .cstr_apply .cstr_repair_attributes
NULL

#' Constructive options for class 'qr'
#'
#' These options will be used on objects of class 'qr'.
#'
#' Depending on `constructor`, we construct the object as follows:
#' * `"qr"` (default): We build the object using `qr()`.
#' * `"next"` : Use the constructor for the next supported class.
#'
#' @param constructor String. Name of the function used to construct the object.
#' @param ... Additional options used by user defined constructors through the `opts` object
#' @return An object of class <constructive_options/constructive_options_qr>
#' @export
opts_qr <- function(constructor = c("qr", "next"), ...) {
  .cstr_options("qr", constructor = constructor[[1]], ...)
}

#' @export
#' @method .cstr_construct qr
.cstr_construct.qr <- function(x, ...) {
  opts <- list(...)$opts$qr %||% opts_qr()
  if (is_corrupted_qr(x) || opts$constructor == "next") return(NextMethod())
  UseMethod(".cstr_construct.qr", structure(NA, class = opts$constructor))
}

is_corrupted_qr <- function(x) {
  FALSE
}

#' @export
#' @method .cstr_construct.qr qr
.cstr_construct.qr.qr <- function(x, ...) {
  # opts <- list(...)$opts$qr %||% opts_qr()
  args <- list()
  code <- .cstr_apply(args, fun = "qr", ...)
  .cstr_repair_attributes(
    x, code, ...,
    idiomatic_class = "qr"
  )
}
