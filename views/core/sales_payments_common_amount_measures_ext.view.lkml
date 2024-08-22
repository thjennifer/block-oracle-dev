#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions for measures
# used in:
#     sales_payments
#     sales_payments_daily_agg
#     sales_payments_daily_agg__amounts
#
# To use extend into desired view.
#
# Fully defines these measures including sql: property:
#   total_amount_adjusted_target_currency
#   total_amount_applied_target_currency
#   total_amount_credited_target_currency
#   total_amount_discounted_target_currency
#   total_amount_due_original_target_currency
#   total_amount_due_remaining_target_currency
#   total_tax_original_target_currency
#   total_tax_remaining_target_currency
#   total_receivables_target_currency
#   total_overdue_receivables_target_currency
#   total_doubtful_receivables_target_currency
#   cumulative_total_receivables
#   percent_of_total_receivables
#
# Adds formatting and/or links to these measures for dashboard display:
#   total_amount_adjusted_target_currency_formatted
#   total_amount_applied_target_currency_formatted
#   total_amount_credited_target_currency_formatted
#   total_amount_discounted_target_currency_formatted
#   total_amount_due_original_target_currency_formatted
#   total_amount_due_remaining_target_currency_formatted
#   total_tax_original_target_currency_formatted
#   total_tax_remaining_target_currency_formatted
#   total_receivables_target_currency_formatted
#   total_overdue_receivables_target_currency_formatted
#   total_doubtful_receivables_target_currency_formatted
#   cumulative_total_receivables_formatted
#
#########################################################}

view: sales_payments_common_amount_measures_ext {
  extension: required

#########################################################
# MEASURES: Amounts
#{
  measure: total_amount_adjusted_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_adjusted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_applied_target_currency} * if(${payment_class_code} = 'CM',-1,1) ;;
    value_format_name: decimal_2
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_due_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign field_name = 'Tax Amount Original' -%}@{label_currency_if_selected}"
    sql: ${tax_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign field_name = 'Tax Amount Remaining' -%}@{label_currency_if_selected}"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${amount_due_remaining_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: decimal_2
  }

  measure: total_amount_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign field_name = 'Total Original Invoice Amount' -%}@{label_currency_if_selected}"
    sql: ${amount_due_original_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: decimal_2
  }

  measure: total_overdue_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign field_name = 'Past Due Receivables' -%}@{label_currency_if_selected}"
    sql: ${overdue_receivables_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_doubtful_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${doubtful_receivables_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: percent_of_total_receivables {
    hidden: no
    type: percent_of_total
    sql: ${total_receivables_target_currency} ;;
  }

  measure: cumulative_total_receivables {
    hidden: no
    type: running_total
    group_label: "Amounts"
    label: "@{label_defaults}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_receivables_target_currency} ;;
    direction: "column"
    value_format_name: decimal_2
  }

#} end amount measures

#########################################################
# MEASURES: Formatted Amounts
#{
# Formatted as large numbers. Also use html formatting defined
# in constant html_format_big_numbers to handle negative totals

  measure: total_amount_adjusted_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_amount_adjusted_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_applied_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_amount_applied_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_credited_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_amount_credited_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_discounted_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_amount_discounted_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_due_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_amount_due_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_due_remaining_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_amount_due_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_tax_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Tax Amount Original' -%}@{label_currency_if_selected}"
    sql: ${total_tax_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_tax_remaining_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Tax Amount Remaining' -%}@{label_currency_if_selected}"
    sql: ${total_tax_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Total Original Invoice Amount' -%}@{label_currency_if_selected}"
    sql: ${total_amount_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_overdue_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Past Due Receivables' -%}@{label_currency_if_selected}"
    sql: ${total_overdue_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_doubtful_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_doubtful_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: cumulative_total_receivables_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${cumulative_total_receivables} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

#} end formatted amounts



}