view: sales_orders_daily_agg__lines__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    sql: ${TABLE}.IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: target_currency_code {
    type: string
    sql: ${TABLE}.TARGET_CURRENCY_CODE ;;
  }
  dimension: total_backlog {
    type: number
    sql: ${TABLE}.TOTAL_BACKLOG ;;
  }
  dimension: total_booking {
    type: number
    sql: ${TABLE}.TOTAL_BOOKING ;;
  }
  dimension: total_fulfilled {
    type: number
    sql: ${TABLE}.TOTAL_FULFILLED ;;
  }
  dimension: total_invoiced {
    type: number
    sql: ${TABLE}.TOTAL_INVOICED ;;
  }
  dimension: total_ordered {
    type: number
    sql: ${TABLE}.TOTAL_ORDERED ;;
  }
  dimension: total_shipped {
    type: number
    sql: ${TABLE}.TOTAL_SHIPPED ;;
  }
}
