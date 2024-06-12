include: "/explores/sales_orders_daily_agg.explore"

include: "/views/test/sales_orders_daily_agg_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"

include: "/views/core/sales_orders_daily_agg__lines_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines__amounts_rfn.view"






explore: +sales_orders_daily_agg {
  label: "Sales Orders Daily Agg TEST"
}
