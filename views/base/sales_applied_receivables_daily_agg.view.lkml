view: sales_applied_receivables_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesAppliedReceivablesDailyAgg` ;;

 dimension: amounts {
  hidden: yes
  sql: ${TABLE}.AMOUNTS ;;
}
dimension: application_type {
  type: string
  description: "Type of entity the amount was applied to including: CASH - Cash Receipt, CM - Credit Memo"
  sql: ${TABLE}.APPLICATION_TYPE ;;
}
dimension: bill_to_customer_country {
  type: string
  description: "Billed customer country name"
  sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
}
dimension: bill_to_customer_name {
  type: string
  description: "Billed customer account name"
  sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
}
dimension: bill_to_customer_number {
  type: string
  description: "Billed customer account number"
  sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
}
dimension: bill_to_site_use_id {
  type: number
  description: "Foreign key identifying the Site Use entity that was billed to"
  sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
}
dimension: business_unit_id {
  type: number
  description: "Foreign key identifying the business unit that performed this transaction"
  sql: ${TABLE}.BUSINESS_UNIT_ID ;;
}
dimension: business_unit_name {
  type: string
  description: "Business unit name"
  sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
}
dimension_group: event {
  type: time
  description: "Date the cash was received or invoice was created"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.EVENT_DATE ;;
}
dimension: event_month_num {
  type: number
  description: "Month the cash was received or invoice was created"
  sql: ${TABLE}.EVENT_MONTH_NUM ;;
}
dimension: event_quarter_num {
  type: number
  description: "Quarter the cash was received or invoice was created"
  sql: ${TABLE}.EVENT_QUARTER_NUM ;;
}
dimension: event_year_num {
  type: number
  description: "Year the cash was received or invoice was created"
  sql: ${TABLE}.EVENT_YEAR_NUM ;;
}
measure: count {
  type: count
  drill_fields: [business_unit_name, bill_to_customer_name]
}
}

# view: sales_applied_receivables_daily_agg__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD."
#     sql: IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: sales_applied_receivables_daily_agg__amounts {
#     type: string
#     description: "Nested repeated field containing all enabled converted currency amounts based on the order date"
#     hidden: yes
#     sql: sales_applied_receivables_daily_agg__amounts ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     description: "Code indicating the target converted currency type"
#     sql: TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_applied {
#     type: number
#     description: "Sum of the amount applied across receipts"
#     sql: TOTAL_APPLIED ;;
#   }
#   dimension: total_received {
#     type: number
#     description: "Sum of the amount received across receipts"
#     sql: TOTAL_RECEIVED ;;
#   }
# }
