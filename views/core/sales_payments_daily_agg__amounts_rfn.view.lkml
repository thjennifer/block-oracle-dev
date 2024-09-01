#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT amounts found in sales_payments_daily_agg table.
# Provides amounts by target_currency_code and is_incomplete_conversion.
#
# SOURCES
#   Refines View sales_payments_daily_agg__amounts
#   Extends View:
#     otc_common_currency_fields_ext
#     sales_payments_common_amount_measures_ext
#
# REFERENCED BY
#   not used but could optionally be added to sales_payments_daily_agg explore
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#   total_amount_adjusted_target_currency, total_amount_applied_target_currency, etc...
#
# NOTES
# - Amounts where target currency matches the value of parameter_target_currency are pulled into
#   sales_payments_daily_agg so this view is not used.
# - Original fields TOTAL_AMOUNT_ADJUSTED, etc... replaced with dimensions like amount_adjusted_target_currency to
#   facilitate extending payment amount measures across multiple views.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_payments_daily_agg__amounts.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_payments_common_amount_measures_ext.view"


view: +sales_payments_daily_agg__amounts {
  fields_hidden_by_default: yes
  extends: [otc_common_currency_fields_ext, sales_payments_common_amount_measures_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_payments_daily_agg.key},${target_currency_code},${is_incomplete_conversion}) ;;
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

#--> hidden field referenced by extended measures
  dimension: payment_class_code {
    hidden: yes
    type: string
    sql: ${sales_payments_daily_agg.payment_class_code} ;;
  }

  dimension: amount_adjusted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_adjusted}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_applied}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_credited}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_discounted}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_original}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_remaining}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Original'-%}@{label_currency_if_selected}"
    sql: ${total_tax_original}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Remaining'-%}@{label_currency_if_selected}"
    sql: ${total_tax_remaining}  ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Past Due Receivables'-%}@{label_currency_if_selected}"
    sql: ${total_overdue_remaining}   ;;
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${total_doubtful_remaining}   ;;
    value_format_name: decimal_2
  }


}
