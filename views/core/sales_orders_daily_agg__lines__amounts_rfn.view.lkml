include: "/views/base/sales_orders_daily_agg__lines__amounts.view"
include: "/views/core/sales_orders__lines_common_fields_ext.view"

view: +sales_orders_daily_agg__lines__amounts {

  fields_hidden_by_default: yes
  extends: [sales_orders__lines_common_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg__lines.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  dimension: target_currency_code {
    hidden: no
    label: "Currency (Target)"
    full_suggestions: yes
    sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
    description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
    sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    # description: "Total sales amount in target currency."
    sql: ${total_ordered} ;;
    filters: [sales_orders_daily_agg.order_category_code: "-RETURN"]
    # value_format_name: format_large_numbers_d1
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders__lines_common_fields_ext
    #description defined in sales_orders__lines_common_fields_ext
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_sales_order_count})) ;;
    #value format defined in sales_orders__lines_common_fields_ext
  }

  measure: total_invoiced_amount_target_currency {
    hidden: no
    type: sum
    description: "Total sales amount in target currency."
    sql: ${total_invoiced} ;;
    value_format_name: format_large_numbers_d1
  }

 }