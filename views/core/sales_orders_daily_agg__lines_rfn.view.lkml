  # set full suggestions to yes so that filter suggestions populate properly for nested fields
  # value of yes means Looker queries the nest field as part of the full explore rather than a standalone table

include: "/views/base/sales_orders_daily_agg.view"

view: +sales_orders_daily_agg__lines {
  label: "Lines Daily Agg"

  parameter: parameter_target_currency {
    type: string
    suggest_explore: currency_rate_md
    suggest_dimension: currency_rate_md.to_currency
  }

  dimension: total_ordered_target_currency {
    type: number
    sql: (select TOTAL_ORDERED FROM sales_orders_daily_agg__lines.amounts WHERE CURRENCY_CODE = 'EUR') ;;
  }

  dimension: item_category_name {
    full_suggestions: yes
    }

  dimension: item_category_set_id {
    full_suggestions: yes
  }


 }
