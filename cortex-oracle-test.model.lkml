connection: "cortex-oracle-dev"

include: "/explores/test/sales_orders_with_unnest.explore"
include: "/components/named_value_formats.lkml"

include: "/views/test/sales_orders_daily_agg_rfn2.view"

explore: sales_orders_daily_agg {
  view_name: sales_orders_daily_agg
  hidden: yes
}


include: "/views/test/test_view_rfn.view"

explore: test_view {
  hidden: yes
}

include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/test/sales_orders_top_n_sdt.view"

explore: sales_orders_top_n_sdt {
  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}