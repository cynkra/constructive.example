
<!-- README.md is generated from README.Rmd. Please edit that file -->

# constructive.example

This package serves as an example on how to extend {constructive}.

We build a new constructor for the class “tbl_df” (tibbles), using the
deprecated constructor `tibble::data_frame()`.

We support a new class : “qr”. This is the class of the object we get
after applying `base::qr()` to get the QR decomposition of a matrix. We
build a couple constructors for it.

Finally we implement a constructor that construct integers as sums of
`1L`, surrounding the operation by parentheses or curly braces depending
on a parameter.

The reconstruction of qr objects is not perfect due to rounding errors
so the function is not a good fit for {constructive} but is a good use
case for an example.

This package is made so you can look at the code and use it as templates
to build your own methods. When you do so please pay attention to the
`@export` and `@method` tags, these are important. Make sure to import
the necessary functions from {constructive} too, as we do here in
“R/constructive.example-package.R”

## Without custom methods

Constructive works even if it doesn’t support directly some classes

Without {constructive.example}

``` r
library(constructive)

# will work but use the list constructor
A <- matrix(1:6, nrow = 3)
qr_A <- qr(A)
construct(qr_A)
#> list(
#>   qr = matrix(
#>     c(
#>       -0x1.deeea11683f49p+1, 0.5345224838248488, 0.8017837257372732,
#>       -8.55235974119758, 1.9639610121239324, 0x1.fa35f928a0dfap-1
#>     ),
#>     nrow = 3L,
#>     ncol = 2L
#>   ),
#>   rank = 2L,
#>   qraux = c(1.26726124191242429, 1.1499536117281517),
#>   pivot = 1:2
#> ) |>
#>   structure(class = "qr")
```

## With custom methods

With {constructive.example}

``` r
library(constructive.example)

# the "qr" class is now supported  
A <- matrix(1:6, nrow = 3)
qr_A <- qr(A)
construct(qr_A)
#> {constructive} couldn't create code that reproduces perfectly the input
#> ℹ Call `construct_issues()` to inspect the last issues
#> qr(matrix(
#>   c(0.99999999999999967, 2, 3, 4.000000000000002, 5.000000000000001, 6.000000000000001),
#>   nrow = 3L,
#>   ncol = 2L
#> ))

# the recreation was not perfect due to rounding errors but we're pretty close
construct_issues()
#>     original$qr         | recreated$qr           
#> [1] -3.7416573867739413 | -3.7416573867739413 [1]
#> [2] 0.5345224838248488  | 0.5345224838248488  [2]
#> [3] 0.8017837257372732  | 0.8017837257372732  [3]
#> [4] -8.5523597411975807 - -8.5523597411975825 [4]
#> [5] 1.9639610121239324  - 1.9639610121239346  [5]
#> [6] 0.9886930334182005  - 0.9886930334182003  [6]
#> 
#>  `original$qraux`: 1.2672612419124243 1.1499536117281517
#> `recreated$qraux`: 1.2672612419124243 1.1499536117281519
```

## Other constructors

``` r
# fall back on the next method, which is for lists
construct(qr_A, opts_qr("next"))
#> list(
#>   qr = matrix(
#>     c(
#>       -0x1.deeea11683f49p+1, 0.5345224838248488, 0.8017837257372732,
#>       -8.55235974119758, 1.9639610121239324, 0x1.fa35f928a0dfap-1
#>     ),
#>     nrow = 3L,
#>     ncol = 2L
#>   ),
#>   rank = 2L,
#>   qraux = c(1.26726124191242429, 1.1499536117281517),
#>   pivot = 1:2
#> ) |>
#>   structure(class = "qr")

# use explicitly the list method (same result here)
construct(qr_A, opts_qr("list"))
#> list(
#>   qr = matrix(
#>     c(
#>       -0x1.deeea11683f49p+1, 0.5345224838248488, 0.8017837257372732,
#>       -8.55235974119758, 1.9639610121239324, 0x1.fa35f928a0dfap-1
#>     ),
#>     nrow = 3L,
#>     ncol = 2L
#>   ),
#>   rank = 2L,
#>   qraux = c(1.26726124191242429, 1.1499536117281517),
#>   pivot = 1:2
#> ) |>
#>   structure(class = "qr")
```

## Corrupted objects

``` r
corrupted <- structure(1:3, class = "qr")
# thanks to our implementation of is_corrupted_qr() we don't fail here but just fall
# back to the next method
construct(corrupted)
#> 1:3 |>
#>   structure(class = "qr")
```

## Other examples

``` r
construct(dplyr::band_members, opts_tbl_df("data_frame"))
#> tibble::data_frame(name = c("Mick", "John", "Paul"), band = c("Stones", "Beatles", "Beatles"))
construct(list(4L, 2L), opts_integer("ones"))
#> list((1L + 1L + 1L + 1L), (1L + 1L))
# note the use of `curly` here, and check out the code to see how it is implemented
construct(list(4L, 2L), opts_integer("ones", curly = TRUE))
#> list({1L + 1L + 1L + 1L}, {1L + 1L})
```
