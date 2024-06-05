include: "/views/core/sales_orders_rfn.view"

view: apply_currency_conversion_to_sales_xvw {

  dimension: key {
    type: number
    primary_key: yes
    sql: 1 ;;
  }

  dimension: ordered_amount_target_currency {
    hidden: no
    type: number
    sql: ${sales_orders__lines.ordered_amount} * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: no
    type: number
    sql: ${sales_orders__lines.shipped_amount} * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: is_incomplete_conversion {
    type: yesno
    sql: ${sales_orders.currency_code} <> {% parameter otc_common_parameters_xvw.parameter_target_currency %} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of sales for order lines in target currency {{currency}}"
    sql: ${ordered_amount_target_currency} ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    value_format_name: format_large_numbers_d1
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Sales Amount per Order ({{currency}}){%else%}Average Sales Amount per Order (Target Currency){%endif%}"
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},${sales_orders.non_cancelled_order_count})  ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    value_format_name: decimal_2
  }

  measure: total_fulfilled_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Fulfilled Amount ({{currency}}){%else%}Total Fulfilled Amount (Target Currency){%endif%}"
    sql: ${ordered_amount_target_currency} ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    filters: [sales_orders__lines.is_fulfilled: "Yes"]
    value_format_name: format_large_numbers_d1
  }

  measure: total_shipped_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Shipped Amount ({{currency}}){%else%}Total Shipped Amount (Target Currency){%endif%}"

    # label: "@{derive_currency_label}Total Shipped Amount ({{currency}})"
    # description: "@{derive_currency_label}Sum of sales for order lines in target currency {{currency}}"
    sql: ${shipped_amount_target_currency} ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    value_format_name: format_large_numbers_d1
  }

  measure: alert_is_incomplete_conversion {
    hidden: no
    type: max
    sql: ${is_incomplete_conversion} ;;
    html:
          {% if value == true %}For timeframe and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }

   }