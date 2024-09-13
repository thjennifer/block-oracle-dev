view: sales_payments {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPayments` ;;

dimension: amount_adjusted {
  type: number
  description: "Amount adjusted"
  sql: ${TABLE}.AMOUNT_ADJUSTED ;;
}
dimension: amount_applied {
  type: number
  description: "Amount applied"
  sql: ${TABLE}.AMOUNT_APPLIED ;;
}
dimension: amount_credited {
  type: number
  description: "Amount credited"
  sql: ${TABLE}.AMOUNT_CREDITED ;;
}
dimension: amount_discounted {
  type: number
  description: "Amount discounted"
  sql: ${TABLE}.AMOUNT_DISCOUNTED ;;
}
dimension: amount_due_original {
  type: number
  description: "Amount due originally"
  sql: ${TABLE}.AMOUNT_DUE_ORIGINAL ;;
}
dimension: amount_due_remaining {
  type: number
  description: "Amount due remaining"
  sql: ${TABLE}.AMOUNT_DUE_REMAINING ;;
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
dimension: cash_receipt_id {
  type: number
  description: "Foreign key identifying the associated cash receipt for payment transactions"
  sql: ${TABLE}.CASH_RECEIPT_ID ;;
}
dimension_group: creation_ts {
  type: time
  description: "Timestamp when the record was created in the source system"
  timeframes: [raw, time, date, week, month, quarter, year]
  sql: ${TABLE}.CREATION_TS ;;
}
dimension: currency_code {
  type: string
  description: "Code indicating the type of currency that the payment was made in"
  sql: ${TABLE}.CURRENCY_CODE ;;
}
dimension: days_late {
  type: number
  description: "Number of days after the due date to the payment close date for payments that closed late"
  sql: ${TABLE}.DAYS_LATE ;;
}
dimension: days_overdue {
  type: number
  description: "Number of days after the due date to the current date for open and overdue payments"
  sql: ${TABLE}.DAYS_OVERDUE ;;
}
dimension: days_to_payment {
  type: number
  description: "Number of days after the invoice date when the payment was closed"
  sql: ${TABLE}.DAYS_TO_PAYMENT ;;
}
dimension_group: due {
  type: time
  description: "Date that payment installment is due"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.DUE_DATE ;;
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
dimension: invoice_id {
  type: number
  description: "Foreign key identifying the associated invoice for non-payment transactions"
  sql: ${TABLE}.INVOICE_ID ;;
}
dimension: invoice_number {
  type: string
  description: "Invoice number"
  sql: ${TABLE}.INVOICE_NUMBER ;;
}
dimension: is_doubtful {
  type: yesno
  description: "Indicates if the payment is more than 90 days past due"
  sql: ${TABLE}.IS_DOUBTFUL ;;
}
dimension: is_open_and_overdue {
  type: yesno
  description: "Indicates if payment is open with a remaining amount and it is past the due date"
  sql: ${TABLE}.IS_OPEN_AND_OVERDUE ;;
}
dimension: is_payment_transaction {
  type: yesno
  description: "Indicates whether the payment is a transaction associated with a cash receipt, or an invoice. Non-payment transactions associated with invoices can have payment classes like invoice, credit memo, debit memo, etc."
  sql: ${TABLE}.IS_PAYMENT_TRANSACTION ;;
}
dimension_group: last_update_ts {
  type: time
  description: "Timestamp when the record was last updated in the source system"
  timeframes: [raw, time, date, week, month, quarter, year]
  sql: ${TABLE}.LAST_UPDATE_TS ;;
}
dimension_group: ledger {
  type: time
  description: "Date when the payment applied to the ledger"
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
dimension: payment_class_code {
  type: string
  description: "Class of payment including: INV - Invoice, CM - Credit Memo, DM - Debit Memo, DEP - Deposit, GUAR - Guarantee, BR - Bills Receivable, CB - Chargeback, PMT - cash receipts"
  sql: ${TABLE}.PAYMENT_CLASS_CODE ;;
}
dimension_group: payment_close {
  type: time
  description: "Date the payment was closed, null if still open"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.PAYMENT_CLOSE_DATE ;;
}
dimension: payment_schedule_id {
  type: number
  description: "Primary key identifying the payment schedule"
  sql: ${TABLE}.PAYMENT_SCHEDULE_ID ;;
}
dimension: payment_status_code {
  type: string
  description: "Status of payment: Open or Closed"
  sql: ${TABLE}.PAYMENT_STATUS_CODE ;;
}
dimension: tax_original {
  type: number
  description: "Original tax amount charged on the transaction"
  sql: ${TABLE}.TAX_ORIGINAL ;;
}
dimension: tax_remaining {
  type: number
  description: "Remaining tax amount charged on the transaction"
  sql: ${TABLE}.TAX_REMAINING ;;
}
dimension_group: transaction {
  type: time
  description: "Date of the associated transaction, e.g. invoice date or cash receipt date"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.TRANSACTION_DATE ;;
}
dimension: transaction_month_num {
  type: number
  description: "Month of the associated transaction"
  sql: ${TABLE}.TRANSACTION_MONTH_NUM ;;
}
dimension: transaction_quarter_num {
  type: number
  description: "Quarter of the associated transaction"
  sql: ${TABLE}.TRANSACTION_QUARTER_NUM ;;
}
dimension: transaction_year_num {
  type: number
  description: "Year of the associated transaction"
  sql: ${TABLE}.TRANSACTION_YEAR_NUM ;;
}
dimension: was_closed_late {
  type: yesno
  description: "Indicates if payment is closed with no remaining amount, but was paid off past the due date"
  sql: ${TABLE}.WAS_CLOSED_LATE ;;
}
measure: count {
  type: count
  drill_fields: [ledger_name, business_unit_name, bill_to_customer_name, fiscal_period_set_name, fiscal_gl_period_name]
}
}
