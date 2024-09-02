#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions for
# target currency fields used in:
#     sales_payments
#     sales_payments_daily_agg
#     sales_payments_daily_agg__amounts
#
# To use, extend into the desired view.
#
# Define all but sql: property for amount dimensions:
#   amount_adjusted_target_currency
#   amount_applied_target_currency
#   amount_credited_target_currency
#   amount_discounted_target_currency
#   amount_due_original_target_currency
#   amount_due_remaining_target_currency
#   tax_original_target_currency
#   tax_remaining_target_currency
#   overdue_receivables_target_currency
#   doubtful_receivables_target_currency
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

view: sales_payments_common_amount_fields_ext {
  extension: required

#########################################################
# DIMENSIONS: Amounts
#{
# define all but SQL property
  dimension: amount_adjusted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the amount adjusted across payments converted to target currency
    {%- else -%}Amount adjusted converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the amount applied across payments converted to target currency
    {%- else -%}Amount applied converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the amount credited across payments converted to target currency
    {%- else -%}Amount credited converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the amount discounted across payments converted to target currency
    {%- else -%}Amount discounted converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the amount due originally across payments converted to target currency
    {%- else -%}Amount due originally converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the amount due remaining across payments converted to target currency
    {%- else -%}Amount due remaining converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Original' -%}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the original tax amount across payments converted to target currency
    {%- else -%}Original tax amount charged on the transaction converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Remaining' -%}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the remaining tax amount across payments converted to target currency
    {%- else -%}Remaining tax amount charged on the transaction converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Past Due Receivables' -%}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the overdue remaining amount across payments converted to target currency
    {%- else -%}Amount still remaining for open and overdue invoices converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of the doubtful overdue remaining amount across payments converted to target currency
    {%- else -%}Amount still remaining for invoices more than 90 days overdue converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

#} end amount dimensions

#########################################################
# MEASURES: Amounts
#{
  measure: total_amount_adjusted_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount adjusted in target currency"
    sql: ${amount_adjusted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount applied in target currency. Note, the total includes credit memo amounts added as positive values instead of negative ones"
    sql: ${amount_applied_target_currency} * if(${payment_class_code} = 'CM',-1,1) ;;
    value_format_name: decimal_2
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount credited in target currency"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount discounted in target currency"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount due originally in target currency"
    sql: ${amount_due_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount due remaining in target currency"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Original' -%}@{label_currency_if_selected}"
    description: "Total original tax amount charged in target currency"
    sql: ${tax_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Remaining' -%}@{label_currency_if_selected}"
    description: "Total of remaining tax amount charged on the transaction in target currency"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount due remaining in target currency where payment class code <> 'PMT'"
    sql: ${amount_due_remaining_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: decimal_2
  }

  measure: total_amount_original_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Total Original Invoice Amount' -%}@{label_currency_if_selected}"
    description: "Total amount due originally in target currency where payment class code <> 'PMT'"
    sql: ${amount_due_original_target_currency} ;;
    filters: [payment_class_code: "-PMT"]
    value_format_name: decimal_2
  }

  measure: total_overdue_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Past Due Receivables' -%}@{label_currency_if_selected}"
    description: "Total amount in target currency still remaining for open and overdue invoices"
    sql: ${overdue_receivables_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_doubtful_receivables_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount in target currency still remaining for invoice more than 90 days overdue"
    sql: ${doubtful_receivables_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: percent_of_total_receivables {
    hidden: no
    type: percent_of_total
    description: "Percent of total receivables (amount due remaining)"
    sql: ${total_receivables_target_currency} ;;
  }

  measure: cumulative_total_receivables {
    hidden: no
    type: running_total
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Cumulative total of receivables (amount due remaining)"
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
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount adjusted in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_adjusted_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_applied_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount applied in target currency. Note, the total includes credit memo amounts added as positive values instead of negative ones. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_applied_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_credited_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount credited in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_credited_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_discounted_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount discounted in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_discounted_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_due_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount due originally in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_due_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_due_remaining_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount due remaining in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_due_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_tax_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Tax Amount Original' -%}@{label_currency_if_selected}"
    description: "Total original tax amount charged in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_tax_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_tax_remaining_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Tax Amount Remaining' -%}@{label_currency_if_selected}"
    description: "Total remaining tax amount charged in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_tax_remaining_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount due remaining in target currency where payment class code <> 'PMT'. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_original_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Total Original Invoice Amount' -%}@{label_currency_if_selected}"
    description: "Total amount due originally in target currency where payment class code <> 'PMT'. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_original_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_overdue_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Past Due Receivables' -%}@{label_currency_if_selected}"
    description: "Total amount in target currency still remaining for open and overdue invoices. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_overdue_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_doubtful_receivables_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign remove_total_prefix = true -%}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount in target currency still remaining for invoice more than 90 days overdue and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_doubtful_receivables_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: cumulative_total_receivables_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Cumulative total of receivables (amount due remaining). Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${cumulative_total_receivables} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

#} end formatted amounts



}
