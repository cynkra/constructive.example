
<!-- README.md is generated from README.Rmd. Please edit that file -->

# constructive.example

This package serves as an example on how to extend {constructive}.

We build a new constructor for the class “tbl_df” (tibbles), using the
deprecated constructor `tibble::data_frame()`.

We also support a new class : “qr”. This is the class of the object we
get after applying `base::qr()` to get the QR decomposition of a matrix.
We build a couple constructors for it.

The reconstruction is not perfect due to rounding errors so the function
is not a good fit for {constructive} but is a good use case for an
example.

You might use it as a template, all useful constructive functions are
imported in “R/constructive.example-package.R”

## examples

Without {constructive.example}

``` r
library(constructive)

# will fail because the constructor is undefined
construct(dplyr::band_members, opts_tbl_df("data_frame"))
#> Error in `construct()`:
#> ! {constructive} could not build the requested code.
#> Caused by error in `opts_tbl_df()` at constructive/R/opts.R:29:2:
#> ! `constructor` must be one of "list", "tibble", "tribble", or "next", not "data_frame".

# will work but use the list constructor
A <- matrix(1:6, nrow = 3)
qr_A <- qr(A)
constructive::construct(qr_A)
#> list(
#>   qr = matrix(
#>     c(
#>       -0x1.deeea11683f48p+1, 0.534522483824848793077, 0.8017837257372731896155,
#>       -8.55235974119758, 1.963961012123932370343, 0x1.fa35f928a0dfap-1
#>     ),
#>     nrow = 3L,
#>     ncol = 2L
#>   ),
#>   rank = 2L,
#>   qraux = c(0x1.446b3b958090ap+0, 0x1.26635c224a1c4p+0),
#>   pivot = 1:2
#> ) |>
#>   structure(class = "qr")
```

With {constructive.example}

``` r
library(constructive.example)

# we can now choose our custom constructor for tbl_df objects
construct(dplyr::band_members, opts_tbl_df("data_frame"))
#> tibble::data_frame(name = c("Mick", "John", "Paul"), band = c("Stones", "Beatles", "Beatles"))

# and the "qr" class is now supported  
A <- matrix(1:6, nrow = 3)
qr_A <- qr(A)
constructive::construct(qr_A)
#> Warning in ls(constructors[[class]], all.names = TRUE): 'constructors[[class]]'
#> converted to character string
#> Error in `constructive::construct()`:
#> ! {constructive} could not build the requested code.
#> Caused by error:
#> ! no item called "constructors[[class]]" on the search list

# the recreation was not perfect due to rounding errors but we're pretty close
constructive::construct_issues()
#> NULL

# fall back on the next method, which is for lists
constructive::construct(qr_A, opts_qr("next"))
#> Warning in ls(constructors[[class]], all.names = TRUE): 'constructors[[class]]'
#> converted to character string
#> Error in `constructive::construct()`:
#> ! {constructive} could not build the requested code.
#> Caused by error in `opts_qr()` at constructive/R/opts.R:29:2:
#> ! no item called "constructors[[class]]" on the search list

# use explicitly the list method (same result)
constructive::construct(qr_A, opts_qr("list"))
#> Warning in ls(constructors[[class]], all.names = TRUE): 'constructors[[class]]'
#> converted to character string
#> Error in `constructive::construct()`:
#> ! {constructive} could not build the requested code.
#> Caused by error in `opts_qr()` at constructive/R/opts.R:29:2:
#> ! no item called "constructors[[class]]" on the search list
```
