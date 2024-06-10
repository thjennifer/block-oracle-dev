include: "/views/core/sales_payments_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"


explore: sales_payments {

  join: currency_conversion_sdt {
    view_label: "Sales Orders: Lines Currency Conversion"
    type: left_outer
    sql_on:  ${sales_payments.payment_raw} = ${currency_conversion_sdt.conversion_date} AND
      ${sales_payments.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_order__lines
    fields: []
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}


}
