include: "/explores/sales_orders.explore"

#replaced views with TEST refinements
include: "/views/test/sales_orders_test.view"
include: "/views/test/otc_common_parameters_xvw_test.view"
include: "/views/test/sales_orders__lines_test.view"
include: "/views/test/currency_conversion_sdt_test.view"
include: "/views/test/otc_dashboard_navigation_ext_test.view"

include: "/views/core/sales_orders__lines__return_line_ids_rfn.view"
include: "/views/core/sales_orders__lines__item_categories_rfn.view"
include: "/views/core/sales_orders__lines__item_descriptions_rfn.view"




explore: +sales_orders {
  label: "Sales Orders TEST"
}
