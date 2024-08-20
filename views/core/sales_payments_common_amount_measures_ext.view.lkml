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
    label: "@{label_build_minus_total}"
    sql: ${amount_adjusted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build_minus_total}"
    sql: ${amount_applied_target_currency} * if(${payment_class_code} = 'CM',-1,1) ;;
    value_format_name: decimal_2
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build_minus_total}"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build_minus_total}"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build_minus_total}"
    sql: ${amount_due_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build_minus_total}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Original (@{label_get_target_currency}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Remaining (@{label_get_target_currency}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_due_remaining_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: decimal_2
  }

  measure: total_amount_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Total Original Invoice Amount (@{label_get_target_currency}){%else%}Total Original Invoice Amount (Target Currency){%endif%}"
    sql: ${amount_due_original_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: decimal_2
  }

  measure: total_overdue_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Past Due Receivables (@{label_get_target_currency}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: ${overdue_receivables_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_doubtful_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build_minus_total}"
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
    label: "@{label_build}"
    sql: ${total_receivables_target_currency} ;;
    direction: "column"
    value_format_name: decimal_2
  }

#} end amount measures

#########################################################
# MEASURES: Formatted Amounts
#{
# Formatted as large numbers. Also use html formatting defined
# in constant format_big_numbers to handle negative totals

  measure: total_amount_adjusted_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_amount_adjusted_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_amount_applied_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_amount_applied_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_amount_credited_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_amount_credited_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_amount_discounted_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_amount_discounted_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_amount_due_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_amount_due_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_amount_due_remaining_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_amount_due_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_tax_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{%- if _field._is_selected -%}Tax Amount Original (@{label_get_target_currency}){%- else -%}Tax Amount Original (Target Currency) Formatted {%- endif -%}"
    sql: ${total_tax_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_tax_remaining_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{%- if _field._is_selected -%}Tax Amount Remaining (@{label_get_target_currency}){%- else -%}Tax Amount Remaining (Target Currency) Formatted {%- endif -%}"
    sql: ${total_tax_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    sql: ${total_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_amount_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{%- if _field._is_selected -%}Total Original Invoice Amount (@{label_get_target_currency}){%- else -%}Total Original Invoice Amount (Target Currency) Formatted {%- endif -%}"
    sql: ${total_amount_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_overdue_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{%- if _field._is_selected -%}Past Due Receivables (@{label_get_target_currency}){%- else -%}Past Due Receivables (Target Currency) Formatted {%- endif -%}"
    sql: ${total_overdue_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: total_doubtful_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_minus_total_formatted}"
    sql: ${total_doubtful_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

  measure: cumulative_total_receivables_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    sql: ${cumulative_total_receivables} ;;
    value_format_name: format_large_numbers_d1
    html: @{format_big_numbers} ;;
  }

#} end formatted amounts



}
