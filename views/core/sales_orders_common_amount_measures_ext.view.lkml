#########################################################{
# PURPOSE
# Provide the same labels/descriptions for AMOUNT measures
# used in:
#    sales_orders__lines
#    sales_orders_daily_agg__lines
#    sales_orders_daily_agg__lines__amounts
#
# To use, extend into desired view.
#
# Defines label/descriptions for:
#   average_sales_amount_per_order_target_currency
#
# Fully defines these measures including sql: property:
#   total_ordered_amount_target_currency
#   total_sales_amount_target_currency
#   total_invoiced_amount_target_currency
#   total_invoiced_sales_amount_target_currency
#   total_ordered_amount_target_currency_formatted
#   total_sales_amount_target_currency_formatted
#   total_invoiced_amount_target_currency_formatted
#   total_invoiced_sales_amount_target_currency_formatted
#   alert_is_incomplete_conversion
#########################################################}


view: sales_orders_common_amount_measures_ext {

  extension: required


  measure: total_ordered_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Ordered Amount ({{currency}}){%else%}Total Ordered Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of ordered amount in target currency {{currency}}"
    sql: ${ordered_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_ordered_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Ordered Amount ({{currency}}){%else%}Total Ordered Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of ordered amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_sales_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of sales in target currency {{currency}}"
    sql: ${ordered_amount_target_currency} ;;
    filters: [is_sales_order: "Yes"]
    value_format_name: decimal_0
  }

  measure: total_sales_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of sales in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_sales_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_invoiced_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoiced Amount ({{currency}}){%else%}Total Invoiced Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of invoiced amount in target currency {{currency}}"
    sql: ${invoiced_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_invoiced_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoiced Amount ({{currency}}){%else%}Total Invoiced Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of invoiced amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_invoiced_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_invoiced_sales_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoiced Amount of Sales Orders ({{currency}}){%else%}Total Invoiced Amount of Sales Orders (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of invoiced amount of sales orders in target currency {{currency}}"
    sql: ${invoiced_amount_target_currency} ;;
    filters: [is_sales_order: "Yes"]
    value_format_name: decimal_0
  }

  measure: total_invoiced_sales_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoiced Amount of Sales Orders ({{currency}}){%else%}Total Invoiced Amount of Sales Orders (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of invoiced amount of sales orders in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_invoiced_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: average_sales_amount_per_order_target_currency {
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Sales Amount per Order ({{currency}}){%else%}Average Sales Amount per Order (Target Currency){%endif%}"
    value_format_name: decimal_0
  }

  measure: alert_note_for_incomplete_currency_conversion {
    hidden: no
    type: max
    description: "Provides a note in html when a source currency could not be converted to target currency. Add this measure to a table or single value visualization to alert users that amounts in target currency may be understated."
    sql: ${is_incomplete_conversion} ;;
    html: {% if value == true %}For timeframe and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }

  }