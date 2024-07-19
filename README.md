
<!-- README.md is generated from README.Rmd. Please edit that file -->

# constructive.example

This package serves as an example on how to extend {constructive}. For
some users it will be enough to call `constructive::.cstr_new_class()`
and `constructive::.cstr_new_constructor()` with `commented = TRUE` and
figure it out from there. This is a more detailed walkthrough. Follow
hyperlinks to inspect relevant commits.

## Implement a constructor for a new class

Let’s add support for a new class : “qr”. This is the class of the
object we get after applying `base::qr()` to get the QR decomposition of
a matrix.

The reconstruction of qr objects is not perfect due to rounding errors
so the feature is not a good fit for {constructive} but is a good use
case for an example.

First note that {constructive} works even if it doesn’t support directly
a class, it will then use the next relevant constructor:

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

We used the following workflow:

- Call `usethis::use_package("constructive", "Suggests")` to [add a soft
  dependency on the ‘constructive’
  package](https://github.com/cynkra/constructive.example/commit/e5512b8a4308364fa87ccf85a81e7e036638fabc)
  if not already done.
- Call
  `constructive::.cstr_new_class(class = "qr", constructor = "qr", commented = TRUE)`
  and [save the template
  script](https://github.com/cynkra/constructive.example/commit/91063555978561cbc3201ab2685ac4c7b34cfc5d)
  in your “R” folder.
- Call `devtools::document()` to [register the methods and export and
  document
  `opt_qr()`](https://github.com/cynkra/constructive.example/commit/f2b058261a368a7c88dc7f3be7e6f3f20bfd11cb)
- restart, `devtools::load_all()`, define `qr_A`

By this time we can already use our new constructor, it doesn’t quite
work yet though:

``` r
constructive::construct(qr_A)
#> ! The code built by {constructive} could not be evaluated.
#> ! Due to error: argument "x" is missing, with no default
#> qr()
```

This is because we haven’t construct the argument to `qr()`!

Let’s fix this:

- [Construct the argument to the
  constructor](https://github.com/cynkra/constructive.example/commit/27a531f2155abc56f2f22493c45863602c4f9b04).
  The `qr.X()` function does the inverse transformation so the input we
  want to construct is `qr.X(x)`.
- restart, `devtools::load_all()`, define `qr_A`

After this we have:

``` r
library(constructive)
construct(qr_A)
#> {constructive} couldn't create code that reproduces perfectly the input
#> ℹ Call `construct_issues()` to inspect the last issues
#> 
#> qr(
#>   matrix(
#>     c(0.99999999999999967, 2, 3, 4.000000000000002, 5.000000000000001, 6.000000000000001),
#>     nrow = 3L,
#>     ncol = 2L
#>   )
#> )
```

The recreation was not perfect due to rounding errors but we’re pretty
close

``` r
construct_issues()
#> NULL
```

We still get the previous behavior if we use the `"next"` constructor.

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
```

We still fail on corrupted objects though:

``` r
corrupted <- structure(1:3, class = "qr")
construct(corrupted)
#> Error in `construct()`:
#> ! {constructive} could not build the requested code.
#> Caused by error in `qr.X()`:
#> ! argument is not a QR decomposition
#> Run `rlang::last_trace()` to see where the error occurred.
```

Let’s fix this:

- [Implement
  `is_corrupted_qr()`](https://github.com/cynkra/constructive.example/commit/5737217204dcad93257cb1b61915d242cd6275f3)
- `devtools::load_all()`

Now we won’t fail on corrupted objects but fall back to the next method.

``` r
corrupted <- structure(1:3, class = "qr")
construct(corrupted)
#> 1:3 |>
#>   structure(class = "qr")
```

## Implement a new constructor for a supported class

We build a new constructor for the class “tbl_df” (tibbles), using the
deprecated constructor `tibble::data_frame()`, equivalent to
`tibble::tibble()`.

We used the following workflow:

- Call `usethis::use_package("constructive", "Suggests")` [to add a soft
  dependency on the ‘constructive’
  package](https://github.com/cynkra/constructive.example/commit/e5512b8a4308364fa87ccf85a81e7e036638fabc)
  if not already done (we did it already for the qr class)
- Call
  `constructive::.cstr_new_constructor(class = c("tbl_df", "tbl", "data.frame"), constructor = "tibble::data_frame", commented = TRUE)`
  and [save the template
  script](https://github.com/cynkra/constructive.example/commit/caf387ae9bd5a46c18008f381264a61ec89d6626)
  in your “R” folder
- Call `devtools::document()` to [register the
  method](https://github.com/cynkra/constructive.example/commit/2f1f5022c7d666074b3a5f91e8dc3bdac1770d9b)
- Call `devtools::load_all()`

By this time we can already use our new constructor, it doesn’t quite
work yet though:

``` r
construct(dplyr::band_members, opts_tbl_df("data_frame"))
#> {constructive} couldn't create code that reproduces perfectly the input
#> ℹ Call `construct_issues()` to inspect the last issues
#> 
#> tibble::data_frame() |>
#>   structure(row.names = c(NA, -3L))
```

We see that we don’t construct yet the arguments to data_frame and we
repair the `row.names` attribute that the constructor should take care
of. Let’s fix this:

- [Construct arguments to the
  constructor](https://github.com/cynkra/constructive.example/commit/8d474206d44250b08bb28c039917e96a31da38c1).
  The arguments are are the columns of the data frame, so here it’s as
  simple as `args <- as.list.data.frame(x)`. We prefered
  `as.list.data.frame()` to `as.list()` because we don’t control the S3
  dispatch and some corner cases might break the package.
- [Ignore attributes built by the
  constructor](https://github.com/cynkra/constructive.example/commit/265a72ac3ed356ddd5b4a09c8f0361b62a4f3096)
- Call `devtools::load_all()`

After this we have:

``` r
construct(dplyr::band_members, opts_tbl_df("data_frame"))
#> tibble::data_frame(name = c("Mick", "John", "Paul"), band = c("Stones", "Beatles", "Beatles"))
```

[our implementation of the “tibble” constructor in
{constructive}](https://github.com/cynkra/constructive/blob/86d8d3d47081e17a691cde1188c838c80b072e56/R/s3-tbl_df.R#L54)
is very similar but handles some corner cases that don’t apply to
`data_frame()`.
