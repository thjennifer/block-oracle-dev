view: sales_applied_receivables {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesAppliedReceivables` ;;

 dimension: amount_applied {
  type: number
  description: "Amount applied"
  sql: ${TABLE}.AMOUNT_APPLIED ;;
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
dimension: cash_receipt__amount {
  type: number
  description: "Amount received"
  sql: ${TABLE}.CASH_RECEIPT.AMOUNT ;;
  group_label: "Cash Receipt"
  group_item_label: "Amount"
}
dimension_group: cash_receipt__deposit {
  type: time
  description: "Date the cash was deposited"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.CASH_RECEIPT.DEPOSIT_DATE ;;
}
dimension: cash_receipt__is_confirmed {
  type: yesno
  description: "Indicates if the cash receipt is confirmed"
  sql: ${TABLE}.CASH_RECEIPT.IS_CONFIRMED ;;
  group_label: "Cash Receipt"
  group_item_label: "Is Confirmed"
}
dimension: cash_receipt__receipt_number {
  type: string
  description: "Cash receipt number"
  sql: ${TABLE}.CASH_RECEIPT.RECEIPT_NUMBER ;;
  group_label: "Cash Receipt"
  group_item_label: "Receipt Number"
}
dimension: cash_receipt__status {
  type: string
  description: "Identifies whether the status of this payment entry is applied, unapplied, unidentified, insufficient funds, reverse payment or stop payment"
  sql: ${TABLE}.CASH_RECEIPT.STATUS ;;
  group_label: "Cash Receipt"
  group_item_label: "Status"
}
dimension: cash_receipt_history_id {
  type: number
  description: "Foreign key identifying the cash receipt history"
  sql: ${TABLE}.CASH_RECEIPT_HISTORY_ID ;;
}
dimension: cash_receipt_id {
  type: number
  description: "Foreign key identifying the associated cash receipt for payment transactions"
  sql: ${TABLE}.CASH_RECEIPT_ID ;;
}
dimension_group: creation_ts {
  type: time
  description: "Timestamp when the receivable application record was created in the source system"
  timeframes: [raw, time, date, week, month, quarter, year]
  sql: ${TABLE}.CREATION_TS ;;
}
dimension: currency_code {
  type: string
  description: "Code indicating the type of currency that was received"
  sql: ${TABLE}.CURRENCY_CODE ;;
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
dimension_group: exchange {
  type: time
  description: "Date that the exchange rate is calculated"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.EXCHANGE_DATE ;;
}
dimension: fiscal_gl_period_name {
  type: string
  description: "Accounting period name"
  sql: ${TABLE}.FISCAL_GL_PERIOD_NAME ;;
  }
dimension: fiscal_gl_period_num {
  type: number
  description: "Accounting period based on the ledger date"
  sql: ${TABLE}.FISCAL_GL_PERIOD_NUM ;;
}
dimension: fiscal_gl_quarter_num {
  type: number
  description: "Accounting quarter based on the ledger date"
  sql: ${TABLE}.FISCAL_GL_QUARTER_NUM ;;
}
dimension: fiscal_gl_year_num {
  type: number
  description: "Accounting year based on the ledger date"
  sql: ${TABLE}.FISCAL_GL_YEAR_NUM ;;
}
dimension: fiscal_period_set_name {
  type: string
  description: "Accounting calendar name"
  sql: ${TABLE}.FISCAL_PERIOD_SET_NAME ;;
}
dimension: fiscal_period_type {
  type: string
  description: "Accounting period type"
  sql: ${TABLE}.FISCAL_PERIOD_TYPE ;;
}
dimension_group: invoice__invoice {
  type: time
  description: "Date the invoice was created"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.INVOICE.INVOICE_DATE ;;
}
dimension: invoice__invoice_number {
  type: string
  description: "Invoice number"
  sql: ${TABLE}.INVOICE.INVOICE_NUMBER ;;
  group_label: "Invoice"
  group_item_label: "Invoice Number"
}
dimension: invoice__invoice_type {
  type: string
  description: "Invoice type including: INV - Invoice, CM - Credit Memo, DM - Debit Memo, DEP - Deposit, GUAR - Guarantee"
  sql: ${TABLE}.INVOICE.INVOICE_TYPE ;;
  group_label: "Invoice"
  group_item_label: "Invoice Type"
}
dimension: invoice__invoice_type_id {
  type: number
  description: "Foreign key identifying the invoice type"
  sql: ${TABLE}.INVOICE.INVOICE_TYPE_ID ;;
  group_label: "Invoice"
  group_item_label: "Invoice Type ID"
}
dimension: invoice__invoice_type_name {
  type: string
  description: "Invoice type name"
  sql: ${TABLE}.INVOICE.INVOICE_TYPE_NAME ;;
  group_label: "Invoice"
  group_item_label: "Invoice Type Name"
}
dimension: invoice__is_complete {
  type: yesno
  description: "Indicates whether the invoice is complete"
  sql: ${TABLE}.INVOICE.IS_COMPLETE ;;
  group_label: "Invoice"
  group_item_label: "Is Complete"
}
dimension: invoice__total_revenue_amount {
  type: number
  description: "Total revenue amount across all invoice lines"
  sql: ${TABLE}.INVOICE.TOTAL_REVENUE_AMOUNT ;;
  group_label: "Invoice"
  group_item_label: "Total Revenue Amount"
}
dimension: invoice__total_tax_amount {
  type: number
  description: "Total tax amount across all invoice lines"
  sql: ${TABLE}.INVOICE.TOTAL_TAX_AMOUNT ;;
  group_label: "Invoice"
  group_item_label: "Total Tax Amount"
}
dimension: invoice__total_transaction_amount {
  type: number
  description: "Total transaction amount across all invoice lines"
  sql: ${TABLE}.INVOICE.TOTAL_TRANSACTION_AMOUNT ;;
  group_label: "Invoice"
  group_item_label: "Total Transaction Amount"
}
dimension: invoice_id {
  type: number
  description: "Foreign key identifying the invoice"
  sql: ${TABLE}.INVOICE_ID ;;
}
dimension_group: last_update_ts {
  type: time
  description: "Timestamp when the receivable application record was last updated in the source system"
  timeframes: [raw, time, date, week, month, quarter, year]
  sql: ${TABLE}.LAST_UPDATE_TS ;;
}
dimension_group: ledger {
  type: time
  description: "Date when the received amount applied to the ledger"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.LEDGER_DATE ;;
}
dimension: ledger_id {
  type: number
  description: "Foreign key identifying the ledger (set of books)"
  sql: ${TABLE}.LEDGER_ID ;;
}
dimension: ledger_name {
  type: string
  description: "Ledger name"
  sql: ${TABLE}.LEDGER_NAME ;;
}
dimension: receivable_application_id {
  type: number
  description: "Primary key identifying receivable application associated with the cash receipt"
  sql: ${TABLE}.RECEIVABLE_APPLICATION_ID ;;
}
measure: count {
  type: count
  drill_fields: [detail*]
}

# ----- Sets of fields for drilling ------
set: detail {
  fields: [
    fiscal_gl_period_name,
    ledger_name,
    business_unit_name,
    bill_to_customer_name,
    fiscal_period_set_name,
    invoice__invoice_type_name
  ]
}

}
