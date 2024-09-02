view: sales_invoices_daily_agg__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD."
    sql: IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: sales_invoices_daily_agg__amounts {
    type: string
    description: "Nested repeated field containing all enabled converted currency amounts based on the order date"
    hidden: yes
    sql: sales_invoices_daily_agg__amounts ;;
  }
  dimension: target_currency_code {
    type: string
    description: "Code indicating the target converted currency type"
    sql: TARGET_CURRENCY_CODE ;;
  }
  dimension: total_discount {
    type: number
    description: "Sum of discount amounts across all lines"
    sql: TOTAL_DISCOUNT ;;
  }
  dimension: total_intercompany_list {
    type: number
    description: "Sum of post-tax list amounts across all intercompany lines"
    sql: TOTAL_INTERCOMPANY_LIST ;;
  }
  dimension: total_intercompany_selling {
    type: number
    description: "Sum of pre-tax selling amounts across all intercompany lines"
    sql: TOTAL_INTERCOMPANY_SELLING ;;
  }
  dimension: total_list {
    type: number
    description: "Sum of post-tax list amounts across all lines"
    sql: TOTAL_LIST ;;
  }
  dimension: total_revenue {
    type: number
    description: "Sum of revenue amounts across all lines"
    sql: TOTAL_REVENUE ;;
  }
  dimension: total_selling {
    type: number
    description: "Sum of pre-tax selling amounts across all lines"
    sql: TOTAL_SELLING ;;
  }
  dimension: total_tax {
    type: number
    description: "Sum of tax amounts across all lines"
    sql: TOTAL_TAX ;;
  }
  dimension: total_transaction {
    type: number
    description: "Sum of pre-tax selling amounts across all lines"
    sql: TOTAL_TRANSACTION ;;
  }
}
