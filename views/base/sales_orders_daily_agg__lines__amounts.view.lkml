view: sales_orders_daily_agg__lines__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    description: "Indicates whether some of the source currency amounts could not be converted to the target currency because of missing conversion rates from CurrencyRateMD"
    sql: ${TABLE}.IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: target_currency_code {
    type: string
    description: "Code indicating the target converted currency type"
    sql: ${TABLE}.TARGET_CURRENCY_CODE ;;
  }
  dimension: total_backlog {
    type: number
    description: "Sum of backlog amounts across orders and lines"
    sql: ${TABLE}.TOTAL_BACKLOG ;;
  }
  dimension: total_booking {
    type: number
    description: "Sum of booking amounts across orders and lines"
    sql: ${TABLE}.TOTAL_BOOKING ;;
  }
  dimension: total_fulfilled {
    type: number
    description: "Sum of fulfilled amounts across orders and lines"
    sql: ${TABLE}.TOTAL_FULFILLED ;;
  }
  dimension: total_invoiced {
    type: number
    description: "Sum of invoiced amounts across orders and lines"
    sql: ${TABLE}.TOTAL_INVOICED ;;
  }
  dimension: total_ordered {
    type: number
    description: "Sum of ordered amounts across orders and lines"
    sql: ${TABLE}.TOTAL_ORDERED ;;
  }
  dimension: total_shipped {
    type: number
    description: "Sum of shipped amounts across orders and lines"
    sql: ${TABLE}.TOTAL_SHIPPED ;;
  }
}
