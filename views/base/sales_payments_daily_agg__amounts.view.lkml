view: sales_payments_daily_agg__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    sql: IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: sales_payments_daily_agg__amounts {
    type: string
    hidden: yes
    sql: sales_payments_daily_agg__amounts ;;
  }
  dimension: target_currency_code {
    type: string
    sql: TARGET_CURRENCY_CODE ;;
  }
  dimension: total_adjusted {
    type: number
    sql: TOTAL_ADJUSTED ;;
  }
  dimension: total_applied {
    type: number
    sql: TOTAL_APPLIED ;;
  }
  dimension: total_credited {
    type: number
    sql: TOTAL_CREDITED ;;
  }
  dimension: total_discounted {
    type: number
    sql: TOTAL_DISCOUNTED ;;
  }
  dimension: total_doubtful_remaining {
    type: number
    sql: TOTAL_DOUBTFUL_REMAINING ;;
  }
  dimension: total_original {
    type: number
    sql: TOTAL_ORIGINAL ;;
  }
  dimension: total_overdue_remaining {
    type: number
    sql: TOTAL_OVERDUE_REMAINING ;;
  }
  dimension: total_remaining {
    type: number
    sql: TOTAL_REMAINING ;;
  }
  dimension: total_tax_original {
    type: number
    sql: TOTAL_TAX_ORIGINAL ;;
  }
  dimension: total_tax_remaining {
    type: number
    sql: TOTAL_TAX_REMAINING ;;
  }
}
