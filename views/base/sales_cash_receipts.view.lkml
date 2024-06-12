view: sales_cash_receipts {
  sql_table_name: `kittycorn-dev-incorta.CORTEX_ORACLE_EBS_REPORTING.SalesCashReceipts` ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.AMOUNT ;;
  }
  dimension: amount_applied {
    type: number
    sql: ${TABLE}.AMOUNT_APPLIED ;;
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
  dimension: cash_receipt_id {
    type: number
    sql: ${TABLE}.CASH_RECEIPT_ID ;;
  }
  dimension_group: creation {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.CREATION_DATE ;;
  }
  dimension: currency_code {
    type: string
    sql: ${TABLE}.CURRENCY_CODE ;;
  }
  dimension_group: deposit {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DEPOSIT_DATE ;;
  }
  dimension: fiscal_gl_month {
    type: number
    sql: ${TABLE}.FISCAL_GL_MONTH ;;
  }
  dimension: fiscal_gl_quarter {
    type: number
    sql: ${TABLE}.FISCAL_GL_QUARTER ;;
  }
  dimension: fiscal_gl_year {
    type: number
    sql: ${TABLE}.FISCAL_GL_YEAR ;;
  }
  dimension: fiscal_period_name {
    type: string
    sql: ${TABLE}.FISCAL_PERIOD_NAME ;;
  }
  dimension: fiscal_period_set_name {
    type: string
    sql: ${TABLE}.FISCAL_PERIOD_SET_NAME ;;
  }
  dimension: fiscal_period_type {
    type: string
    sql: ${TABLE}.FISCAL_PERIOD_TYPE ;;
  }
  dimension: invoice_id {
    type: number
    sql: ${TABLE}.INVOICE_ID ;;
  }
  dimension: invoice_number {
    type: string
    sql: ${TABLE}.INVOICE_NUMBER ;;
  }
  dimension: is_confirmed {
    type: string
    sql: ${TABLE}.IS_CONFIRMED ;;
  }
  dimension_group: last_update {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.LAST_UPDATE_DATE ;;
  }
  dimension_group: ledger {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.LEDGER_DATE ;;
  }
  dimension: ledger_id {
    type: number
    sql: ${TABLE}.LEDGER_ID ;;
  }
  dimension: ledger_name {
    type: string
    sql: ${TABLE}.LEDGER_NAME ;;
  }
  dimension_group: receipt {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.RECEIPT_DATE ;;
  }
  # dimension: receipt_month {
  #   type: number
  #   sql: ${TABLE}.RECEIPT_MONTH ;;
  # }
  dimension: receipt_number {
    type: string
    sql: ${TABLE}.RECEIPT_NUMBER ;;
  }
  # dimension: receipt_quarter {
  #   type: number
  #   sql: ${TABLE}.RECEIPT_QUARTER ;;
  # }
  # dimension: receipt_year {
  #   type: number
  #   sql: ${TABLE}.RECEIPT_YEAR ;;
  # }
  dimension: status {
    type: string
    sql: ${TABLE}.STATUS ;;
  }
  measure: count {
    type: count
    drill_fields: [fiscal_period_name, ledger_name, business_unit_name, bill_to_customer_name, fiscal_period_set_name]
  }
}
