include: "/views/core/sales_payments_daily_agg_rfn.view"
include: "/views/core/sales_payments_daily_agg__amounts_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"



explore: sales_payments_daily_agg {

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: sales_payments_daily_agg__amounts {
    view_label: "Sales Payments Daily Agg: Amounts"
    sql: LEFT JOIN UNNEST(${sales_payments_daily_agg.amounts}) as sales_payments_daily_agg__amounts ;;
    sql_where: ${sales_payments_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
    relationship: one_to_many
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }
}
