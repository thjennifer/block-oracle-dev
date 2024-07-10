include: "/explores/sales_orders_daily_agg.explore"

include: "/views/test/sales_orders_daily_agg_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"

include: "/views/core/sales_orders_daily_agg__lines_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines__amounts_rfn.view"






explore: +sales_orders_daily_agg {
  label: "Sales Orders Daily Agg TEST"
  join: sales_orders_daily_agg__lines__amounts {
    view_label: "Sales Orders Daily Agg: Item Categories Amounts"
    sql: LEFT JOIN UNNEST(${sales_orders_daily_agg__lines.amounts}) as sales_orders_daily_agg__lines__amounts ;;
    sql_where: ${sales_orders_daily_agg__lines__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
    relationship: one_to_many
  }
}
