view: sales_payments {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPayments` ;;

    dimension: amount_adjusted {
      type: number
      sql: ${TABLE}.AMOUNT_ADJUSTED ;;
    }
    dimension: amount_applied {
      type: number
      sql: ${TABLE}.AMOUNT_APPLIED ;;
    }
    dimension: amount_credited {
      type: number
      sql: ${TABLE}.AMOUNT_CREDITED ;;
    }
    dimension: amount_discounted {
      type: number
      sql: ${TABLE}.AMOUNT_DISCOUNTED ;;
    }
    dimension: amount_due_original {
      type: number
      sql: ${TABLE}.AMOUNT_DUE_ORIGINAL ;;
    }
    dimension: amount_due_remaining {
      type: number
      sql: ${TABLE}.AMOUNT_DUE_REMAINING ;;
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
    dimension_group: creation_ts {
      type: time
      timeframes: [raw, time, date, week, month, quarter, year]
      sql: ${TABLE}.CREATION_TS ;;
    }
    dimension: currency_code {
      type: string
      sql: ${TABLE}.CURRENCY_CODE ;;
    }
    dimension: days_late {
      type: number
      sql: ${TABLE}.DAYS_LATE ;;
    }
    dimension: days_overdue {
      type: number
      sql: ${TABLE}.DAYS_OVERDUE ;;
    }
    dimension: days_to_payment {
      type: number
      sql: ${TABLE}.DAYS_TO_PAYMENT ;;
    }
    dimension_group: due {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.DUE_DATE ;;
    }
    dimension_group: exchange {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.EXCHANGE_DATE ;;
    }
    dimension: fiscal_gl_period_num {
      type: number
      sql: ${TABLE}.FISCAL_GL_PERIOD_NUM ;;
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
    dimension: invoice_id {
      type: number
      sql: ${TABLE}.INVOICE_ID ;;
    }
    dimension: invoice_number {
      type: string
      sql: ${TABLE}.INVOICE_NUMBER ;;
    }
    dimension: is_doubtful {
      type: yesno
      sql: ${TABLE}.IS_DOUBTFUL ;;
    }
    dimension: is_open_and_overdue {
      type: yesno
      sql: ${TABLE}.IS_OPEN_AND_OVERDUE ;;
    }
    dimension: is_payment_transaction {
      type: yesno
      sql: ${TABLE}.IS_PAYMENT_TRANSACTION ;;
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
    dimension: payment_class_code {
      type: string
      sql: ${TABLE}.PAYMENT_CLASS_CODE ;;
    }
    dimension_group: payment_close {
      type: time
      timeframes: [raw, date, week, month, quarter, year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.PAYMENT_CLOSE_DATE ;;
    }
    dimension: payment_schedule_id {
      type: number
      sql: ${TABLE}.PAYMENT_SCHEDULE_ID ;;
    }
    dimension: payment_status_code {
      type: string
      sql: ${TABLE}.PAYMENT_STATUS_CODE ;;
    }
    dimension: tax_original {
      type: number
      sql: ${TABLE}.TAX_ORIGINAL ;;
    }
    dimension: tax_remaining {
      type: number
      sql: ${TABLE}.TAX_REMAINING ;;
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
    dimension: was_closed_late {
      type: yesno
      sql: ${TABLE}.WAS_CLOSED_LATE ;;
    }
    measure: count {
      type: count
      drill_fields: [fiscal_period_name, ledger_name, business_unit_name, bill_to_customer_name, fiscal_period_set_name]
    }
}
