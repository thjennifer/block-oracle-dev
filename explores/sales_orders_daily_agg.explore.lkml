#########################################################{
# PURPOSE
# Provides daily sales totals by Business Unit, Order Source, and Sold To/Bill To/Ship To Customer.
# Also includes amounts in one or more Target Currencies for Item Categories.
#
# SOURCES
# see include: statements
#
# REFERENCED BY
#   LookML dashboards:
#     otc_order_status
#     otc_order_sales_performance
#     otc_order_fulfillment
#
# CATEGORY SET NAME
#   - This Explore will show only 1 Category Set Name based on the value in the user attribute
#     cortex_oracle_ebs_category_set_name (see constant category_set in Manifest file).
#   - Users can set the value for the user attribute through Account properties. Or an Admin can set the value for a group of users.
#   - This filter condition is defined in the JOIN properties for view sales_orders_daily_agg__lines.
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the parameter value on provided LookML dashboards or Explore.
#       * In the provided LookML dashboards, the default value for this parameter is based on the value in
#         the user attribute cortex_oracle_ebs_default_currency.
#   - This filter condition is defined in two spots:
#     1. the JOIN properties for optional view sales_orders_daily_agg__lines__amounts
#     2. in the view sales_orders_daily_agg__lines for amount dimensions
#
# REQUIRED FILTERS
#   Because orders can be either ORDER, RETURN or mixture, users will be prompted with these
#   required filters:
#     - Order Category Code with default of IS NOT RETURN
#     - Line Category Code with default of ANY VALUE
#   Users can change filter values as necessary.
#
# OTHER NOTES
#   - The view definitions for sales_orders_daily_agg and sales_orders_daily_agg__lines include a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definitions and
#     adjust a field's hidden property.
#
#   - Amounts are defined in sales_orders_daily_agg__lines so the unnested view
#     sales_orders_daily_agg__lines__amounts does not need to be included in the Explore.
#     However, you can optionally include by uncommenting the join statement below.
#
#   - The common parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}


include: "/views/core/sales_orders_daily_agg_rfn.view"
include: "/views/core/sales_orders_daily_agg__lines_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"

#--> optional (uncomment JOIN statement if needed)
include: "/views/core/sales_orders_daily_agg__lines__amounts_rfn.view"


explore: sales_orders_daily_agg {
  hidden: no
  label: "Sales Orders Daily Aggregate"
  description: "Provides Daily Sales Totals by Business Unit, Order Source, and Sold To/Bill To/Ship To Customer. Also includes Amounts in Target Currencies for Item Categories."

  always_filter: {
    filters: [order_category_code: "-RETURN", sales_orders_daily_agg__lines.line_category_code: ""]
  }

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: sales_orders_daily_agg__lines {
    view_label: "Sales Orders Daily Agg: Item Categories"
    sql: LEFT JOIN UNNEST(${sales_orders_daily_agg.lines}) as sales_orders_daily_agg__lines ;;
    sql_where: ${sales_orders_daily_agg__lines.category_set_name} in ('Unknown',@{category_set}) ;;
    relationship: one_to_many
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }

  # join: sales_orders_daily_agg__lines__amounts {
  #   view_label: "Sales Orders Daily Agg: Item Categories Amounts"
  #   sql: LEFT JOIN UNNEST(${sales_orders_daily_agg__lines.amounts}) as sales_orders_daily_agg__lines__amounts ;;
  #   sql_where: ${sales_orders_daily_agg__lines__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  #   relationship: one_to_many
  # }

}
