include: "/explores/sales_payments.explore"
include: "/views/test/sales_payments_test.view"
include: "/views/test/currency_conversion_sdt_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"

include: "/views/test/sales_invoices_test.view"

explore: +sales_payments {
  label: "Sales Payments TEST"

  join: sales_invoices {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sales_payments.invoice_id} = ${sales_invoices.invoice_id} ;;
  }
}
