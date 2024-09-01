#########################################################{
# PURPOSE
# Provides daily payment totals by Business Unit, Bill To Customer, and Payment Class Code.
# Also includes amounts like Amount Due Original, Amount Due Remaining, and other totals
# in one or more target currencies."
#
# SOURCES
# base view: sales_payments_daily_agg
# see include: statements for other views
#
# REFERENCED BY
#   LookML dashboards:
#     otc_billing_and_invoicing
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the parameter value on provided LookML dashboards or Explore.
#       * In the provided LookML dashboards, the default value for this parameter is the value in
#         the user attribute cortex_oracle_ebs_default_currency.
#   - This filter condition is defined in two spots:
#     1. the JOIN properties for optional view sales_payments_daily_agg__amounts
#     2. in the view sales_payments_daily_agg for amount dimensions
#
# REQUIRED FILTERS
#   - Because payments can be either related to Cash Receipts or Invoices, users will be prompted with
#     this required filter:
#       IS_PAYMENT_TRANSACTION with default of "No" (to focus on invoices)
#   - Users can change filter values as necessary.
#
# OTHER NOTES
#   - The view definitions for sales_payments_daily_agg include a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definitions and
#     adjust a field's hidden property.
#
#   - Amounts are defined in sales_payments_daily_agg so the unnested view
#     sales_payments_daily_agg__amounts does not need to be included in the Explore.
#     However, you can optionally include by uncommenting the join statement below.
#
#   - The common parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}

include: "/views/core/sales_payments_daily_agg_rfn.view"
include: "/views/core/sales_payments_daily_agg__amounts_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"

explore: sales_payments_daily_agg {
  label: "Sales Payments Daily Aggregate"
  description: "Provides daily payment totals by Business Unit, Bill To Customer, and Payment Class Code. Also includes amounts like Amount Due Original, Amount Due Remaining, and other totals in one or more target currencies."

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  always_filter: {
    filters: [sales_payments_daily_agg.is_payment_transaction: "No"]
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }

  # join: sales_payments_daily_agg__amounts {
  #   view_label: "Sales Payments Daily Agg: Amounts"
  #   sql: LEFT JOIN UNNEST(${sales_payments_daily_agg.amounts}) as sales_payments_daily_agg__amounts ;;
  #   sql_where: ${sales_payments_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  #   relationship: one_to_many
  # }

}
