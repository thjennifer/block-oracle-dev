#########################################################{
# PURPOSE
# Provides Days Sales Outstanding (DSO) values for each
# Target Currency and DSO days combination.
#
# SOURCES
# base view sales_payments_dso_days_agg_pdt
#
# REFERENCED BY
#   LookML dashboards:
#     otc_billing_accounts_receivable
#
# REQUIRED FILTERS
#   - Because this aggregates to multiple values of target_currency_code and
#     dso_days (30, 90 or 365) these dimensions are included as required filters:
#       TARGET_CURRENCY_CODE with default = value in the user attribute cortex_oracle_ebs_default_currency
#       DSO_DAYS_STRING with default of 365.
#   - Users can change filter values as necessary.
#
# OTHER NOTES
#   - The view definition for sales_payments_dso_days_agg_pdt includes a subset of the available fields.
#     To include/exclude additional fields in the Explore, refer to the view definition and
#     adjust a field's hidden property.
#
#   - The common parameter named parameter_language is not used in this Explore so the FIELDS property excludes it.
#
#########################################################}

include: "/views/core/sales_payments_dso_days_agg_pdt.view"

explore: sales_payments_dso_days_agg_pdt {
  label: "Sales Payments Days Sales Outstanding (DSO) Aggregate"
  description: "Provides Days Sales Outstanding (DSO) values for each Target Currency and DSO Days combination."

  always_filter: {
  filters: [target_currency_code: "{{ _user_attributes['cortex_oracle_ebs_default_currency'] }}",
            dso_days_string: "365"]
  }


}
