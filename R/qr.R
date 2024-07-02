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
  # we could go further but here we just check that the high level structure
  # makes sense for a "qr" object. We should not check the class here.
  !is.list(x) || !all(names(x) %in% c("qr", "rank", "qraux", "pivot"))
}

#' @export
#' @method .cstr_construct.qr qr
.cstr_construct.qr.qr <- function(x, ...) {
  # inverse transformation
  inv <- qr.X(x)
  # .cstr_apply constructs the code for `inv` and interpolates it into a qr() call
  code <- .cstr_apply(list(inv), "qr", ..., new_line = FALSE)
  # in case attributes are different than canonical, .cstr_repair_attributes fixes them
  .cstr_repair_attributes(
    x, code, ...,
    idiomatic_class = "qr"
  )
}
