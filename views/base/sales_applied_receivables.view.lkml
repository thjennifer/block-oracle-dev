view: sales_applied_receivables {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesAppliedReceivables` ;;

  dimension: amount_applied {
    type: number
    sql: ${TABLE}.AMOUNT_APPLIED ;;
  }
  dimension: application_type {
    type: string
    sql: ${TABLE}.APPLICATION_TYPE ;;
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
  dimension: cash_receipt__amount {
    type: number
    sql: ${TABLE}.CASH_RECEIPT.AMOUNT ;;
    group_label: "Cash Receipt"
    group_item_label: "Amount"
  }
  dimension_group: cash_receipt__deposit {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CASH_RECEIPT.DEPOSIT_DATE ;;
  }
  dimension: cash_receipt__is_confirmed {
    type: yesno
    sql: ${TABLE}.CASH_RECEIPT.IS_CONFIRMED ;;
    group_label: "Cash Receipt"
    group_item_label: "Is Confirmed"
  }
  dimension: cash_receipt__receipt_number {
    type: string
    sql: ${TABLE}.CASH_RECEIPT.RECEIPT_NUMBER ;;
    group_label: "Cash Receipt"
    group_item_label: "Receipt Number"
  }
  dimension: cash_receipt__status {
    type: string
    sql: ${TABLE}.CASH_RECEIPT.STATUS ;;
    group_label: "Cash Receipt"
    group_item_label: "Status"
  }
  dimension: cash_receipt_history_id {
    type: number
    sql: ${TABLE}.CASH_RECEIPT_HISTORY_ID ;;
  }
  dimension: cash_receipt_id {
    type: number
    sql: ${TABLE}.CASH_RECEIPT_ID ;;
  }
  dimension_group: creation_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.CREATION_TS ;;
  }
  dimension: currency_code {
    type: string
    sql: ${TABLE}.CURRENCY_CODE ;;
  }
  dimension_group: event {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.EVENT_DATE ;;
  }
  dimension: event_month_num {
    type: number
    sql: ${TABLE}.EVENT_MONTH_NUM ;;
  }
  dimension: event_quarter_num {
    type: number
    sql: ${TABLE}.EVENT_QUARTER_NUM ;;
  }
  dimension: event_year_num {
    type: number
    sql: ${TABLE}.EVENT_YEAR_NUM ;;
  }
  dimension_group: exchange {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.EXCHANGE_DATE ;;
  }
  dimension: fiscal_gl_month_num {
    type: number
    sql: ${TABLE}.FISCAL_GL_MONTH_NUM ;;
  }
  dimension: fiscal_gl_quarter_num {
    type: number
    sql: ${TABLE}.FISCAL_GL_QUARTER_NUM ;;
  }
  dimension: fiscal_gl_year_num {
    type: number
    sql: ${TABLE}.FISCAL_GL_YEAR_NUM ;;
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
  dimension_group: invoice__invoice {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.INVOICE.INVOICE_DATE ;;
  }
  dimension: invoice__invoice_number {
    type: string
    sql: ${TABLE}.INVOICE.INVOICE_NUMBER ;;
    group_label: "Invoice"
    group_item_label: "Invoice Number"
  }
  dimension: invoice__invoice_type {
    type: string
    sql: ${TABLE}.INVOICE.INVOICE_TYPE ;;
    group_label: "Invoice"
    group_item_label: "Invoice Type"
  }
  dimension: invoice__invoice_type_id {
    type: number
    sql: ${TABLE}.INVOICE.INVOICE_TYPE_ID ;;
    group_label: "Invoice"
    group_item_label: "Invoice Type ID"
  }
  dimension: invoice__invoice_type_name {
    type: string
    sql: ${TABLE}.INVOICE.INVOICE_TYPE_NAME ;;
    group_label: "Invoice"
    group_item_label: "Invoice Type Name"
  }
  dimension: invoice__is_complete {
    type: yesno
    sql: ${TABLE}.INVOICE.IS_COMPLETE ;;
    group_label: "Invoice"
    group_item_label: "Is Complete"
  }
  dimension: invoice__total_revenue_amount {
    type: number
    sql: ${TABLE}.INVOICE.TOTAL_REVENUE_AMOUNT ;;
    group_label: "Invoice"
    group_item_label: "Total Revenue Amount"
  }
  dimension: invoice__total_tax_amount {
    type: number
    sql: ${TABLE}.INVOICE.TOTAL_TAX_AMOUNT ;;
    group_label: "Invoice"
    group_item_label: "Total Tax Amount"
  }
  dimension: invoice__total_transaction_amount {
    type: number
    sql: ${TABLE}.INVOICE.TOTAL_TRANSACTION_AMOUNT ;;
    group_label: "Invoice"
    group_item_label: "Total Transaction Amount"
  }
  dimension: invoice_id {
    type: number
    sql: ${TABLE}.INVOICE_ID ;;
  }
  dimension_group: last_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.LAST_UPDATE_TS ;;
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
  dimension: receivable_application_id {
    type: number
    sql: ${TABLE}.RECEIVABLE_APPLICATION_ID ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      fiscal_period_name,
      ledger_name,
      business_unit_name,
      bill_to_customer_name,
      fiscal_period_set_name,
      invoice__invoice_type_name
    ]
  }

}
