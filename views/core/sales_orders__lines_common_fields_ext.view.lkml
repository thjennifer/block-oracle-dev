#########################################################{
# PURPOSE
# Provide the same labels/descriptions for measures
# used in both sales_orders__lines and sales_orders_daily_agg__lines and sales_orders_daily_agg__lines__amounts
#
# To use, extend into desired view.
#
# Defines label/descriptions for:
#   total_sales_amount_target_currency
#   average_sales_amount_per_order_target_currency
#
# Fully defines these measures including sql: property:
#   alert_is_incomplete_conversion
#########################################################}


view: sales_orders__lines_common_fields_ext {
  extension: required


  measure: total_sales_amount_target_currency {
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of sales in target currency {{currency}}"
    value_format_name: format_large_numbers_d1
  }

  measure: average_sales_amount_per_order_target_currency {
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Sales Amount per Order ({{currency}}){%else%}Average Sales Amount per Order (Target Currency){%endif%}"
    value_format_name: decimal_2
  }

  measure: alert_note_for_incomplete_currency_conversion {
    hidden: no
    type: max
    description: "Provides a note in html when a source currency could not be converted to target currency. Add this measure to a table or single value visualization to alert users that amounts in target currency may be understated."
    sql: ${is_incomplete_conversion} ;;
    html: {% if value == true %}For timeframe and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }

   }
