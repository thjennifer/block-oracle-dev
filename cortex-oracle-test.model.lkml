connection: "cortex-oracle-dev"



include: "/explores/*.explore"
include: "/components/named_value_formats.lkml"



include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/test/sales_orders_top_n_sdt.view"

explore: sales_orders_top_n_sdt {
  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}
}
