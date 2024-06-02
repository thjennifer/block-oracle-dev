include: "/views/base/sales_orders_daily_agg.view"

view: +sales_orders_daily_agg__lines__amounts {
  label: "Lines Daily Agg"

  fields_hidden_by_default: yes

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg__lines.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  dimension: target_currency_code {
    hidden: no
    label: "Currency (Target)"
    full_suggestions: yes
    sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
    description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
    sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    description: "Total sales amount in target currency."
    sql: ${total_ordered} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_invoiced_amount_target_currency {
    hidden: no
    type: sum
    description: "Total sales amount in target currency."
    sql: ${total_invoiced} ;;
    value_format_name: format_large_numbers_d1
  }

 }