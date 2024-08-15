include: "/explores/sales_invoices_daily_agg.explore"

include: "/views/test/sales_invoices_daily_agg_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"
include: "/views/test/otc_dashboard_navigation_ext_test.view"


explore: +sales_invoices_daily_agg {
  label: "Sales Invoices Daily Agg TEST"

  join: sales_invoices_daily_agg__amounts {
    view_label: "Sales Invoices Daily Agg: Amounts"
    sql: LEFT JOIN UNNEST(${sales_invoices_daily_agg.amounts}) as sales_invoices_daily_agg__amounts ;;
    sql_where: ${sales_invoices_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
    relationship: one_to_many
  }
}
