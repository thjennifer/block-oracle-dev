view: sales_invoices {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesInvoices` ;;

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
  dimension_group: creation_ts {
    type: time
    description: "Timestamp when the header record was created in the source system"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.CREATION_TS ;;
  }
  dimension: currency_code {
    type: string
    description: "Code indicating the type of currency that the invoice was placed in"
    sql: ${TABLE}.CURRENCY_CODE ;;
  }
  dimension_group: exchange {
    type: time
    description: "Date that the exchange rate is calculated"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.EXCHANGE_DATE ;;
  }
  dimension_group: invoice {
    type: time
    description: "Date the invoice was created"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.INVOICE_DATE ;;
  }
  dimension: invoice_id {
    type: number
    description: "Primary key identifying the invoice header"
    sql: ${TABLE}.INVOICE_ID ;;
  }
  dimension: invoice_month_num {
    type: number
    description: "Month the invoice was created"
    sql: ${TABLE}.INVOICE_MONTH_NUM ;;
  }
  dimension: invoice_number {
    type: string
    description: "Invoice number"
    sql: ${TABLE}.INVOICE_NUMBER ;;
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
  dimension: is_complete {
    type: yesno
    description: "Indicates whether the invoice is complete"
    sql: ${TABLE}.IS_COMPLETE ;;
  }
  dimension_group: last_update_ts {
    type: time
    description: "Timestamp when the header record was last updated in the source system"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.LAST_UPDATE_TS ;;
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
  dimension: lines {
    hidden: yes
    sql: ${TABLE}.LINES ;;
  }
  dimension: num_intercompany_lines {
    type: number
    description: "Number of intercompany lines in this invoice"
    sql: ${TABLE}.NUM_INTERCOMPANY_LINES ;;
  }
  dimension: num_lines {
    type: number
    description: "Number of lines in this invoice"
    sql: ${TABLE}.NUM_LINES ;;
  }
  dimension: total_revenue_amount {
    type: number
    description: "Total revenue amount across all invoice lines"
    sql: ${TABLE}.TOTAL_REVENUE_AMOUNT ;;
  }
  dimension: total_tax_amount {
    type: number
    description: "Total tax amount across all invoice lines"
    sql: ${TABLE}.TOTAL_TAX_AMOUNT ;;
  }
  dimension: total_transaction_amount {
    type: number
    description: "Total transaction amount across all invoice lines"
    sql: ${TABLE}.TOTAL_TRANSACTION_AMOUNT ;;
  }
  measure: count {
    type: count
    drill_fields: [ledger_name, business_unit_name, bill_to_customer_name, invoice_type_name]
  }
}

# view: sales_invoices__lines {
#   drill_fields: [order_line_id]

#   dimension: order_line_id {
#     primary_key: yes
#     type: number
#     description: "Foreign key identifying the order line"
#     sql: ORDER_LINE_ID ;;
#   }
#   dimension_group: creation_ts {
#     type: time
#     description: "Timestamp when the line record was created in the source system"
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: CREATION_TS ;;
#   }
#   dimension: credited_quantity {
#     type: number
#     description: "Credited quantity"
#     sql: CREDITED_QUANTITY ;;
#   }
#   dimension: fiscal_gl_period_name {
#     type: string
#     description: "Accounting period name"
#     sql: FISCAL_GL_PERIOD_NAME ;;
#   }
#   dimension: fiscal_gl_period_num {
#     type: number
#     description: "Accounting period based on the ledger date"
#     sql: FISCAL_GL_PERIOD_NUM ;;
#   }
#   dimension: fiscal_gl_quarter_num {
#     type: number
#     description: "Accounting quarter based on the ledger date"
#     sql: FISCAL_GL_QUARTER_NUM ;;
#   }
#   dimension: fiscal_gl_year_num {
#     type: number
#     description: "Accounting year based on the ledger date"
#     sql: FISCAL_GL_YEAR_NUM ;;
#   }
#   dimension: fiscal_period_set_name {
#     type: string
#     description: "Accounting calendar name"
#     sql: FISCAL_PERIOD_SET_NAME ;;
#   }
#   dimension: fiscal_period_type {
#     type: string
#     description: "Accounting period type"
#     sql: FISCAL_PERIOD_TYPE ;;
#   }
#   dimension: gross_unit_selling_price {
#     type: number
#     description: "Actual price charged to customer post-tax"
#     sql: GROSS_UNIT_SELLING_PRICE ;;
#   }
#   dimension: inventory_item_id {
#     type: number
#     description: "Foreign key identifying the item"
#     sql: INVENTORY_ITEM_ID ;;
#   }
#   dimension: invoiced_quantity {
#     type: number
#     description: "Invoiced quantity"
#     sql: INVOICED_QUANTITY ;;
#   }
#   dimension: is_intercompany {
#     type: yesno
#     description: "Indicates whether the transaction was internal within the company"
#     sql: IS_INTERCOMPANY ;;
#   }
#   dimension: item_categories {
#     hidden: yes
#     sql: ITEM_CATEGORIES ;;
#   }
#   dimension: item_descriptions {
#     hidden: yes
#     sql: ITEM_DESCRIPTIONS ;;
#   }
#   dimension: item_organization_id {
#     type: number
#     description: "Foreign key identifying the organization that shipped the line"
#     sql: ITEM_ORGANIZATION_ID ;;
#   }
#   dimension: item_organization_name {
#     type: string
#     description: "Item organization name"
#     sql: ITEM_ORGANIZATION_NAME ;;
#   }
#   dimension: item_part_number {
#     type: string
#     description: "Item part number"
#     sql: ITEM_PART_NUMBER ;;
#   }
#   dimension_group: last_update_ts {
#     type: time
#     description: "Timestamp when the line record was last updated in the source system"
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: LAST_UPDATE_TS ;;
#   }
#   dimension_group: ledger {
#     type: time
#     description: "Date when the invoice line applied to the ledger"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: LEDGER_DATE ;;
#   }
#   dimension: line_description {
#     type: string
#     description: "Invoice line description"
#     sql: LINE_DESCRIPTION ;;
#   }
#   dimension: line_id {
#     type: number
#     description: "Nested primary key identifying the invoice line"
#     sql: LINE_ID ;;
#   }
#   dimension: line_number {
#     type: number
#     description: "Invoice line number"
#     sql: LINE_NUMBER ;;
#   }
#   dimension: order_header_id {
#     type: number
#     description: "Foreign key identifying the order header"
#     sql: ORDER_HEADER_ID ;;
#   }
#   dimension: order_header_number {
#     type: number
#     description: "Order header number"
#     sql: ORDER_HEADER_NUMBER ;;
#   }
#   dimension: order_source_id {
#     type: number
#     description: "Foreign key identifying the order source"
#     sql: ORDER_SOURCE_ID ;;
#   }
#   dimension: order_source_name {
#     type: string
#     description: "Order source name"
#     sql: ORDER_SOURCE_NAME ;;
#   }
#   dimension_group: ordered {
#     type: time
#     description: "Date the order was placed"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: ORDERED_DATE ;;
#   }
#   dimension: ordered_quantity {
#     type: number
#     description: "Ordered quantity"
#     sql: ORDERED_QUANTITY ;;
#   }
#   dimension: quantity_uom {
#     type: string
#     description: "Quantity unit of measure"
#     sql: QUANTITY_UOM ;;
#   }
#   dimension: revenue_amount {
#     type: number
#     description: "Transaction line amount recognized as revenue for accounting purposes"
#     sql: REVENUE_AMOUNT ;;
#   }
#   dimension: sales_invoices__lines {
#     type: string
#     description: "Nested repeated field containing all line level details"
#     hidden: yes
#     sql: sales_invoices__lines ;;
#   }
#   dimension: tax_amount {
#     type: number
#     description: "Tax amount associated with the transaction line"
#     sql: TAX_AMOUNT ;;
#   }
#   dimension: transaction_amount {
#     type: number
#     description: "Pre-tax transaction line amount"
#     sql: TRANSACTION_AMOUNT ;;
#   }
#   dimension: unit_discount_price {
#     type: number
#     description: "Difference between the post-tax list price and post-tax actual selling price"
#     sql: UNIT_DISCOUNT_PRICE ;;
#   }
#   dimension: unit_list_price {
#     type: number
#     description: "List price for the item post-tax"
#     sql: UNIT_LIST_PRICE ;;
#   }
#   dimension: unit_selling_price {
#     type: number
#     description: "Actual price charged to customer pre-tax"
#     sql: UNIT_SELLING_PRICE ;;
#   }
# }

# view: sales_invoices__lines__item_categories {
#   drill_fields: [id]

#   dimension: id {
#     primary_key: yes
#     type: number
#     description: "Foreign key identifying item categories"
#     sql: ${TABLE}.ID ;;
#   }
#   dimension: category_name {
#     type: string
#     description: "Item category name"
#     sql: ${TABLE}.CATEGORY_NAME ;;
#   }
#   dimension: category_set_id {
#     type: number
#     description: "Foreign key identifying item category sets"
#     sql: ${TABLE}.CATEGORY_SET_ID ;;
#   }
#   dimension: category_set_name {
#     type: string
#     description: "Item category set name"
#     sql: ${TABLE}.CATEGORY_SET_NAME ;;
#   }
#   dimension: description {
#     type: string
#     description: "Item category description"
#     sql: ${TABLE}.DESCRIPTION ;;
#   }
# }

# view: sales_invoices__lines__item_descriptions {

#   dimension: language {
#     type: string
#     description: "Language code of the item description"
#     sql: ${TABLE}.LANGUAGE ;;
#   }
#   dimension: text {
#     type: string
#     description: "Item description text"
#     sql: ${TABLE}.TEXT ;;
#   }
# }
