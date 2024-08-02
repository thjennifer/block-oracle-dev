#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions for measures
# used in both sales_payments and sales_payments_daily_agg
#
# To use extend into desired view.
#
# Defines label/descriptions for:
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
#########################################################}

view: sales_payments_common_fields_ext {
  extension: required

  measure: total_amount_adjusted_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${amount_adjusted_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${amount_applied_target_currency} * if(${payment_class_code} = 'CM',-1,1) ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${amount_due_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}Tax Amount Original (@{label_get_target_currency}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}Tax Amount Remaining (@{label_get_target_currency}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_receivables_target_currency {
    hidden: no
    type: sum
    label: "@{label_build}"
    sql: ${amount_due_remaining_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: format_large_numbers_d1
    # value_format_name: decimal_2
  }

  measure: total_amount_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}Total Original Invoice Amount (@{label_get_target_currency}){%else%}Total Original Invoice Amount (Target Currency){%endif%}"
    sql: ${amount_due_original_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: format_large_numbers_d1
    # value_format_name: decimal_2
  }

  measure: total_overdue_receivables_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}Past Due Receivables (@{label_get_target_currency}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: ${overdue_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_doubtful_receivables_target_currency {
    hidden: no
    type: sum
    label: "@{label_build_minus_total}"
    sql: ${doubtful_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: percent_of_total_receivables {
    type: percent_of_total
    sql: ${total_receivables_target_currency} ;;
  }

  measure: cumulative_total_receivables {
    type: running_total
    sql: ${total_receivables_target_currency} ;;
    direction: "column"
  }




}
