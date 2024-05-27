include: "/views/base/sales_orders_daily_agg.view"

view: +sales_orders_daily_agg__lines__amounts {
  label: "Lines Daily Agg"

  dimension: currency_code {
    label: "Currency (Target)"
    full_suggestions: yes
  }

  measure: total_sales_amount {
    type: sum
    description: "Total sales amount in target currency."
    sql: ${total_ordered} ;;
    value_format_name: decimal_0
  }

 }
