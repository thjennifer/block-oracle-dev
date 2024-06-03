include: "/views/base/sales_orders_daily_agg.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
view: +sales_orders_daily_agg {
  extends: [sales_orders_common_dimensions_ext]


   }
