include: "/views/core/sales_payments_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"
include: "/views/core/sales_payments_dynamic_aging_bucket_sdt.view"
include: "/views/core/dso_dynamic_days_sdt.view"


explore: sales_payments {

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: currency_conversion_sdt {
    view_label: "Sales Payments: Lines Currency Conversion"
    type: left_outer
    sql_on:  COALESCE(${sales_payments.exchange_raw},${sales_payments.transaction_raw}) = ${currency_conversion_sdt.conversion_date} AND
      ${sales_payments.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_order__lines
    fields: []
  }

  join: sales_payments_dynamic_aging_bucket_sdt {
    view_label: "Sales Payments"
    type: left_outer
    sql_on: ${sales_payments.days_overdue} BETWEEN ${sales_payments_dynamic_aging_bucket_sdt.start_days} AND ${sales_payments_dynamic_aging_bucket_sdt.end_days} ;;
    relationship: many_to_one
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }

  join: dso_dynamic_days_sdt {
    view_label: "Sales Payments"
    type: left_outer
    relationship: many_to_one
    sql_on: ${sales_payments.transaction_date} between ${dso_dynamic_days_sdt.dso_start_date} and ${dso_dynamic_days_sdt.dso_end_date} ;;
    # fields: [dso_dynamic_days_sdt.parameter_dso_number_of_days]
  }




}
