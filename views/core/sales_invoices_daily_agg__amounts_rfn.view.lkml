#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT amounts found in sales_invoices_daily_agg table.
# Provides amounts by target_currency_code and is_incomplete_conversion
#
# SOURCES
#   Refines View sales_invoices_daily_agg__amounts
#   Extends Views:
#     otc_common_currency_fields_ext
#     sales_invoices_common_amount_measures_ext
#
# REFERENCED BY
# not used but could optionally be added to sales_invoices_daily_agg explore
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion
#   total_transaction_amount_target_currency, total_tax_amount_target_currency, and other amounts
#
# NOTES
# - Amounts where target currency matches the value of parameter_target_currency are pulled into
#   sales_invoices_daily_agg so this view is not used
# - Original fields TOTAL_REVENUE, etc... replaced with dimensions like revenue_amount_target_currency to
#   faciltate extending invoice amount measures across multiple views.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_invoices_daily_agg__amounts.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_invoices_common_amount_measures_ext.view"

view: +sales_invoices_daily_agg__amounts {

  fields_hidden_by_default: yes
  extends: [otc_common_currency_fields_ext, sales_invoices_common_amount_measures_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_invoices_daily_agg.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  dimension: target_currency_code {
    # label defined in otc_common_currency_fields_ext
    description:  "Code indicating the target currency into which the source currency is converted"
    sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
    full_suggestions: yes
  }

  dimension: is_incomplete_conversion {
    # label defined in otc_common_currency_fields_ext
    description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD. If yes, should check if CurrencyRateMD table is missing any dates or currencies"
    sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
    full_suggestions: yes
  }

  dimension: revenue_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of revenue amounts across all lines converted to target currency"
    sql: ${total_revenue} ;;
    value_format_name: decimal_2
  }

  dimension: transaction_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Invoice Amount' -%}@{label_currency_if_selected}"
    description: "Sum of pre-tax transaction amounts across all lines converted to target currency"
    sql: ${total_transaction};;
    value_format_name: decimal_2
  }

  dimension: tax_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of tax amounts across all lines converted to target currency"
    sql: ${total_tax} ;;
    value_format_name: decimal_2
  }

  dimension: discount_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of discount amounts across all lines converted to target currency"
    sql: ${total_discount}  ;;
    value_format_name: decimal_2
  }



}
