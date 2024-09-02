#########################################################{
# PURPOSE
# Retrieve information about invoice payments including Amount Due Original,
# Amount Due Remaining, and other Account Receivable details.
#
# SOURCES
# base view: sales_payments
# see include: statements for other views
#
# REFERENCED BY
#   LookML dashboards:
#     otc_billing_accounts_receivable
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
#   - Because payments can be either related to Cash Receipts or Invoices, users will be prompted with
#     this required filter:
#       IS_PAYMENT_TRANSACTION with default of "No" (to focus on invoices)
#   - Users can change filter values as necessary.
#
# OTHER NOTES
#   - The view definition for sales_payments includes a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definition and
#     adjust a field's hidden property.
#
#   - The common parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}

include: "/views/core/sales_payments_rfn.view"
include: "/views/core/sales_payments_dynamic_aging_bucket_sdt.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"
include: "/views/core/otc_dashboard_navigation_ext.view"


explore: sales_payments {
  description: "Retrieve information about invoice payments including Amount Due Original, Amount Due Remaining, and other Account Receivable details."
  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  always_filter: {
    filters: [sales_payments.is_payment_transaction: "No"]
  }

  join: currency_conversion_sdt {
    type: left_outer
    sql_on:  ${sales_payments.exchange_raw} = ${currency_conversion_sdt.conversion_date} AND
             ${sales_payments.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_order__lines
    fields: []
  }

  join: sales_payments_dynamic_aging_bucket_sdt {
    view_label: "Sales Payments"
    type: left_outer
    sql_on: COALESCE(${sales_payments.days_overdue},0) BETWEEN ${sales_payments_dynamic_aging_bucket_sdt.start_days} AND ${sales_payments_dynamic_aging_bucket_sdt.end_days} ;;
    relationship: many_to_one
  }

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
  }

  join: otc_dashboard_navigation_ext {
    relationship: one_to_one
    sql:  ;;
  }



}
