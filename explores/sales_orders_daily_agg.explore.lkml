include: "/views/core/sales_orders_daily_agg_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines__amounts_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: sales_orders_daily_agg {
  hidden: no
  label: "Sales Orders Daily Aggregate"
  description: "Provides Daily Sales Totals by Business Unit, Order Source, and Sold To/Bill To/Ship To Customer. Also includes Amounts in Target Currencies for Item Categories."

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: sales_orders_daily_agg__lines {
    view_label: "Sales Orders Daily Agg: Item Categories"
    sql: LEFT JOIN UNNEST(${sales_orders_daily_agg.lines}) as sales_orders_daily_agg__lines ;;
    sql_where: @{get_category_set} ${sales_orders_daily_agg__lines.category_set_name} in ("Unknown",'{{ category_set }}') ;;
    # sql_where: ${sales_orders_daily_agg__lines.item_category_set_name} in ("Unknown",{% parameter otc_common_parameters_xvw.parameter_category_set_name %}) ;;
    relationship: one_to_many
  }

  join: sales_orders_daily_agg__lines__amounts {
    view_label: "Sales Orders Daily Agg: Item Categories Amounts"
    sql: LEFT JOIN UNNEST(${sales_orders_daily_agg__lines.amounts}) as sales_orders_daily_agg__lines__amounts ;;
    sql_where: ${sales_orders_daily_agg__lines__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
    relationship: one_to_many
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }
}
