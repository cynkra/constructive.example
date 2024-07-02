
<!-- README.md is generated from README.Rmd. Please edit that file -->

# constructive.example

This package serves as an example on how to extend {constructive}.

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

- Call `constructive::.cstr_new_class(class = "qr", constructor = "qr")`
- Save the script and call `devtools::document()` (see [this
  commit](https://github.com/cynkra/constructive.example/commit/3aeb429f00dafa458575e194e0f35ce8eb05ca2d#diff-f74f3e31638afda340efd3e55979a30b9a1ba431fbd6ccceaff0f1711ef45ef4)).
- Update the code (see [this
  commit](https://github.com/cynkra/constructive.example/commit/ba11788e65f2ff5df37ef6dd0941c65245212089))
- `devtools::load_all()`

After this we have:

``` r
library(constructive.example)
construct(qr_A)
#> {constructive} couldn't create code that reproduces perfectly the input
#> ℹ Call `construct_issues()` to inspect the last issues
#> qr(matrix(
#>   c(0.99999999999999967, 2, 3, 4.000000000000002, 5.000000000000001, 6.000000000000001),
#>   nrow = 3L,
#>   ncol = 2L
#> ))
```

The recreation was not perfect due to rounding errors but we’re pretty
close

``` r
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

Thanks to our implementation of `is_corrupted_qr()` we don’t fail on
corrupted objects but fall back to the next method.

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

- Call
  `constructive::.cstr_new_constructor(class = c("tbl_df", "tbl", "data.frame"), constructor = "tibble::data_frame")`
- Save the script and call `devtools::document()`, see [this
  commit](https://github.com/cynkra/constructive.example/commit/3aeb429f00dafa458575e194e0f35ce8eb05ca2d#diff-f74f3e31638afda340efd3e55979a30b9a1ba431fbd6ccceaff0f1711ef45ef4)
- Update the code (see [this
  commit](https://github.com/cynkra/constructive.example/commit/ba11788e65f2ff5df37ef6dd0941c65245212089))
- `devtools::load_all()`

After this we have:

``` r
construct(dplyr::band_members, opts_tbl_df("data_frame"))
#> tibble::data_frame(name = c("Mick", "John", "Paul"), band = c("Stones", "Beatles", "Beatles"))
```

Note that [our implementation of the “tibble” constructor in
{constructive}](https://github.com/cynkra/constructive/blob/86d8d3d47081e17a691cde1188c838c80b072e56/R/s3-tbl_df.R#L54)
is more sophisticated because `tibble()` cannot create columns named
`.rows` or `.name_repair`, and we check if the object is corrupted.
