view: sales_payments_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg` ;;

  dimension: amounts {
    hidden: yes
    sql: ${TABLE}.AMOUNTS ;;
  }
  dimension: bill_to_customer_country {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: bill_to_customer_name {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
  }
  dimension: bill_to_customer_number {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
  }
  dimension: bill_to_site_use_id {
    type: number
    sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
  }
  dimension: business_unit_id {
    type: number
    sql: ${TABLE}.BUSINESS_UNIT_ID ;;
  }
  dimension: business_unit_name {
    type: string
    sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
  }
  dimension: is_payment_transaction {
    type: yesno
    sql: ${TABLE}.IS_PAYMENT_TRANSACTION ;;
  }
  dimension: num_closed_payments {
    type: number
    sql: ${TABLE}.NUM_CLOSED_PAYMENTS ;;
  }
  dimension: num_payments {
    type: number
    sql: ${TABLE}.NUM_PAYMENTS ;;
  }
  dimension: payment_class_code {
    type: string
    sql: ${TABLE}.PAYMENT_CLASS_CODE ;;
  }
  dimension: total_days_to_payment {
    type: number
    sql: ${TABLE}.TOTAL_DAYS_TO_PAYMENT ;;
  }
  dimension_group: transaction {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.TRANSACTION_DATE ;;
  }
  dimension: transaction_month_num {
    type: number
    sql: ${TABLE}.TRANSACTION_MONTH_NUM ;;
  }
  dimension: transaction_quarter_num {
    type: number
    sql: ${TABLE}.TRANSACTION_QUARTER_NUM ;;
  }
  dimension: transaction_year_num {
    type: number
    sql: ${TABLE}.TRANSACTION_YEAR_NUM ;;
  }
  measure: count {
    type: count
    drill_fields: [business_unit_name, bill_to_customer_name]
  }
}

# view: sales_payments_daily_agg__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     sql: IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: sales_payments_daily_agg__amounts {
#     type: string
#     hidden: yes
#     sql: sales_payments_daily_agg__amounts ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     sql: TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_adjusted {
#     type: number
#     sql: TOTAL_ADJUSTED ;;
#   }
#   dimension: total_applied {
#     type: number
#     sql: TOTAL_APPLIED ;;
#   }
#   dimension: total_credited {
#     type: number
#     sql: TOTAL_CREDITED ;;
#   }
#   dimension: total_discounted {
#     type: number
#     sql: TOTAL_DISCOUNTED ;;
#   }
#   dimension: total_doubtful_remaining {
#     type: number
#     sql: TOTAL_DOUBTFUL_REMAINING ;;
#   }
#   dimension: total_original {
#     type: number
#     sql: TOTAL_ORIGINAL ;;
#   }
#   dimension: total_overdue_remaining {
#     type: number
#     sql: TOTAL_OVERDUE_REMAINING ;;
#   }
#   dimension: total_remaining {
#     type: number
#     sql: TOTAL_REMAINING ;;
#   }
#   dimension: total_tax_original {
#     type: number
#     sql: TOTAL_TAX_ORIGINAL ;;
#   }
#   dimension: total_tax_remaining {
#     type: number
#     sql: TOTAL_TAX_REMAINING ;;
#   }
# }
