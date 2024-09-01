view: sales_applied_receivables_common_amount_measures_ext {
  extension: required

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    description: "Sum of amount applied in target currency"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${amount_applied_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_received_target_currency {
    hidden: no
    type: sum
    description: "Sum of cash receipt amount in target currency"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${cash_receipt_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_applied_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of amount applied in target currency. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_applied_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }

  measure: total_amount_received_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of amount applied in target currency. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_amount_received_target_currency} ;;
    value_format_name: format_large_numbers_d1
    html: @{html_format_big_numbers} ;;
  }
 }
