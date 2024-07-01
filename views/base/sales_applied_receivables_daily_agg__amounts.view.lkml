view: sales_applied_receivables_daily_agg__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    sql: IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: sales_applied_receivables_daily_agg__amounts {
    type: string
    hidden: yes
    sql: sales_applied_receivables_daily_agg__amounts ;;
  }
  dimension: target_currency_code {
    type: string
    sql: TARGET_CURRENCY_CODE ;;
  }
  dimension: total_applied {
    type: number
    sql: TOTAL_APPLIED ;;
  }
  dimension: total_received {
    type: number
    sql: TOTAL_RECEIVED ;;
  }
}
