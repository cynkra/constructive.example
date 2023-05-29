.onLoad <- function(...) {
  .cstr_register_constructors(
    "qr",
    qr = constructor_qr_qr,
    list = constructor_qr_list
  )
  .cstr_register_constructors(
    "tbl_df",
    data_frame = constructor_tbl_df_data_frame
  )
}
