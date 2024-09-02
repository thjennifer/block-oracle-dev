view: sales_payments_daily_agg__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD."
    sql: IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: sales_payments_daily_agg__amounts {
    type: string
    description: "Nested repeated field containing all enabled converted currency amounts based on the order date"
    hidden: yes
    sql: sales_payments_daily_agg__amounts ;;
  }
  dimension: target_currency_code {
    type: string
    description: "Code indicating the target converted currency type"
    sql: TARGET_CURRENCY_CODE ;;
  }
  dimension: total_adjusted {
    type: number
    description: "Sum of the amount adjusted across payments"
    sql: TOTAL_ADJUSTED ;;
  }
  dimension: total_applied {
    type: number
    description: "Sum of the amount applied across payments"
    sql: TOTAL_APPLIED ;;
  }
  dimension: total_credited {
    type: number
    description: "Sum of the amount credited across payments"
    sql: TOTAL_CREDITED ;;
  }
  dimension: total_discounted {
    type: number
    description: "Sum of the discount amount across payments"
    sql: TOTAL_DISCOUNTED ;;
  }
  dimension: total_doubtful_remaining {
    type: number
    description: "Sum of the doubtful overdue remaining amount across payments."
    sql: TOTAL_DOUBTFUL_REMAINING ;;
  }
  dimension: total_original {
    type: number
    description: "Sum of the original amount due across payments"
    sql: TOTAL_ORIGINAL ;;
  }
  dimension: total_overdue_remaining {
    type: number
    description: "Sum of the overdue remaining amount due across payments"
    sql: TOTAL_OVERDUE_REMAINING ;;
  }
  dimension: total_remaining {
    type: number
    description: "Sum of the remaining amount due across payments"
    sql: TOTAL_REMAINING ;;
  }
  dimension: total_tax_original {
    type: number
    description: "Sum of the original tax amount across payments"
    sql: TOTAL_TAX_ORIGINAL ;;
  }
  dimension: total_tax_remaining {
    type: number
    description: "Sum of the remaining tax remaining across payments"
    sql: TOTAL_TAX_REMAINING ;;
  }
}
