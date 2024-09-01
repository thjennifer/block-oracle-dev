#########################################################{
# PURPOSE
# Retrieve information about cash receipts and applied amounts,
#
# SOURCES
# base view: sales_applied_receivables
# see include: statements for other views
#
# REFERENCED BY
#   Not referenced as amount applied also found in sales_payments explore
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the parameter value in the Explore.
#   - This filter condition is applied in the view currency_conversion_sdt.
##
# OTHER NOTES
#   - The view definition for sales_applied_receivables includes a subset of the available fields.
#     To include/exclude fields in the Explore, refer to the view definition and
#     adjust a field's hidden property.
#
#   - The common parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}

include: "/views/core/sales_applied_receivables_rfn.view"
include: "/views/core/currency_conversion_sdt.view"
include: "/views/core/otc_common_parameters_xvw.view"

explore: sales_applied_receivables {
  description: "Provides details about cash receipts and applied amounts."

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

  join: currency_conversion_sdt {
    type: left_outer
    sql_on:  ${sales_applied_receivables.exchange_raw} = ${currency_conversion_sdt.conversion_date} AND
             ${sales_applied_receivables.currency_code} = ${currency_conversion_sdt.from_currency} ;;
    relationship: many_to_one
    # no fields from currency conversion needed as all relevant fields are in sales_invoices__lines
    fields: []
}

  join: otc_common_parameters_xvw {
    relationship: one_to_one
    sql:  ;;
}

}
