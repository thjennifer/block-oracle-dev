include: "/explores/sales_payments_daily_agg.explore"
include: "/views/test/sales_payments_daily_agg_test.view"
include: "/views/test/sales_payments_daily_agg_test_data_sdt_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"
include: "/views/test/otc_dashboard_navigation_ext_test.view"

include: "/views/test/sales_invoices_test.view"

explore: +sales_payments_daily_agg {
  label: "Sales Payments Daily Agg TEST"

  join: sales_payments_daily_agg__amounts {
    view_label: "Sales Payments Daily Agg: Amounts"
    sql: LEFT JOIN UNNEST(${sales_payments_daily_agg.amounts}) as sales_payments_daily_agg__amounts ;;
    sql_where: ${sales_payments_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
    relationship: one_to_many
  }

}