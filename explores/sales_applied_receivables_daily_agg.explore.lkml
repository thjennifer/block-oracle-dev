#########################################################{
# PURPOSE
# Provides daily receipt and applied amount totals by Business Unit, Bill To Customer, and Application Type.
# Also includes amounts in one or more target currencies.
#
# SOURCES
# base view: sales_applied_receivables_daily_agg
# see include: statements for other views
#
# REFERENCED BY
#   Not referenced as amount applied also found in sales_payments_daily_agg explore
#
# TARGET CURRENCY CODE
#   - This Explore shows only 1 Target Currency at a time based on the value in
#     parameter_target_currency.
#       * Users can change the parameter value in provided Explore.
#   - This filter condition is defined in two spots:
#     1. the JOIN properties for optional view sales_applied_receivables_daily_agg__amounts
#     2. in the view sales_applied_receivables_daily_agg for amount dimensions
##
# OTHER NOTES
#   - The view definitions for sales_applied_receivables_daily_agg include a subset of the available fields.
#     To include/exclude fields in the Explore, refer to the view definitions and
#     adjust a field's hidden property.
#
#   - Amounts are defined in sales_applied_receivables_daily_agg so the unnested view
#     sales_applied_receivables_daily_agg__amounts does not need to be included in the Explore.
#     However, you can optionally include by uncommenting the join statement below.
#
#   - The common parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}

include: "/views/core/sales_applied_receivables_daily_agg_rfn.view"
include: "/views/core/sales_applied_receivables_daily_agg__amounts_rfn.view"
include: "/views/core/otc_common_parameters_xvw.view"


explore: sales_applied_receivables_daily_agg {
  hidden: no
  label: "Sales Applied Receivables Daily Aggregate"
  description: "Provides daily cash receipt and applied amount totals by Business Unit, Bill To Customer, and Application Type in one or more target currencies."

  fields: [ALL_FIELDS*,-otc_common_parameters_xvw.parameter_language]

    join: otc_common_parameters_xvw {
      relationship: one_to_one
      sql:  ;;
    }

    # join: sales_applied_receivables_daily_agg__amounts {
    #   view_label: "Sales Applied Receivables Daily Agg: Amounts"
    #   sql: LEFT JOIN UNNEST(${sales_applied_receivables_daily_agg.amounts}) as sales_applied_receivables_daily_agg__amounts ;;
    #   sql_where: ${sales_applied_receivables_daily_agg__amounts.target_currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
    #   relationship: one_to_many
    # }
}
