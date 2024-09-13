view: sales_payments_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg` ;;

  dimension: amounts {
    hidden: yes
    sql: ${TABLE}.AMOUNTS ;;
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
  dimension: is_payment_transaction {
    type: yesno
    description: "Indicates whether the payment is a transaction associated with a cash receipt, or an invoice. Non-payment transactions associated with invoices can have payment classes like invoice, credit memo, debit memo, etc."
    sql: ${TABLE}.IS_PAYMENT_TRANSACTION ;;
  }
  dimension: num_closed_payments {
    type: number
    description: "Total number of payments made that are now closed"
    sql: ${TABLE}.NUM_CLOSED_PAYMENTS ;;
  }
  dimension: num_payments {
    type: number
    description: "Total number of payments made"
    sql: ${TABLE}.NUM_PAYMENTS ;;
  }
  dimension: payment_class_code {
    type: string
    description: "Class of payment including: INV - Invoice, CM - Credit Memo, DM - Debit Memo, DEP - Deposit, GUAR - Guarantee, BR - Bills Receivable, CB - Chargeback, PMT - cash receipts"
    sql: ${TABLE}.PAYMENT_CLASS_CODE ;;
  }
  dimension: total_days_to_payment {
    type: number
    description: "Sum of the days after invoice date to payment close date across payments. This can be used with NUM_CLOSED_PAYMENTS to calculate the average days to receive closed payments."
    sql: ${TABLE}.TOTAL_DAYS_TO_PAYMENT ;;
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
  measure: count {
    type: count
    drill_fields: [business_unit_name, bill_to_customer_name]
  }
}

# view: sales_payments_daily_agg__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD."
#     sql: IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: sales_payments_daily_agg__amounts {
#     type: string
#     description: "Nested repeated field containing all enabled converted currency amounts based on the order date"
#     hidden: yes
#     sql: sales_payments_daily_agg__amounts ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     description: "Code indicating the target converted currency type"
#     sql: TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_adjusted {
#     type: number
#     description: "Sum of the amount adjusted across payments"
#     sql: TOTAL_ADJUSTED ;;
#   }
#   dimension: total_applied {
#     type: number
#     description: "Sum of the amount applied across payments"
#     sql: TOTAL_APPLIED ;;
#   }
#   dimension: total_credited {
#     type: number
#     description: "Sum of the amount credited across payments"
#     sql: TOTAL_CREDITED ;;
#   }
#   dimension: total_discounted {
#     type: number
#     description: "Sum of the discount amount across payments"
#     sql: TOTAL_DISCOUNTED ;;
#   }
#   dimension: total_doubtful_remaining {
#     type: number
#     description: "Sum of the doubtful overdue remaining amount across payments."
#     sql: TOTAL_DOUBTFUL_REMAINING ;;
#   }
#   dimension: total_original {
#     type: number
#     description: "Sum of the original amount due across payments"
#     sql: TOTAL_ORIGINAL ;;
#   }
#   dimension: total_overdue_remaining {
#     type: number
#     description: "Sum of the overdue remaining amount due across payments"
#     sql: TOTAL_OVERDUE_REMAINING ;;
#   }
#   dimension: total_remaining {
#     type: number
#     description: "Sum of the remaining amount due across payments"
#     sql: TOTAL_REMAINING ;;
#   }
#   dimension: total_tax_original {
#     type: number
#     description: "Sum of the original tax amount across payments"
#     sql: TOTAL_TAX_ORIGINAL ;;
#   }
#   dimension: total_tax_remaining {
#     type: number
#     description: "Sum of the remaining tax remaining across payments"
#     sql: TOTAL_TAX_REMAINING ;;
#   }
# }
