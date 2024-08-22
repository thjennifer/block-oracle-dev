view: sales_invoices__lines {
  # drill_fields: [order_line_id]

  dimension: order_line_id {
    primary_key: yes
    type: number
    sql: ORDER_LINE_ID ;;
  }
  dimension_group: creation_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CREATION_TS ;;
  }
  dimension: credited_quantity {
    type: number
    sql: CREDITED_QUANTITY ;;
  }
  dimension: fiscal_gl_period_num {
    type: number
    sql: FISCAL_GL_PERIOD_NUM ;;
  }
  dimension: fiscal_gl_quarter_num {
    type: number
    sql: FISCAL_GL_QUARTER_NUM ;;
  }
  dimension: fiscal_gl_year_num {
    type: number
    sql: FISCAL_GL_YEAR_NUM ;;
  }
  dimension: fiscal_gl_period_name {
    type: string
    sql: FISCAL_GL_PERIOD_NAME ;;
  }
  dimension: fiscal_period_set_name {
    type: string
    sql: FISCAL_PERIOD_SET_NAME ;;
  }
  dimension: fiscal_period_type {
    type: string
    sql: FISCAL_PERIOD_TYPE ;;
  }
  dimension: gross_unit_selling_price {
    type: number
    sql: GROSS_UNIT_SELLING_PRICE ;;
  }
  dimension: inventory_item_id {
    type: number
    sql: INVENTORY_ITEM_ID ;;
  }
  dimension: invoiced_quantity {
    type: number
    sql: INVOICED_QUANTITY ;;
  }
  dimension: is_intercompany {
    type: yesno
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
    sql: ITEM_ORGANIZATION_ID ;;
  }
  dimension: item_organization_name {
    type: string
    sql: ITEM_ORGANIZATION_NAME ;;
  }
  dimension: item_part_number {
    type: string
    sql: ITEM_PART_NUMBER ;;
  }
  dimension_group: last_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: LAST_UPDATE_TS ;;
  }
  dimension_group: ledger {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: LEDGER_DATE ;;
  }
  dimension: line_description {
    type: string
    sql: LINE_DESCRIPTION ;;
  }
  dimension: line_id {
    type: number
    sql: LINE_ID ;;
  }
  dimension: line_number {
    type: number
    sql: LINE_NUMBER ;;
  }
  dimension: order_header_id {
    type: number
    sql: ORDER_HEADER_ID ;;
  }
  dimension: order_header_number {
    type: number
    sql: ORDER_HEADER_NUMBER ;;
  }
  dimension: order_source_id {
    type: number
    sql: ORDER_SOURCE_ID ;;
  }
  dimension: order_source_name {
    type: string
    sql: ORDER_SOURCE_NAME ;;
  }
  dimension_group: ordered {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ORDERED_DATE ;;
  }
  dimension: ordered_quantity {
    type: number
    sql: ORDERED_QUANTITY ;;
  }
  dimension: quantity_uom {
    type: string
    sql: QUANTITY_UOM ;;
  }
  dimension: revenue_amount {
    type: number
    sql: REVENUE_AMOUNT ;;
  }
  dimension: sales_invoices__lines {
    type: string
    hidden: yes
    sql: sales_invoices__lines ;;
  }
  dimension: tax_amount {
    type: number
    sql: TAX_AMOUNT ;;
  }
  dimension: transaction_amount {
    type: number
    sql: TRANSACTION_AMOUNT ;;
  }
  dimension: unit_discount_price {
    type: number
    sql: UNIT_DISCOUNT_PRICE ;;
  }
  dimension: unit_list_price {
    type: number
    sql: UNIT_LIST_PRICE ;;
  }
  dimension: unit_selling_price {
    type: number
    sql: UNIT_SELLING_PRICE ;;
  }
}
