
view: sales_invoices {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesInvoices` ;;

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
  dimension_group: creation_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.CREATION_TS ;;
  }
  dimension: currency_code {
    type: string
    sql: ${TABLE}.CURRENCY_CODE ;;
  }
  dimension_group: invoice {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.INVOICE_DATE ;;
  }
  dimension: invoice_id {
    type: number
    sql: ${TABLE}.INVOICE_ID ;;
  }
  dimension: invoice_month_num {
    type: number
    sql: ${TABLE}.INVOICE_MONTH_NUM ;;
  }
  dimension: invoice_number {
    type: string
    sql: ${TABLE}.INVOICE_NUMBER ;;
  }
  dimension: invoice_quarter_num {
    type: number
    sql: ${TABLE}.INVOICE_QUARTER_NUM ;;
  }
  dimension: invoice_type {
    type: string
    sql: ${TABLE}.INVOICE_TYPE ;;
  }
  dimension: invoice_type_id {
    type: number
    sql: ${TABLE}.INVOICE_TYPE_ID ;;
  }
  dimension: invoice_type_name {
    type: string
    sql: ${TABLE}.INVOICE_TYPE_NAME ;;
  }
  dimension: invoice_year_num {
    type: number
    sql: ${TABLE}.INVOICE_YEAR_NUM ;;
  }
  dimension: is_complete {
    type: yesno
    sql: ${TABLE}.IS_COMPLETE ;;
  }
  dimension_group: last_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.LAST_UPDATE_TS ;;
  }
  dimension: ledger_id {
    type: number
    sql: ${TABLE}.LEDGER_ID ;;
  }
  dimension: ledger_name {
    type: string
    sql: ${TABLE}.LEDGER_NAME ;;
  }
  dimension: lines {
    hidden: yes
    sql: ${TABLE}.LINES ;;
  }
  dimension: total_revenue_amount {
    type: number
    sql: ${TABLE}.TOTAL_REVENUE_AMOUNT ;;
  }
  dimension: total_tax_amount {
    type: number
    sql: ${TABLE}.TOTAL_TAX_AMOUNT ;;
  }
  dimension: total_transaction_amount {
    type: number
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
#     sql: ORDER_LINE_ID ;;
#   }
#   dimension_group: creation_ts {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: CREATION_TS ;;
#   }
#   dimension: credited_quantity {
#     type: number
#     sql: CREDITED_QUANTITY ;;
#   }
#   dimension: fiscal_gl_month {
#     type: number
#     sql: FISCAL_GL_MONTH ;;
#   }
#   dimension: fiscal_gl_quarter {
#     type: number
#     sql: FISCAL_GL_QUARTER ;;
#   }
#   dimension: fiscal_gl_year {
#     type: number
#     sql: FISCAL_GL_YEAR ;;
#   }
#   dimension: fiscal_period_name {
#     type: string
#     sql: FISCAL_PERIOD_NAME ;;
#   }
#   dimension: fiscal_period_set_name {
#     type: string
#     sql: FISCAL_PERIOD_SET_NAME ;;
#   }
#   dimension: fiscal_period_type {
#     type: string
#     sql: FISCAL_PERIOD_TYPE ;;
#   }
#   dimension: inventory_item_id {
#     type: number
#     sql: INVENTORY_ITEM_ID ;;
#   }
#   dimension: invoiced_quantity {
#     type: number
#     sql: INVOICED_QUANTITY ;;
#   }
#   dimension: is_intercompany {
#     type: yesno
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
#   dimension: item_part_number {
#     type: string
#     sql: ITEM_PART_NUMBER ;;
#   }
#   dimension_group: last_update_ts {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: LAST_UPDATE_TS ;;
#   }
#   dimension_group: ledger {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: LEDGER_DATE ;;
#   }
#   dimension: line_description {
#     type: string
#     sql: LINE_DESCRIPTION ;;
#   }
#   dimension: line_id {
#     type: number
#     sql: LINE_ID ;;
#   }
#   dimension: line_number {
#     type: number
#     sql: LINE_NUMBER ;;
#   }
#   dimension: order_header_id {
#     type: number
#     sql: ORDER_HEADER_ID ;;
#   }
#   dimension: order_source_id {
#     type: number
#     sql: ORDER_SOURCE_ID ;;
#   }
#   dimension: order_source_name {
#     type: string
#     sql: ORDER_SOURCE_NAME ;;
#   }
#   dimension_group: ordered {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: ORDERED_DATE ;;
#   }
#   dimension: ordered_quantity {
#     type: number
#     sql: ORDERED_QUANTITY ;;
#   }
#   dimension: quantity_uom {
#     type: string
#     sql: QUANTITY_UOM ;;
#   }
#   dimension: revenue_amount {
#     type: number
#     sql: REVENUE_AMOUNT ;;
#   }
#   dimension: sales_invoices__lines {
#     type: string
#     hidden: yes
#     sql: sales_invoices__lines ;;
#   }
#   dimension: tax_amount {
#     type: number
#     sql: TAX_AMOUNT ;;
#   }
#   dimension: transaction_amount {
#     type: number
#     sql: TRANSACTION_AMOUNT ;;
#   }
#   dimension: unit_discount_price {
#     type: number
#     sql: UNIT_DISCOUNT_PRICE ;;
#   }
#   dimension: unit_list_price {
#     type: number
#     sql: UNIT_LIST_PRICE ;;
#   }
#   dimension: unit_selling_price {
#     type: number
#     sql: UNIT_SELLING_PRICE ;;
#   }
# }

# view: sales_invoices__lines__item_categories {
#   drill_fields: [id]

#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.ID ;;
#   }
#   dimension: category_name {
#     type: string
#     sql: ${TABLE}.CATEGORY_NAME ;;
#   }
#   dimension: category_set_id {
#     type: number
#     sql: ${TABLE}.CATEGORY_SET_ID ;;
#   }
#   dimension: category_set_name {
#     type: string
#     sql: ${TABLE}.CATEGORY_SET_NAME ;;
#   }
#   dimension: description {
#     type: string
#     sql: ${TABLE}.DESCRIPTION ;;
#   }
# }

# view: sales_invoices__lines__item_descriptions {

#   dimension: language {
#     type: string
#     sql: ${TABLE}.LANGUAGE ;;
#   }
#   dimension: text {
#     type: string
#     sql: ${TABLE}.TEXT ;;
#   }
# }
