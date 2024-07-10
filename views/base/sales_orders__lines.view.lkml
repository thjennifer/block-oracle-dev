view: sales_orders__lines {
  # drill_fields: [return_line_ids]

  dimension: return_line_ids {
    primary_key: yes
    hidden: yes
    sql: RETURN_LINE_IDS ;;
  }
  dimension_group: actual_ship {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ACTUAL_SHIP_DATE ;;
  }
  dimension: backlog_amount {
    type: number
    sql: BACKLOG_AMOUNT ;;
  }
  dimension: backlog_quantity {
    type: number
    sql: BACKLOG_QUANTITY ;;
  }
  dimension: booking_amount {
    type: number
    sql: BOOKING_AMOUNT ;;
  }
  dimension: booking_quantity {
    type: number
    sql: BOOKING_QUANTITY ;;
  }
  dimension: cancel_reason {
    hidden: yes
    sql: CANCEL_REASON ;;
  }
  dimension: cancelled_quantity {
    type: number
    sql: CANCELLED_QUANTITY ;;
  }
  dimension_group: creation_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CREATION_TS ;;
  }
  dimension: cycle_time_days {
    type: number
    sql: CYCLE_TIME_DAYS ;;
  }
  dimension: fulfilled_amount {
    type: number
    sql: FULFILLED_AMOUNT ;;
  }
  dimension: fulfilled_quantity {
    type: number
    sql: FULFILLED_QUANTITY ;;
  }
  dimension_group: fulfillment {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: FULFILLMENT_DATE ;;
  }
  dimension: fulfillment_days_after_promise_date {
    type: number
    sql: FULFILLMENT_DAYS_AFTER_PROMISE_DATE ;;
  }
  dimension: fulfillment_days_after_request_date {
    type: number
    sql: FULFILLMENT_DAYS_AFTER_REQUEST_DATE ;;
  }
  dimension: has_return {
    type: yesno
    sql: HAS_RETURN ;;
  }
  dimension: inventory_item_id {
    type: number
    sql: INVENTORY_ITEM_ID ;;
  }
  dimension: invoiced_amount {
    type: number
    sql: INVOICED_AMOUNT ;;
  }
  dimension: invoiced_quantity {
    type: number
    sql: INVOICED_QUANTITY ;;
  }
  dimension: is_backlog {
    type: yesno
    sql: IS_BACKLOG ;;
  }
  dimension: is_backordered {
    type: yesno
    sql: IS_BACKORDERED ;;
  }
  dimension: is_booked {
    type: yesno
    sql: IS_BOOKED ;;
  }
  dimension: is_booking {
    type: yesno
    sql: IS_BOOKING ;;
  }
  dimension: is_cancelled {
    type: yesno
    sql: IS_CANCELLED ;;
  }
  dimension: is_fulfilled {
    type: yesno
    sql: IS_FULFILLED ;;
  }
  dimension: is_fulfilled_by_promise_date {
    type: yesno
    sql: IS_FULFILLED_BY_PROMISE_DATE ;;
  }
  dimension: is_fulfilled_by_request_date {
    type: yesno
    sql: IS_FULFILLED_BY_REQUEST_DATE ;;
  }
  dimension: is_open {
    type: yesno
    sql: IS_OPEN ;;
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
  dimension: line_category_code {
    type: string
    sql: LINE_CATEGORY_CODE ;;
  }
  dimension: line_id {
    type: number
    sql: LINE_ID ;;
  }
  dimension: line_number {
    type: number
    sql: LINE_NUMBER ;;
  }
  dimension: line_status {
    type: string
    sql: LINE_STATUS ;;
  }
  dimension: ordered_amount {
    type: number
    sql: ORDERED_AMOUNT ;;
  }
  dimension: ordered_quantity {
    type: number
    sql: ORDERED_QUANTITY ;;
  }
  dimension: ordered_weight {
    type: number
    sql: ORDERED_WEIGHT ;;
  }
  dimension_group: promise_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: PROMISE_DATE ;;
  }
  dimension: quantity_uom {
    type: string
    sql: QUANTITY_UOM ;;
  }
  dimension_group: request_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: REQUEST_DATE ;;
  }
  dimension: sales_orders__lines {
    type: string
    hidden: yes
    sql: sales_orders__lines ;;
  }
  dimension_group: schedule_ship {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: SCHEDULE_SHIP_DATE ;;
  }
  dimension: shipped_amount {
    type: number
    sql: SHIPPED_AMOUNT ;;
  }
  dimension: shipped_quantity {
    type: number
    sql: SHIPPED_QUANTITY ;;
  }
  dimension: shipped_weight {
    type: number
    sql: SHIPPED_WEIGHT ;;
  }
  dimension: unit_cost {
    type: number
    sql: UNIT_COST ;;
  }
  dimension: unit_list_price {
    type: number
    sql: UNIT_LIST_PRICE ;;
  }
  dimension: unit_selling_price {
    type: number
    sql: UNIT_SELLING_PRICE ;;
  }
  dimension: unit_weight {
    type: number
    sql: UNIT_WEIGHT ;;
  }
  dimension: weight_uom {
    type: string
    sql: WEIGHT_UOM ;;
  }
}
