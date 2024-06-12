connection: "cortex-oracle-dev"



# include: "/explores/*.explore"
include: "/components/named_value_formats.lkml"



# include: "/views/core/otc_common_parameters_xvw.view"
# include: "/views/core/currency_conversion_sdt.view"
# include: "/views/test/sales_orders_top_n_sdt.view"
# include: "/views/test/test_view_ext_rfn.view"

# explore: sales_orders_top_n_sdt {
#   join: otc_common_parameters_xvw {
#     relationship: one_to_one
#     sql:  ;;
# }
# }

# explore: test_view_ext {

# }

include: "/explores/test/*.explore"

include: "/dashboards/test/*.dashboard"
