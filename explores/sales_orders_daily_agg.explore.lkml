include: "/views/core/sales_orders_daily_agg_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines__amounts_rfn.view"
include: "/views/core/shared_parameters_xvw.view"

explore: sales_orders_daily_agg {
  hidden: yes
  join: sales_orders_daily_agg__lines {
    view_label: "Sales Orders Daily Agg: Lines"
    sql: LEFT JOIN UNNEST(${sales_orders_daily_agg.lines}) as sales_orders_daily_agg__lines ;;
    relationship: one_to_many
  }
  join: sales_orders_daily_agg__lines__amounts {
    view_label: "Sales Orders Daily Agg: Lines Amounts"
    sql: LEFT JOIN UNNEST(${sales_orders_daily_agg__lines.amounts}) as sales_orders_daily_agg__lines__amounts ;;
    relationship: one_to_many
  }

  join: shared_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}
