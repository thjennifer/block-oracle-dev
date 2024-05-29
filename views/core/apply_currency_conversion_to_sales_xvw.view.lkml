
view: apply_currency_conversion_to_sales_xvw {

  dimension: key {
    type: number
    primary_key: yes
    sql: 1 ;;
  }

  dimension: ordered_amount_target_currency {
    hidden: no
    type: number
    sql: ${sales_orders__lines.ordered_amount} * IF(${sales_orders.currency_code} = {% parameter currency_conversion_sdt.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }


  # dimension: ordered_amount_target_currency {
  #   hidden: no
  #   type: number
  #   sql: ${sales_orders__lines.ordered_amount} * IF(${sales_orders.currency_code} = {% parameter currency_rate_md.parameter_target_currency %}, 1, ${currency_rate_md.conversion_rate})  ;;
  #   value_format_name: decimal_2
  # }

  dimension: shipped_amount_target_currency {
    hidden: no
    type: number
    sql: ${sales_orders__lines.shipped_amount} * IF(${sales_orders.currency_code} = {% parameter currency_conversion_sdt.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  # dimension: shipped_amount_target_currency {
  #   hidden: no
  #   type: number
  #   sql: ${sales_orders__lines.shipped_amount} * IF(${sales_orders.currency_code} = {% parameter currency_rate_md.parameter_target_currency %}, 1, ${currency_rate_md.conversion_rate})  ;;
  #   value_format_name: decimal_2
  # }

  dimension: is_partial_conversion {
    type: yesno
    sql: ${sales_orders.currency_code} <> {% parameter currency_conversion_sdt.parameter_target_currency %} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  # dimension: unable_to_convert {
  #   type: yesno
  #   sql: ${sales_orders.currency_code} <> {% parameter currency_rate_md.parameter_target_currency %} AND ${currency_rate_md.from_currency} is NULL ;;
  # }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if total_sales_amount_target_currency._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of sales for order lines in target currency {{currency}}"
    sql: ${ordered_amount_target_currency} ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    value_format_name: format_large_numbers_d1
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    label: "{% if average_sales_amount_per_order_target_currency._is_selected %}@{derive_currency_label}Average Sales Amount per Order ({{currency}}){%else%}Average Sales Amount per Order (Target Currency){%endif%}"
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},${sales_orders.count})  ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    value_format_name: format_large_numbers_d1
  }

  measure: total_fulfilled_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if total_fulfilled_amount_target_currency._is_selected %}@{derive_currency_label}Total Fulfilled Amount ({{currency}}){%else%}Total Fulfilled Amount (Target Currency){%endif%}"
    sql: ${ordered_amount_target_currency} ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    filters: [sales_orders__lines.is_fulfilled: "Yes"]
    value_format_name: format_large_numbers_d1
  }

  measure: total_shipped_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if total_shipped_amount_target_currency._is_selected %}@{derive_currency_label}Total Shipped Amount ({{currency}}){%else%}Total Shipped Amount (Target Currency){%endif%}"

    # label: "@{derive_currency_label}Total Shipped Amount ({{currency}})"
    # description: "@{derive_currency_label}Sum of sales for order lines in target currency {{currency}}"
    sql: ${shipped_amount_target_currency} ;;
    sql_distinct_key: ${sales_orders__lines.key};;
    value_format_name: format_large_numbers_d1
  }

   }
