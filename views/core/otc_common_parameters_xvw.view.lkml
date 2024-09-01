#########################################################{
# PURPOSE
# Provides consistent definitions and labels for parameters used in OTC-related Explores.
#   parameter_target_currency
#   parameter_language
#   parameter_category_set_name (hidden)
#
# REFERENCED BY
#   Explores:
#     sales_orders
#     sales_orders_daily_agg
#     sales_invoices
#     sales_invoices_daily_agg
#     sales_payments
#     sales_payments_daily_agg
#     sales_applied_receivables
#     sales_applied_receivables_daily_agg
#
# NOTE
#   - parameter_category_set_name is hidden and does not
#     appear in any Explores. Instead category_set_name value is filtered to
#     match user attribute 'cortex_oracle_ebs_category_set_name'
#
#     To enable users to switch values using this parameter:
#       1. Unhide the parameter.
#       2. Set the default value of parameter to the desired option.
#       3. Replace references to the user attribute value with the parameter value.
#           e.g., replace _user_attributes['cortex_oracle_ebs_category_set_name'] with
#           otc_common_parameters_xvw.parameter_category_set_name._parameter_value
#
#########################################################}

view: otc_common_parameters_xvw {
  label: "@{label_view_for_filters}"

  parameter: parameter_target_currency {
    hidden: no
    type: string
    label: "Target Currency"
    description: "When converting amounts, choose the desired currency"
    suggest_explore: currency_rate_md
    suggest_dimension: currency_rate_md.to_currency
    default_value: "USD"
  }

  parameter: parameter_language {
    hidden: no
    type: string
    label: "Language"
    description: "Select language to display for item descriptions. Default is 'US'"
    suggest_explore: item_md
    suggest_dimension: item_md__item_descriptions.language_code
    default_value: "US"
  }

  parameter: parameter_category_set_name {
    hidden: yes
    type: string
    label: "Category Set Name"
    suggest_explore: item_md
    suggest_dimension: item_md__item_categories.category_set_name
    default_value: "BE_INV_ITEM_CATEGORY_SET"
  }




 }
