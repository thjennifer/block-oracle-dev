include: "/views/base/sales_orders_daily_agg__lines__amounts.view"
include: "/views/core/sales_orders_common_amount_measures_ext.view"

view: +sales_orders_daily_agg__lines__amounts {

  fields_hidden_by_default: yes
  extends: [sales_orders_common_amount_measures_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg__lines.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

#########################################################
# Amounts as dimensions
#{

  dimension: target_currency_code {
    hidden: no
    label: "Currency (Target)"
    full_suggestions: yes
    sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: ordered_amount_target_currency {
    hidden: no
    sql: ${total_ordered} ;;
    value_format_name: decimal_2
  }

  dimension: booking_amount_target_currency {
    hidden: no
    sql: ${total_booking} ;;
    value_format_name: decimal_2
  }

  dimension: backlog_amount_target_currency {
    hidden: no
    sql: ${total_backlog} ;;
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount_target_currency {
    hidden: no
    sql: ${total_fulfilled} ;;
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: no
    sql: ${total_shipped} ;;
    value_format_name: decimal_2
  }

  dimension: invoiced_amount_target_currency {
    hidden: no
    sql: ${total_invoiced} ;;
    value_format_name: decimal_2
  }



#} end amounts as dimensions

  dimension: is_sales_order {
    hidden: yes
    type: yesno
    sql: ${sales_orders_daily_agg__lines.line_category_code} = 'ORDER' ;;
  }



  dimension: is_incomplete_conversion {
    hidden: no
    description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
    sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders_common_amount_measures_ext
    #description defined in sales_orders_common_amount_measures_ext
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_sales_order_count})) ;;
    #value format defined in sales_orders_common_amount_measures_ext
  }


 }
