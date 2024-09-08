view: sales_invoices_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesInvoicesDailyAgg` ;;

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
dimension_group: invoice {
  type: time
  description: "Date the invoice was created"
  timeframes: [raw, date, week, month, quarter, year]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.INVOICE_DATE ;;
}
dimension: invoice_month_num {
  type: number
  description: "Month the invoice was created"
  sql: ${TABLE}.INVOICE_MONTH_NUM ;;
}
dimension: invoice_quarter_num {
  type: number
  description: "Quarter the invoice was created"
  sql: ${TABLE}.INVOICE_QUARTER_NUM ;;
}
dimension: invoice_type {
  type: string
  description: "Invoice type including: INV - Invoice, CM - Credit Memo, DM - Debit Memo, DEP - Deposit, GUAR - Guarantee"
  sql: ${TABLE}.INVOICE_TYPE ;;
}
dimension: invoice_type_id {
  type: number
  description: "Foreign key identifying the invoice type"
  sql: ${TABLE}.INVOICE_TYPE_ID ;;
}
dimension: invoice_type_name {
  type: string
  description: "Invoice type name"
  sql: ${TABLE}.INVOICE_TYPE_NAME ;;
}
dimension: invoice_year_num {
  type: number
  description: "Year the invoice was created"
  sql: ${TABLE}.INVOICE_YEAR_NUM ;;
}
dimension: item_category_description {
  type: string
  description: "Item category description"
  sql: ${TABLE}.ITEM_CATEGORY_DESCRIPTION ;;
}
dimension: item_category_id {
  type: number
  description: "Foreign key identifying item categories"
  sql: ${TABLE}.ITEM_CATEGORY_ID ;;
}
dimension: item_category_name {
  type: string
  description: "Item category name"
  sql: ${TABLE}.ITEM_CATEGORY_NAME ;;
}
dimension: item_category_set_id {
  type: number
  description: "Foreign key identifying item category sets"
  sql: ${TABLE}.ITEM_CATEGORY_SET_ID ;;
}
dimension: item_category_set_name {
  type: string
  description: "Item category set name"
  sql: ${TABLE}.ITEM_CATEGORY_SET_NAME ;;
}
dimension: item_organization_id {
  type: number
  description: "Foreign key identifying the organization that shipped the line"
  sql: ${TABLE}.ITEM_ORGANIZATION_ID ;;
}
dimension: item_organization_name {
  type: string
  description: "Item organization name"
  sql: ${TABLE}.ITEM_ORGANIZATION_NAME ;;
}
dimension: num_intercompany_lines {
  type: number
  description: "Total number of invoice lines across intercompany invoices"
  sql: ${TABLE}.NUM_INTERCOMPANY_LINES ;;
}
dimension: num_invoice_lines {
  type: number
  description: "Total number of invoice lines across invoices"
  sql: ${TABLE}.NUM_INVOICE_LINES ;;
}
dimension: order_source_id {
  type: number
  description: "Foreign key identifying the order source"
  sql: ${TABLE}.ORDER_SOURCE_ID ;;
}
dimension: order_source_name {
  type: string
  description: "Order source name"
  sql: ${TABLE}.ORDER_SOURCE_NAME ;;
}
measure: count {
  type: count
  drill_fields: [detail*]
}

# ----- Sets of fields for drilling ------
set: detail {
  fields: [
    business_unit_name,
    item_organization_name,
    bill_to_customer_name,
    item_category_name,
    invoice_type_name,
    item_category_set_name,
    order_source_name
  ]
}

}

# view: sales_invoices_daily_agg__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     description: "Indicates whether some of the source currency amounts could not be converted into the target currency because of missing conversion rates from CurrencyRateMD."
#     sql: IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: sales_invoices_daily_agg__amounts {
#     type: string
#     description: "Nested repeated field containing all enabled converted currency amounts based on the order date"
#     hidden: yes
#     sql: sales_invoices_daily_agg__amounts ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     description: "Code indicating the target converted currency type"
#     sql: TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_discount {
#     type: number
#     description: "Sum of discount amounts across all lines"
#     sql: TOTAL_DISCOUNT ;;
#   }
#   dimension: total_intercompany_list {
#     type: number
#     description: "Sum of post-tax list amounts across all intercompany lines"
#     sql: TOTAL_INTERCOMPANY_LIST ;;
#   }
#   dimension: total_intercompany_selling {
#     type: number
#     description: "Sum of pre-tax selling amounts across all intercompany lines"
#     sql: TOTAL_INTERCOMPANY_SELLING ;;
#   }
#   dimension: total_list {
#     type: number
#     description: "Sum of post-tax list amounts across all lines"
#     sql: TOTAL_LIST ;;
#   }
#   dimension: total_revenue {
#     type: number
#     description: "Sum of revenue amounts across all lines"
#     sql: TOTAL_REVENUE ;;
#   }
#   dimension: total_selling {
#     type: number
#     description: "Sum of pre-tax selling amounts across all lines"
#     sql: TOTAL_SELLING ;;
#   }
#   dimension: total_tax {
#     type: number
#     description: "Sum of tax amounts across all lines"
#     sql: TOTAL_TAX ;;
#   }
#   dimension: total_transaction {
#     type: number
#     description: "Sum of pre-tax selling amounts across all lines"
#     sql: TOTAL_TRANSACTION ;;
#   }
# }
