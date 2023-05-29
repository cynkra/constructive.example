
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
#> {constructive} couldn't create code that reproduces perfectly the input
#> ℹ Call `construct_issues()` to inspect the last issues
#> qr(matrix(
#>   c(
#>     0x1.ffffffffffff6p-1, 0x1.ffffffffffffep+0, 2.999999999999999555911,
#>     0x1.0000000000002p+2, 5.000000000000000888178, 6.000000000000000888178
#>   ),
#>   nrow = 3L,
#>   ncol = 2L
#> ))

# the recreation was not perfect due to rounding errors but we're pretty close
constructive::construct_issues()
#>     original$qr         | recreated$qr           
#> [1] -3.7416573867739409 - -3.7416573867739404 [1]
#> [2] 0.5345224838248488  | 0.5345224838248488  [2]
#> [3] 0.8017837257372732  | 0.8017837257372732  [3]
#> [4] -8.5523597411975807 - -8.5523597411975825 [4]
#> [5] 1.9639610121239324  - 1.9639610121239346  [5]
#> [6] 0.9886930334182005  - 0.9886930334182003  [6]
#> 
#>  `original$qraux`: 1.2672612419124243 1.1499536117281517
#> `recreated$qraux`: 1.2672612419124243 1.1499536117281519

# fall back on the next method, which is for lists
constructive::construct(qr_A, opts_qr("next"))
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

# use explicitly the list method (same result)
constructive::construct(qr_A, opts_qr("list"))
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
