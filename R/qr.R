#' Constructive options class 'qr'
#'
#' These options will be used on objects of class 'qr'.
#'
#' Depending on `constructor`, we construct the environment as follows:
#' * `"qr"` (default): We wrap a character vector with `as.qr()`, if the qr
#'   is infinite it cannot be converted to character and we wrap a numeric vector and
#' * `"next"` : Use the constructor for the next supported class. Call `.class2()`
#'   on the object to see in which order the methods will be tried.
#' * `"list"` : Define as a list and repair attributes
#'
#' @param constructor String. Name of the function used to construct the environment.
#' @inheritParams constructive::opts_atomic
#'
#' @return An object of class <constructive_options/constructive_options_environment>
#' @export
opts_qr <- function(constructor = c("qr", "next", "list"), ...) {
  # a helper to operate all checks even if an early check fails
  .cstr_combine_errors(
    # a helper to match a constructor, including user defined constructors
    constructor <- .cstr_match_constructor(constructor),
    ellipsis::check_dots_empty()
  )
  # builds objects that .cstr_fetch_opts() knows how to handle
  .cstr_options("qr", constructor = constructor)
}

#' @export
#' @importFrom constructive .cstr_construct
#' @method .cstr_construct qr
.cstr_construct.qr <- function(x, ...) {
  # handle options fed through opts_qr()
  opts <- .cstr_fetch_opts("qr", ...)
  # apply a constructor only if the object is a proper "qr" object
  if (is_corrupted_qr(x) || opts$constructor == "next") return(NextMethod())
  constructor <- constructors$qr[[opts$constructor]]
  constructor(x, ...)
}

is_corrupted_qr <- function(x) {
  # we could go further but here we just check that the high level structure
  # makes sense for a "qr" object. We should not check the class here.
  !is.list(x) || !all(names(x) %in% c("qr", "rank", "qraux", "pivot"))
}

# our main constructor
constructor_qr_qr <- function(x, ...) {
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

# an aditional low level constructor
constructor_qr_list <- function(x, ..., origin) {
  # we use the method for "list", methods are not exported functions so we use
  # getS3method() to fetch it
  getS3method(".cstr_construct", "list")(x, ...)
}
