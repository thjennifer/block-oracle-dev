#########################################################{
# PURPOSE
# Provides daily invoice totals by Business Unit, Bill To Customer, Invoice Type, and Order Source.
# Also includes amounts in one or more Target Currencies for Item Categories.
#
# SOURCES
# see include: statements
#
# REFERENCED BY
#   LookML dashboards:
#     otc_billing_and_invoicing
#
# CATEGORY SET NAME
#   - This Explore will show only 1 Category Set Name based on the value in the user attribute
#     cortex_oracle_ebs_category_set_name (see constant category_set in Manifest file).
#   - Users can set the value for the user attribute through Account properties. Or an Admin can set the value for a group of users.
#   - This filter condition is defined in the SQL_ALWAYS_WHERE statement of the Explore.
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the value of the parameter on provided LookML dashboards or Explore.
#       * In the provided LookML dashboards, the default value for this parameter is the value in
#         the user attribute cortex_oracle_ebs_default_currency.
#   - This filter condition is defined in two spots:
#     1. the JOIN properties for optional view sales_invoices_daily_agg__amounts
#     2. in the view sales_invoices_daily_agg for amount dimensions
#
# OTHER NOTES
#   - The view definitions for sales_invoices_daily_agg include a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definitions and
#     adjust a field's hidden property.
#
#   - Amounts are defined in sales_invoices_daily_agg so the unnested view
#     sales_invoices_daily_agg__amounts does not need to be included in the Explore.
#     However, you can optionally include by uncommenting the join statement below.
#
#   - The parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}

include: "/views/core/sales_invoices_daily_agg_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"
#--> optional -- uncomment join statement below if needed
include: "/views/core/sales_invoices_daily_agg__amounts_rfn.view"

explore: sales_invoices_daily_agg {
  hidden: no
  label: "Sales Invoices Daily Aggregate"
  description: "Provides daily invoice totals by Business Unit, Bill To Customer, Invoice Type, Order Source and Item Category. Also includes Invoice Amount and other totals in one or more target currencies."


  sql_always_where: COALESCE(ITEM_CATEGORY_SET_NAME,'Unknown') in ('Unknown',@{category_set}) ;;

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }

  # join: sales_invoices_daily_agg__amounts {
  #   view_label: "Sales Invoices Daily Agg: Amounts"
  #   sql: LEFT JOIN UNNEST(${sales_invoices_daily_agg.amounts}) as sales_invoices_daily_agg__amounts ;;
  #   sql_where: ${sales_invoices_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  #   relationship: one_to_many
  # }
}
