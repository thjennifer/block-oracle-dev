include: "/views/core/sales_cash_receipts_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"


explore: sales_cash_receipts {
  join: currency_conversion_sdt {
    view_label: "Sales Invoices: Lines Currency Conversion"
    type: left_outer
    sql_on:  ${sales_cash_receipts.receipt_raw} = ${currency_conversion_sdt.conversion_date} AND
              ${sales_cash_receipts.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_invoices__lines
    fields: []
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}

}
