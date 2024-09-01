#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT amounts found in sales_applied_receivables_daily_agg table.
# Provides amounts by target_currency_code and is_incomplete_conversion.
#
# SOURCES
#   Refines View sales_applied_receivables_daily_agg__amounts
#   Extends View:
#     otc_common_currency_fields_ext
#     sales_applied_receivables_common_amount_measures_ext
#
# REFERENCED BY
#   not used but could optionally be added to sales_applied_receivables_daily_agg explore
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#   total_amount_applied_target_currency, total_amount_received_target_currency, etc...
#
# NOTES
# - Amounts where target currency matches the value of parameter_target_currency are pulled into
#   sales_applied_receivables_daily_agg so this view is not used.
# - Original fields TOTAL_APPLIED and TOTAL_RECEIVED replaced with dimensions amount_applied_target_currency
#   and cash_receipt_amount_target_currency to facilitate extending amount measures across multiple views.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_applied_receivables_daily_agg__amounts.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_applied_receivables_common_amount_measures_ext.view"

view: +sales_applied_receivables_daily_agg__amounts {
  fields_hidden_by_default: yes
  extends: [otc_common_currency_fields_ext, sales_applied_receivables_common_amount_measures_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_applied_receivables_daily_agg.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  dimension: target_currency_code {
    #label: defined in otc_common_currency_fields_ext
    sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
    full_suggestions: yes
  }

  dimension: is_incomplete_conversion {
    #label: defined in otc_common_currency_fields_ext
    sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
    full_suggestions: yes
  }

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_applied}  ;;
    value_format_name: decimal_2
  }

  dimension: cash_receipt_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_received}  ;;
    value_format_name: decimal_2
  }

 }
