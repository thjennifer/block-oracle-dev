# modified to comment out auto-generated drill_fields
view: sales_orders__lines {
  # drill_fields: [return_line_ids]

  dimension: return_line_ids {
    primary_key: yes
    hidden: yes
    sql: RETURN_LINE_IDS ;;
  }
  dimension_group: actual_ship {
    type: time
    description: "Actual shipment date of the line"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ACTUAL_SHIP_DATE ;;
  }
  dimension: backlog_amount {
    type: number
    description: "Monetary amount of backlog items in the source currency"
    sql: BACKLOG_AMOUNT ;;
  }
  dimension: backlog_quantity {
    type: number
    description: "Difference between ordered quantity and fulfilled quantity for lines in backlog"
    sql: BACKLOG_QUANTITY ;;
  }
  dimension: booking_amount {
    type: number
    description: "Monetary amount of booking items in the source currency"
    sql: BOOKING_AMOUNT ;;
  }
  dimension: booking_quantity {
    type: number
    description: "Ordered quantity for lines that are in booking"
    sql: BOOKING_QUANTITY ;;
  }
  dimension: cancel_reason {
    hidden: yes
    sql: CANCEL_REASON ;;
  }
  dimension: cancelled_quantity {
    type: number
    description: "Cancelled quantity"
    sql: CANCELLED_QUANTITY ;;
  }
  dimension_group: creation_ts {
    type: time
    description: "Timestamp when the line record was created in the source system"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CREATION_TS ;;
  }
  dimension: cycle_time_days {
    type: number
    description: "Number of days between order to fulfillment date"
    sql: CYCLE_TIME_DAYS ;;
  }
  dimension: fulfilled_amount {
    type: number
    description: "Monetary amount of fulfilled items in the source currency"
    sql: FULFILLED_AMOUNT ;;
  }
  dimension: fulfilled_quantity {
    type: number
    description: "Fulfilled quantity"
    sql: FULFILLED_QUANTITY ;;
  }
  dimension_group: fulfillment {
    type: time
    description: "Date the line was fulfilled"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: FULFILLMENT_DATE ;;
  }
  dimension: fulfillment_days_after_promise_date {
    type: number
    description: "The number of days after the promised date that the items were fulfilled"
    sql: FULFILLMENT_DAYS_AFTER_PROMISE_DATE ;;
  }
  dimension: fulfillment_days_after_request_date {
    type: number
    description: "The number of days after the request date that the items were fulfilled"
    sql: FULFILLMENT_DAYS_AFTER_REQUEST_DATE ;;
  }
  dimension: has_return {
    type: yesno
    description: "Indicates whether the line is referenced by any return order lines"
    sql: HAS_RETURN ;;
  }
  dimension: inventory_item_id {
    type: number
    description: "Foreign key identifying the item"
    sql: INVENTORY_ITEM_ID ;;
  }
  dimension: invoiced_amount {
    type: number
    description: "Monetary amount of invoiced items in the source currency"
    sql: INVOICED_AMOUNT ;;
  }
  dimension: invoiced_quantity {
    type: number
    description: "Invoiced quantity"
    sql: INVOICED_QUANTITY ;;
  }
  dimension: is_backlog {
    type: yesno
    description: "Indicates whether line is in backlog if it is not in ENTERED, BOOKED, CLOSED, OR CANCELLED statuses"
    sql: IS_BACKLOG ;;
  }
  dimension: is_backordered {
    type: yesno
    description: "Indicates line cannot be fulfilled with the current inventory."
    sql: IS_BACKORDERED ;;
  }
  dimension: is_booked {
    type: yesno
    description: "Indicates whether the line is in or past the booked phase."
    sql: IS_BOOKED ;;
  }
  dimension: is_booking {
    type: yesno
    description: "Indicates if line is in ENTERED or BOOKED statuses. Unlike IS_BOOKED, this will be FALSE once it passes the booking phase."
    sql: IS_BOOKING ;;
  }
  dimension: is_cancelled {
    type: yesno
    description: "Indicates whether the line is completely cancelled"
    sql: IS_CANCELLED ;;
  }
  dimension: is_fulfilled {
    type: yesno
    description: "Indicates whether the line is fulfilled"
    sql: IS_FULFILLED ;;
  }
  dimension: is_fulfilled_by_promise_date {
    type: yesno
    description: "Indicates if line was fulfilled before the promise date"
    sql: IS_FULFILLED_BY_PROMISE_DATE ;;
  }
  dimension: is_fulfilled_by_request_date {
    type: yesno
    description: "Indicates if line was fulfilled before the request date"
    sql: IS_FULFILLED_BY_REQUEST_DATE ;;
  }
  dimension: is_open {
    type: yesno
    description: "Indicates whether the line is open"
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
  dimension: line_category_code {
    type: string
    description: "Order line category code including ORDER or RETURN indicating if it was a return merchandise authorization (RMA) line"
    sql: LINE_CATEGORY_CODE ;;
  }
  dimension: line_id {
    type: number
    description: "Nested primary key identifying the order line"
    sql: LINE_ID ;;
  }
  dimension: line_number {
    type: number
    description: "Order line number"
    sql: LINE_NUMBER ;;
  }
  dimension: line_status {
    type: string
    description: "Workflow status for the line"
    sql: LINE_STATUS ;;
  }
  dimension: ordered_amount {
    type: number
    description: "Monetary amount of ordered items in the source currency"
    sql: ORDERED_AMOUNT ;;
  }
  dimension: ordered_quantity {
    type: number
    description: "Ordered quantity"
    sql: ORDERED_QUANTITY ;;
  }
  dimension: ordered_weight {
    type: number
    description: "The total weight of ordered items"
    sql: ORDERED_WEIGHT ;;
  }
  dimension_group: promise_date {
    type: time
    description: "Date the line was promised"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: PROMISE_DATE ;;
  }
  dimension: quantity_uom {
    type: string
    description: "Ordered quantity unit of measure"
    sql: QUANTITY_UOM ;;
  }
  dimension_group: request_date {
    type: time
    description: "Date the line was requested"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: REQUEST_DATE ;;
  }
  dimension: sales_orders__lines {
    type: string
    description: "Nested repeated field containing all line level details"
    hidden: yes
    sql: sales_orders__lines ;;
  }
  dimension_group: schedule_ship {
    type: time
    description: "Date scheduled to ship the line"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: SCHEDULE_SHIP_DATE ;;
  }
  dimension: shipped_amount {
    type: number
    description: "Monetary amount of shipped items in the source currency"
    sql: SHIPPED_AMOUNT ;;
  }
  dimension: shipped_quantity {
    type: number
    description: "Shipped quantity"
    sql: SHIPPED_QUANTITY ;;
  }
  dimension: shipped_weight {
    type: number
    description: "The total weight of shipped items"
    sql: SHIPPED_WEIGHT ;;
  }
  dimension: unit_cost {
    type: number
    description: "Unit Cost for the gross margin analysis"
    sql: UNIT_COST ;;
  }
  dimension: unit_list_price {
    type: number
    description: "List price for the item"
    sql: UNIT_LIST_PRICE ;;
  }
  dimension: unit_selling_price {
    type: number
    description: "Actual price charged to customer"
    sql: UNIT_SELLING_PRICE ;;
  }
  dimension: unit_weight {
    type: number
    description: "Conversion between weight unit of measure and base unit of measure"
    sql: UNIT_WEIGHT ;;
  }
  dimension: weight_uom {
    type: string
    description: "Weight unit of measure code"
    sql: WEIGHT_UOM ;;
  }
}
