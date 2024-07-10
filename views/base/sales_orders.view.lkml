#########################################################{
# CREATED USING CREATE VIEW FROM TABLE
# Includes SalesOrders and Nested Repeated Structs for Lines and Lines Item Categories, Lines Item Descriptions and Lines Return Line Ids
#
# Note, a few manual changes made to remove specific fields and drill fields properties
#   - commented out ordered_month, ordered_quarter and ordered_year and using "dimension group: ordered" to derive these as date types
#   - in sales_orders__lines commented out drill_fields property
#   - in sales_orders__lines__item_categories commented out drill_fields property
#########################################################}

view: sales_orders {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesOrders` ;;

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
  dimension_group: booked {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.BOOKED_DATE ;;
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
  dimension: fiscal_period_name {
    type: string
    sql: ${TABLE}.FISCAL_PERIOD_NAME ;;
  }
  dimension: fiscal_period_num {
    type: number
    sql: ${TABLE}.FISCAL_PERIOD_NUM ;;
  }
  dimension: fiscal_period_set_name {
    type: string
    sql: ${TABLE}.FISCAL_PERIOD_SET_NAME ;;
  }
  dimension: fiscal_period_type {
    type: string
    sql: ${TABLE}.FISCAL_PERIOD_TYPE ;;
  }
  dimension: fiscal_quarter_num {
    type: number
    sql: ${TABLE}.FISCAL_QUARTER_NUM ;;
  }
  dimension: fiscal_year_num {
    type: number
    sql: ${TABLE}.FISCAL_YEAR_NUM ;;
  }
  dimension_group: fulfillment {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.FULFILLMENT_DATE ;;
  }
  dimension: has_backorder {
    type: yesno
    sql: ${TABLE}.HAS_BACKORDER ;;
  }
  dimension: has_cancelled {
    type: yesno
    sql: ${TABLE}.HAS_CANCELLED ;;
  }
  dimension: has_hold {
    type: yesno
    sql: ${TABLE}.HAS_HOLD ;;
  }
  dimension: has_return_line {
    type: yesno
    sql: ${TABLE}.HAS_RETURN_LINE ;;
  }
  dimension: header_id {
    type: number
    sql: ${TABLE}.HEADER_ID ;;
  }
  dimension: header_status {
    type: string
    sql: ${TABLE}.HEADER_STATUS ;;
  }
  dimension: is_booked {
    type: yesno
    sql: ${TABLE}.IS_BOOKED ;;
  }
  dimension: is_cancelled {
    type: yesno
    sql: ${TABLE}.IS_CANCELLED ;;
  }
  dimension: is_fulfilled {
    type: yesno
    sql: ${TABLE}.IS_FULFILLED ;;
  }
  dimension: is_held {
    type: yesno
    sql: ${TABLE}.IS_HELD ;;
  }
  dimension: is_intercompany {
    type: yesno
    sql: ${TABLE}.IS_INTERCOMPANY ;;
  }
  dimension: is_open {
    type: yesno
    sql: ${TABLE}.IS_OPEN ;;
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
  dimension: num_lines {
    type: number
    sql: ${TABLE}.NUM_LINES ;;
  }
  dimension: num_lines_fulfilled_by_promise_date {
    type: number
    sql: ${TABLE}.NUM_LINES_FULFILLED_BY_PROMISE_DATE ;;
  }
  dimension: num_lines_fulfilled_by_request_date {
    type: number
    sql: ${TABLE}.NUM_LINES_FULFILLED_BY_REQUEST_DATE ;;
  }
  dimension: order_category_code {
    type: string
    sql: ${TABLE}.ORDER_CATEGORY_CODE ;;
  }
  dimension: order_number {
    type: number
    sql: ${TABLE}.ORDER_NUMBER ;;
  }
  dimension: order_source_id {
    type: number
    sql: ${TABLE}.ORDER_SOURCE_ID ;;
  }
  dimension: order_source_name {
    type: string
    sql: ${TABLE}.ORDER_SOURCE_NAME ;;
  }
  dimension_group: ordered {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ORDERED_DATE ;;
  }
  dimension: ordered_month_num {
    type: number
    sql: ${TABLE}.ORDERED_MONTH_NUM ;;
  }
  dimension: ordered_quarter_num {
    type: number
    sql: ${TABLE}.ORDERED_QUARTER_NUM ;;
  }
  dimension: ordered_year_num {
    type: number
    sql: ${TABLE}.ORDERED_YEAR_NUM ;;
  }
  dimension_group: request_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.REQUEST_DATE ;;
  }
  dimension: sales_rep {
    type: string
    sql: ${TABLE}.SALES_REP ;;
  }
  dimension: ship_to_customer_country {
    type: string
    sql: ${TABLE}.SHIP_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: ship_to_customer_name {
    type: string
    sql: ${TABLE}.SHIP_TO_CUSTOMER_NAME ;;
  }
  dimension: ship_to_customer_number {
    type: string
    sql: ${TABLE}.SHIP_TO_CUSTOMER_NUMBER ;;
  }
  dimension: ship_to_site_use_id {
    type: number
    sql: ${TABLE}.SHIP_TO_SITE_USE_ID ;;
  }
  dimension: sold_to_customer_country {
    type: string
    sql: ${TABLE}.SOLD_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: sold_to_customer_name {
    type: string
    sql: ${TABLE}.SOLD_TO_CUSTOMER_NAME ;;
  }
  dimension: sold_to_customer_number {
    type: string
    sql: ${TABLE}.SOLD_TO_CUSTOMER_NUMBER ;;
  }
  dimension: sold_to_site_use_id {
    type: number
    sql: ${TABLE}.SOLD_TO_SITE_USE_ID ;;
  }
  dimension: total_ordered_amount {
    type: number
    sql: ${TABLE}.TOTAL_ORDERED_AMOUNT ;;
  }
  dimension: total_sales_ordered_amount {
    type: number
    sql: ${TABLE}.TOTAL_SALES_ORDERED_AMOUNT ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      ledger_name,
      sold_to_customer_name,
      fiscal_period_set_name,
      order_source_name,
      fiscal_period_name,
      ship_to_customer_name,
      business_unit_name,
      bill_to_customer_name
    ]
  }

}

# view: sales_orders__lines {
#   drill_fields: [return_line_ids]

#   dimension: return_line_ids {
#     primary_key: yes
#     hidden: yes
#     sql: RETURN_LINE_IDS ;;
#   }
#   dimension_group: actual_ship {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: ACTUAL_SHIP_DATE ;;
#   }
#   dimension: backlog_amount {
#     type: number
#     sql: BACKLOG_AMOUNT ;;
#   }
#   dimension: backlog_quantity {
#     type: number
#     sql: BACKLOG_QUANTITY ;;
#   }
#   dimension: booking_amount {
#     type: number
#     sql: BOOKING_AMOUNT ;;
#   }
#   dimension: booking_quantity {
#     type: number
#     sql: BOOKING_QUANTITY ;;
#   }
#   dimension: cancel_reason {
#     hidden: yes
#     sql: CANCEL_REASON ;;
#   }
#   dimension: cancelled_quantity {
#     type: number
#     sql: CANCELLED_QUANTITY ;;
#   }
#   dimension_group: creation_ts {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: CREATION_TS ;;
#   }
#   dimension: cycle_time_days {
#     type: number
#     sql: CYCLE_TIME_DAYS ;;
#   }
#   dimension: fulfilled_amount {
#     type: number
#     sql: FULFILLED_AMOUNT ;;
#   }
#   dimension: fulfilled_quantity {
#     type: number
#     sql: FULFILLED_QUANTITY ;;
#   }
#   dimension_group: fulfillment {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: FULFILLMENT_DATE ;;
#   }
#   dimension: fulfillment_days_after_promise_date {
#     type: number
#     sql: FULFILLMENT_DAYS_AFTER_PROMISE_DATE ;;
#   }
#   dimension: fulfillment_days_after_request_date {
#     type: number
#     sql: FULFILLMENT_DAYS_AFTER_REQUEST_DATE ;;
#   }
#   dimension: has_return {
#     type: yesno
#     sql: HAS_RETURN ;;
#   }
#   dimension: inventory_item_id {
#     type: number
#     sql: INVENTORY_ITEM_ID ;;
#   }
#   dimension: invoiced_amount {
#     type: number
#     sql: INVOICED_AMOUNT ;;
#   }
#   dimension: invoiced_quantity {
#     type: number
#     sql: INVOICED_QUANTITY ;;
#   }
#   dimension: is_backlog {
#     type: yesno
#     sql: IS_BACKLOG ;;
#   }
#   dimension: is_backordered {
#     type: yesno
#     sql: IS_BACKORDERED ;;
#   }
#   dimension: is_booked {
#     type: yesno
#     sql: IS_BOOKED ;;
#   }
#   dimension: is_booking {
#     type: yesno
#     sql: IS_BOOKING ;;
#   }
#   dimension: is_cancelled {
#     type: yesno
#     sql: IS_CANCELLED ;;
#   }
#   dimension: is_fulfilled {
#     type: yesno
#     sql: IS_FULFILLED ;;
#   }
#   dimension: is_fulfilled_by_promise_date {
#     type: yesno
#     sql: IS_FULFILLED_BY_PROMISE_DATE ;;
#   }
#   dimension: is_fulfilled_by_request_date {
#     type: yesno
#     sql: IS_FULFILLED_BY_REQUEST_DATE ;;
#   }
#   dimension: is_open {
#     type: yesno
#     sql: IS_OPEN ;;
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
#     sql: ITEM_ORGANIZATION_ID ;;
#   }
#   dimension: item_organization_name {
#     type: string
#     sql: ITEM_ORGANIZATION_NAME ;;
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
#   dimension: line_category_code {
#     type: string
#     sql: LINE_CATEGORY_CODE ;;
#   }
#   dimension: line_id {
#     type: number
#     sql: LINE_ID ;;
#   }
#   dimension: line_number {
#     type: number
#     sql: LINE_NUMBER ;;
#   }
#   dimension: line_status {
#     type: string
#     sql: LINE_STATUS ;;
#   }
#   dimension: ordered_amount {
#     type: number
#     sql: ORDERED_AMOUNT ;;
#   }
#   dimension: ordered_quantity {
#     type: number
#     sql: ORDERED_QUANTITY ;;
#   }
#   dimension: ordered_weight {
#     type: number
#     sql: ORDERED_WEIGHT ;;
#   }
#   dimension_group: promise_date {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: PROMISE_DATE ;;
#   }
#   dimension: quantity_uom {
#     type: string
#     sql: QUANTITY_UOM ;;
#   }
#   dimension_group: request_date {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: REQUEST_DATE ;;
#   }
#   dimension: sales_orders__lines {
#     type: string
#     hidden: yes
#     sql: sales_orders__lines ;;
#   }
#   dimension_group: schedule_ship {
#     type: time
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: SCHEDULE_SHIP_DATE ;;
#   }
#   dimension: shipped_amount {
#     type: number
#     sql: SHIPPED_AMOUNT ;;
#   }
#   dimension: shipped_quantity {
#     type: number
#     sql: SHIPPED_QUANTITY ;;
#   }
#   dimension: shipped_weight {
#     type: number
#     sql: SHIPPED_WEIGHT ;;
#   }
#   dimension: unit_cost {
#     type: number
#     sql: UNIT_COST ;;
#   }
#   dimension: unit_list_price {
#     type: number
#     sql: UNIT_LIST_PRICE ;;
#   }
#   dimension: unit_selling_price {
#     type: number
#     sql: UNIT_SELLING_PRICE ;;
#   }
#   dimension: unit_weight {
#     type: number
#     sql: UNIT_WEIGHT ;;
#   }
#   dimension: weight_uom {
#     type: string
#     sql: WEIGHT_UOM ;;
#   }
# }

# view: sales_orders__lines__return_line_ids {

#   dimension: sales_orders__lines__return_line_ids {
#     type: number
#     value_format_name: id
#     sql: sales_orders__lines__return_line_ids ;;
#   }
# }

# view: sales_orders__lines__cancel_reason {

#   dimension: code {
#     type: string
#     sql: ${TABLE}.CODE ;;
#   }
#   dimension: language {
#     type: string
#     sql: ${TABLE}.LANGUAGE ;;
#   }
#   dimension: meaning {
#     type: string
#     sql: ${TABLE}.MEANING ;;
#   }
# }

# view: sales_orders__lines__item_categories {
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

# view: sales_orders__lines__item_descriptions {

#   dimension: language {
#     type: string
#     sql: ${TABLE}.LANGUAGE ;;
#   }
#   dimension: text {
#     type: string
#     sql: ${TABLE}.TEXT ;;
#   }
# }
