include: "/views/core/sales_orders_rfn.view"
include: "/views/core/sales_orders__lines_rfn.view"
include: "/views/core/sales_orders__lines__return_line_ids_rfn.view"
include: "/views/core/sales_orders__lines__item_categories_rfn.view"
include: "/views/core/sales_orders__lines__item_descriptions_rfn.view"
include: "/views/core/sales_orders__lines__cancel_reason_rfn.view"

include: "/views/core/currency_conversion_sdt.view"
# include: "/views/core/currency_rate_md_rfn.view"

# field-only views
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"

explore: sales_orders {
  hidden: no

  join: sales_orders__lines {
    view_label: "Sales Orders: Lines"
    sql: LEFT JOIN UNNEST(${sales_orders.lines}) as sales_orders__lines ;;
    relationship: one_to_many
  }

  join: currency_conversion_sdt {
    view_label: "Sales Orders: Lines Currency Conversion"
    type: left_outer
    sql_on:  ${sales_orders.ordered_raw} = ${currency_conversion_sdt.conversion_date} AND
             ${sales_orders.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_order__lines
    fields: []
   }

  # join: currency_rate_md {
  #   type: left_outer
  #   relationship: many_to_one
  #   sql_on:  ${sales_orders.ordered_raw} = ${currency_rate_md.conversion_raw} AND
  #             ${sales_orders.currency_code} = ${currency_rate_md.from_currency} AND
  #             ${currency_rate_md.to_currency} = {% parameter sales_orders_common_parameters.parameter_target_currency %} ;;
  # }


  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    view_label: "🔍 Filters & 🛠 Tools"
    relationship: one_to_one
    sql:  ;;
  }

  # join: sales_orders__lines__item_categories {
  #   view_label: "Sales Orders: Lines Item Categories"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.item_categories}) as sales_orders__lines__item_categories ;;
  #   sql_where: @{get_category_set} ${sales_orders__lines__item_categories.category_set_name} in ("Unknown",'{{ category_set }}') ;;
  #   # sql_where: ${sales_orders__lines__item_categories.category_set_name} in ("Unknown",{% parameter otc_common_parameters_xvw.parameter_category_set_name %}) ;;
  #   relationship: one_to_many
  # }

  # join: sales_orders__lines__item_descriptions {
  #   view_label: "Sales Orders: Lines Item Descriptions"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.item_descriptions}) as sales_orders__lines__item_descriptions ;;
  #   sql_where: ${sales_orders__lines__item_descriptions.language_code} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
  #   relationship: one_to_many
  # }

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


}
