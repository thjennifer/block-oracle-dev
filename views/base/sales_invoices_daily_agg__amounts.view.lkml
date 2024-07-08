view: sales_invoices_daily_agg__amounts {

  dimension: is_incomplete_conversion {
    type: yesno
    sql: IS_INCOMPLETE_CONVERSION ;;
  }
  dimension: sales_invoices_daily_agg__amounts {
    type: string
    hidden: yes
    sql: sales_invoices_daily_agg__amounts ;;
  }
  dimension: target_currency_code {
    type: string
    sql: TARGET_CURRENCY_CODE ;;
  }
  dimension: total_discount {
    type: number
    sql: TOTAL_DISCOUNT ;;
  }
  dimension: total_intercompany_list {
    type: number
    sql: TOTAL_INTERCOMPANY_LIST ;;
  }
  dimension: total_intercompany_selling {
    type: number
    sql: TOTAL_INTERCOMPANY_SELLING ;;
  }
  dimension: total_list {
    type: number
    sql: TOTAL_LIST ;;
  }
  dimension: total_revenue {
    type: number
    sql: TOTAL_REVENUE ;;
  }
  dimension: total_selling {
    type: number
    sql: TOTAL_SELLING ;;
  }
  dimension: total_tax {
    type: number
    sql: TOTAL_TAX ;;
  }
  dimension: total_transaction {
    type: number
    sql: TOTAL_TRANSACTION ;;
  }
}
