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
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
    sql: ${amount_adjusted_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: ${amount_applied_target_currency} * if(${payment_class_code} = 'CM',-1,1) ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Credited ({{currency}}){%else%}Amount Credited (Target Currency){%endif%}"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Discounted ({{currency}}){%else%}Amount Discounted (Target Currency){%endif%}"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Original ({{currency}}){%else%}Amount Due Original (Target Currency){%endif%}"
    sql: ${amount_due_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Remaining ({{currency}}){%else%}Amount Due Remaining (Target Currency){%endif%}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Original ({{currency}}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Remaining ({{currency}}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_receivables_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Receivables ({{currency}}){%else%}Total Receivables (Target Currency){%endif%}"
    sql: ${amount_due_remaining_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: format_large_numbers_d1
  }

  measure: total_overdue_receivables_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Past Due Receivables ({{currency}}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: ${overdue_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_doubtful_receivables_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Doubtful Receivables ({{currency}}){%else%}Doubtful Receivables (Target Currency){%endif%}"
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
