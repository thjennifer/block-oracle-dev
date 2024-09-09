#########################################################{
# PURPOSE
# Retrieve information about sales orders, including both
# header-level attributes and line-item details.
#
# SOURCES
# see include: statements
#
# REFERENCED BY
#   LookML dashboards:
#     otc_order_status
#     otc_order_sales_performance
#     otc_order_fulfillment
#     otc_order_line_item_details
#
# CATEGORY SET NAME
#   - This Explore will show only 1 Category Set Name based on the value in the user attribute
#     cortex_oracle_ebs_category_set_name (see constant category_set in Manifest file).
#       * Users can set the value for the user attribute through Account properties. Or an Admin can set the value for a group of users.
#   - This filter condition is defined in two spots:
#     1. the JOIN properties for optional view sales_orders__lines__item_categories
#     2. in the view sales_order__lines for the category_description, category_id and category_name_group dimensions
#
# LANGUAGE
#   - This Explore will show only 1 Language for item descriptions and cancel reasons based on the value in
#     parameter parameter_language.
#       * Users can change the parameter value in the provided LookML dashboards or Explore.
#       * In the provided LookML dashboards the, the default value for this parameter is based on the value in
#         the user attribute cortex_oracle_ebs_default_language.
#   - This filter condition is defined in two spots:
#    1. the JOIN properties for optional views sales_orders__lines__item_descriptions and sales_orders__lines__cancel_reason
#    2. in the view sales_orders__lines for the item_descriptions, language_code, and cancel_reason dimensions
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the parameter value on provided LookML dashboards or Explore.
#       * In the provided LookML dashboards, the default value for this parameter is the value in
#         the user attribute cortex_oracle_ebs_default_currency.
#   - This filter condition is applied in the view currency_conversion_sdt.
#
# REQUIRED FILTERS
#   Because orders can be either ORDER, RETURN or mixture, users will be prompted with these
#   required filters:
#     - Order Category Code with default of IS NOT RETURN
#     - Line Category Code with default of ANY VALUE
#   Users can change filter values as necessary.
#
# OTHER NOTES
#   - The view definitions for sales_orders and sales_orders_lines include a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definitions and
#     adjust a field's hidden property.
#
#   - Item descriptions, categories and cancel reasons are defined in sales_orders__lines so the unnested
#     views do not need to be included in the Explore. However, you can optionally include by
#     uncommenting the join statements below.
#
#########################################################}

include: "/views/core/sales_orders_rfn.view"
include: "/views/core/sales_orders__lines_rfn.view"
include: "/views/core/sales_orders__lines__return_line_ids_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"

#--> optional (uncomment joins below if needed)
include: "/views/core/sales_orders__lines__item_categories_rfn.view"
include: "/views/core/sales_orders__lines__item_descriptions_rfn.view"
include: "/views/core/sales_orders__lines__cancel_reason_rfn.view"

explore: sales_orders {
  hidden: no
  description: "Retrieve information about sales orders, including both header-level attributes and line-item details."

  always_filter: {
    filters: [order_category_code: "-RETURN", sales_orders__lines.line_category_code: ""]
  }

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
    # no fields from currency conversion needed as all relevant fields are in sales_orders__lines
    fields: []
   }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }

  join: sales_orders__lines__return_line_ids {
    view_label: "Sales Orders: Lines Return Line IDs"
    sql: LEFT JOIN UNNEST(${sales_orders__lines.return_line_ids}) as sales_orders__lines__return_line_ids ;;
    relationship: one_to_many
  }

  # join: sales_orders__lines__item_categories {
  #   view_label: "Sales Orders: Lines Item Categories"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.item_categories}) as sales_orders__lines__item_categories ;;
  #   sql_where: ${sales_orders__lines__item_categories.category_set_name} in ('Unknown',@{category_set}) ;;
  #   relationship: one_to_many
  # }

  # join: sales_orders__lines__item_descriptions {
  #   view_label: "Sales Orders: Lines Item Descriptions"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.item_descriptions}) as sales_orders__lines__item_descriptions ;;
  #   sql_where: ${sales_orders__lines__item_descriptions.language_code} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
  #   relationship: one_to_many
  # }

  # join: sales_orders__lines__cancel_reason {
  #   view_label: "Sales Orders: Lines Cancel Reasons"
  #   sql: LEFT JOIN UNNEST(${sales_orders__lines.cancel_reason}) as sales_orders__lines__cancel_reason ;;
  #   sql_where: ${sales_orders__lines__cancel_reason.language} in ("Unknown", {% parameter otc_common_parameters_xvw.parameter_language %}) ;;
  #   relationship: one_to_many
  # }


}
