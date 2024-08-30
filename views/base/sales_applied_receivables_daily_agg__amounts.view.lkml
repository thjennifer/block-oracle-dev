view: sales_applied_receivables_daily_agg__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD."
    sql: IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: sales_applied_receivables_daily_agg__amounts {
    type: string
    description: "Nested repeated field containing all enabled converted currency amounts based on the order date"
    hidden: yes
    sql: sales_applied_receivables_daily_agg__amounts ;;
  }
  dimension: target_currency_code {
    type: string
    description: "Code indicating the target converted currency type"
    sql: TARGET_CURRENCY_CODE ;;
  }
  dimension: total_applied {
    type: number
    description: "Sum of the amount applied across receipts"
    sql: TOTAL_APPLIED ;;
  }
  dimension: total_received {
    type: number
    description: "Sum of the amount received across receipts"
    sql: TOTAL_RECEIVED ;;
  }
}
