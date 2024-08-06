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

  join: sales_orders__lines__cancel_reason {
    view_label: "Sales Orders: Lines Cancel Reasons"
    sql: LEFT JOIN UNNEST(${sales_orders__lines.cancel_reason}) as sales_orders__lines__cancel_reason ;;
    sql_where: ${sales_orders__lines__cancel_reason.language} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
    relationship: one_to_many
  }

  join: sales_orders__lines__return_line_ids {
    view_label: "Sales Orders: Lines Return Line IDs"
    sql: LEFT JOIN UNNEST(${sales_orders__lines.return_line_ids}) as sales_orders__lines__return_line_ids ;;
    relationship: one_to_many
  }

  join: sales_orders__lines__item_categories {
    view_label: "Sales Orders: Lines Item Categories"
    sql: LEFT JOIN UNNEST(${sales_orders__lines.item_categories}) as sales_orders__lines__item_categories ;;
    sql_where: @{get_category_set} ${sales_orders__lines__item_categories.category_set_name} in ("Unknown",'{{ category_set }}') ;;
    # sql_where: ${sales_orders__lines__item_categories.category_set_name} in ("Unknown",{% parameter otc_common_parameters_xvw.parameter_category_set_name %}) ;;
    relationship: one_to_many
  }

  join: sales_orders__lines__item_descriptions {
    view_label: "Sales Orders: Lines Item Descriptions"
    sql: LEFT JOIN UNNEST(${sales_orders__lines.item_descriptions}) as sales_orders__lines__item_descriptions ;;
    sql_where: ${sales_orders__lines__item_descriptions.language_code} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
    relationship: one_to_many
  }

  # join: otc_orders_dashboard_navigation_ext {
  #   view_label: "Navigation Testing"
  #   relationship: one_to_one
  #   sql:  ;;
  # }
}
