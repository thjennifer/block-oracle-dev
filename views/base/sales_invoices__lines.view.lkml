# modified to comment out auto-generated drill_fields
view: sales_invoices__lines {
  # drill_fields: [order_line_id]

  dimension: order_line_id {
    primary_key: yes
    type: number
    description: "Foreign key identifying the order line"
    sql: ORDER_LINE_ID ;;
  }
  dimension_group: creation_ts {
    type: time
    description: "Timestamp when the line record was created in the source system"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CREATION_TS ;;
  }
  dimension: credited_quantity {
    type: number
    description: "Credited quantity"
    sql: CREDITED_QUANTITY ;;
  }
  dimension: fiscal_gl_period_name {
    type: string
    description: "Accounting period name"
    sql: FISCAL_GL_PERIOD_NAME ;;
  }
  dimension: fiscal_gl_period_num {
    type: number
    description: "Accounting period based on the ledger date"
    sql: FISCAL_GL_PERIOD_NUM ;;
  }
  dimension: fiscal_gl_quarter_num {
    type: number
    description: "Accounting quarter based on the ledger date"
    sql: FISCAL_GL_QUARTER_NUM ;;
  }
  dimension: fiscal_gl_year_num {
    type: number
    description: "Accounting year based on the ledger date"
    sql: FISCAL_GL_YEAR_NUM ;;
  }
  dimension: fiscal_period_set_name {
    type: string
    description: "Accounting calendar name"
    sql: FISCAL_PERIOD_SET_NAME ;;
  }
  dimension: fiscal_period_type {
    type: string
    description: "Accounting period type"
    sql: FISCAL_PERIOD_TYPE ;;
  }
  dimension: gross_unit_selling_price {
    type: number
    description: "Actual price charged to customer post-tax"
    sql: GROSS_UNIT_SELLING_PRICE ;;
  }
  dimension: inventory_item_id {
    type: number
    description: "Foreign key identifying the item"
    sql: INVENTORY_ITEM_ID ;;
  }
  dimension: invoiced_quantity {
    type: number
    description: "Invoiced quantity"
    sql: INVOICED_QUANTITY ;;
  }
  dimension: is_intercompany {
    type: yesno
    description: "Indicates whether the transaction was internal within the company"
    sql: IS_INTERCOMPANY ;;
  }
  dimension: item_categories {
    hidden: yes
    sql: ITEM_CATEGORIES ;;
  }
  dimension: item_descriptions {
    hidden: yes
    sql: ITEM_DESCRIPTIONS ;;
  }
  dimension: item_organization_id {
    type: number
    description: "Foreign key identifying the organization that shipped the line"
    sql: ITEM_ORGANIZATION_ID ;;
  }
  dimension: item_organization_name {
    type: string
    description: "Item organization name"
    sql: ITEM_ORGANIZATION_NAME ;;
  }
  dimension: item_part_number {
    type: string
    description: "Item part number"
    sql: ITEM_PART_NUMBER ;;
  }
  dimension_group: last_update_ts {
    type: time
    description: "Timestamp when the line record was last updated in the source system"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: LAST_UPDATE_TS ;;
  }
  dimension_group: ledger {
    type: time
    description: "Date when the invoice line applied to the ledger"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: LEDGER_DATE ;;
  }
  dimension: line_description {
    type: string
    description: "Invoice line description"
    sql: LINE_DESCRIPTION ;;
  }
  dimension: line_id {
    type: number
    description: "Nested primary key identifying the invoice line"
    sql: LINE_ID ;;
  }
  dimension: line_number {
    type: number
    description: "Invoice line number"
    sql: LINE_NUMBER ;;
  }
  dimension: order_header_id {
    type: number
    description: "Foreign key identifying the order header"
    sql: ORDER_HEADER_ID ;;
  }
  dimension: order_header_number {
    type: number
    description: "Order header number"
    sql: ORDER_HEADER_NUMBER ;;
  }
  dimension: order_source_id {
    type: number
    description: "Foreign key identifying the order source"
    sql: ORDER_SOURCE_ID ;;
  }
  dimension: order_source_name {
    type: string
    description: "Order source name"
    sql: ORDER_SOURCE_NAME ;;
  }
  dimension_group: ordered {
    type: time
    description: "Date the order was placed"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ORDERED_DATE ;;
  }
  dimension: ordered_quantity {
    type: number
    description: "Ordered quantity"
    sql: ORDERED_QUANTITY ;;
  }
  dimension: quantity_uom {
    type: string
    description: "Quantity unit of measure"
    sql: QUANTITY_UOM ;;
  }
  dimension: revenue_amount {
    type: number
    description: "Transaction line amount recognized as revenue for accounting purposes"
    sql: REVENUE_AMOUNT ;;
  }
  dimension: sales_invoices__lines {
    type: string
    description: "Nested repeated field containing all line level details"
    hidden: yes
    sql: sales_invoices__lines ;;
  }
  dimension: tax_amount {
    type: number
    description: "Tax amount associated with the transaction line"
    sql: TAX_AMOUNT ;;
  }
  dimension: transaction_amount {
    type: number
    description: "Pre-tax transaction line amount"
    sql: TRANSACTION_AMOUNT ;;
  }
  dimension: unit_discount_price {
    type: number
    description: "Difference between the post-tax list price and post-tax actual selling price"
    sql: UNIT_DISCOUNT_PRICE ;;
  }
  dimension: unit_list_price {
    type: number
    description: "List price for the item post-tax"
    sql: UNIT_LIST_PRICE ;;
  }
  dimension: unit_selling_price {
    type: number
    description: "Actual price charged to customer pre-tax"
    sql: UNIT_SELLING_PRICE ;;
  }
}
