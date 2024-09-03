view: sales_orders {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesOrders` ;;

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
  dimension_group: booked {
    type: time
    description: "Date the order was booked"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.BOOKED_DATE ;;
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
    description: "Code indicating the type of currency that the order was placed in"
    sql: ${TABLE}.CURRENCY_CODE ;;
  }
  dimension: fiscal_period_name {
    type: string
    description: "Accounting period name"
    sql: ${TABLE}.FISCAL_PERIOD_NAME ;;
  }
  dimension: fiscal_period_num {
    type: number
    description: "Accounting period based on the ordered date"
    sql: ${TABLE}.FISCAL_PERIOD_NUM ;;
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
  dimension: fiscal_quarter_num {
    type: number
    description: "Accounting quarter based on the ordered date"
    sql: ${TABLE}.FISCAL_QUARTER_NUM ;;
  }
  dimension: fiscal_year_num {
    type: number
    description: "Accounting year based on the ordered date"
    sql: ${TABLE}.FISCAL_YEAR_NUM ;;
  }
  dimension_group: fulfillment {
    type: time
    description: "Date when all lines were fulfilled"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.FULFILLMENT_DATE ;;
  }
  dimension: has_backorder {
    type: yesno
    description: "Indicates if there is not enough available inventory to fill any of the order lines immediately"
    sql: ${TABLE}.HAS_BACKORDER ;;
  }
  dimension: has_cancelled {
    type: yesno
    description: "Indicates if at least one order line was cancelled, use IS_CANCELLED to check if the entire order is cancelled."
    sql: ${TABLE}.HAS_CANCELLED ;;
  }
  dimension: has_hold {
    type: yesno
    description: "Indicates if the order was held at some point in the process, use IS_HELD to check if it is currently on hold"
    sql: ${TABLE}.HAS_HOLD ;;
  }
  dimension: has_return_line {
    type: yesno
    description: "Indicates if at least one of the order lines was returned"
    sql: ${TABLE}.HAS_RETURN_LINE ;;
  }
  dimension: header_id {
    type: number
    description: "Primary key identifying the order header"
    sql: ${TABLE}.HEADER_ID ;;
  }
  dimension: header_status {
    type: string
    description: "Workflow status for the header"
    sql: ${TABLE}.HEADER_STATUS ;;
  }
  dimension: is_booked {
    type: yesno
    description: "Indicates whether the header is in or past the booked phase"
    sql: ${TABLE}.IS_BOOKED ;;
  }
  dimension: is_cancelled {
    type: yesno
    description: "Indicates whether the order is cancelled"
    sql: ${TABLE}.IS_CANCELLED ;;
  }
  dimension: is_fulfilled {
    type: yesno
    description: "Indicates if all order lines are fulfilled"
    sql: ${TABLE}.IS_FULFILLED ;;
  }
  dimension: is_held {
    type: yesno
    description: "Indicates whether the order is currently on hold"
    sql: ${TABLE}.IS_HELD ;;
  }
  dimension: is_intercompany {
    type: yesno
    description: "Indicates whether the order was between entities within the same parent company"
    sql: ${TABLE}.IS_INTERCOMPANY ;;
  }
  dimension: is_open {
    type: yesno
    description: "Indicates whether the order is open"
    sql: ${TABLE}.IS_OPEN ;;
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
  dimension: num_lines {
    type: number
    description: "Number of lines in this order"
    sql: ${TABLE}.NUM_LINES ;;
  }
  dimension: num_lines_fulfilled_by_promise_date {
    type: number
    description: "Number of lines that are fulfilled before the line promise date."
    sql: ${TABLE}.NUM_LINES_FULFILLED_BY_PROMISE_DATE ;;
  }
  dimension: num_lines_fulfilled_by_request_date {
    type: number
    description: "Number of lines that are fulfilled before the line request date."
    sql: ${TABLE}.NUM_LINES_FULFILLED_BY_REQUEST_DATE ;;
  }
  dimension: order_category_code {
    type: string
    description: "Order category code including ORDER or RETURN indicating if it was a return merchandise authorization (RMA)"
    sql: ${TABLE}.ORDER_CATEGORY_CODE ;;
  }
  dimension: order_number {
    type: number
    description: "Order number"
    sql: ${TABLE}.ORDER_NUMBER ;;
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
  dimension_group: ordered {
    type: time
    description: "Date the order was placed"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ORDERED_DATE ;;
  }
  dimension: ordered_month_num {
    type: number
    description: "Month the order was placed"
    sql: ${TABLE}.ORDERED_MONTH_NUM ;;
  }
  dimension: ordered_quarter_num {
    type: number
    description: "Quarter the order was placed"
    sql: ${TABLE}.ORDERED_QUARTER_NUM ;;
  }
  dimension: ordered_year_num {
    type: number
    description: "Year the order was placed"
    sql: ${TABLE}.ORDERED_YEAR_NUM ;;
  }
  dimension_group: request_date {
    type: time
    description: "Date the order was requested"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.REQUEST_DATE ;;
  }
  dimension: sales_rep {
    type: string
    description: "Sales representative name"
    sql: ${TABLE}.SALES_REP ;;
  }
  dimension: ship_to_customer_country {
    type: string
    description: "Shipped customer country name"
    sql: ${TABLE}.SHIP_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: ship_to_customer_name {
    type: string
    description: "Shipped customer account name"
    sql: ${TABLE}.SHIP_TO_CUSTOMER_NAME ;;
  }
  dimension: ship_to_customer_number {
    type: string
    description: "Shipped customer account number"
    sql: ${TABLE}.SHIP_TO_CUSTOMER_NUMBER ;;
  }
  dimension: ship_to_site_use_id {
    type: number
    description: "Foreign key identifying the Site Use entity that was shipped to"
    sql: ${TABLE}.SHIP_TO_SITE_USE_ID ;;
  }
  dimension: sold_to_customer_country {
    type: string
    description: "Sold customer country name"
    sql: ${TABLE}.SOLD_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: sold_to_customer_name {
    type: string
    description: "Sold customer account name"
    sql: ${TABLE}.SOLD_TO_CUSTOMER_NAME ;;
  }
  dimension: sold_to_customer_number {
    type: string
    description: "Sold customer account number"
    sql: ${TABLE}.SOLD_TO_CUSTOMER_NUMBER ;;
  }
  dimension: sold_to_site_use_id {
    type: number
    description: "Foreign key identifying the Site Use entity that was sold to"
    sql: ${TABLE}.SOLD_TO_SITE_USE_ID ;;
  }
  dimension: total_ordered_amount {
    type: number
    description: "Sum of ordered amounts for all order lines"
    sql: ${TABLE}.TOTAL_ORDERED_AMOUNT ;;
  }
  dimension: total_sales_ordered_amount {
    type: number
    description: "Sum of ordered amounts for all order lines excluding RETURN lines"
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
#     description: "Actual shipment date of the line"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: ACTUAL_SHIP_DATE ;;
#   }
#   dimension: backlog_amount {
#     type: number
#     description: "Monetary amount of backlog items in the source currency"
#     sql: BACKLOG_AMOUNT ;;
#   }
#   dimension: backlog_quantity {
#     type: number
#     description: "Difference between ordered quantity and fulfilled quantity for lines in backlog"
#     sql: BACKLOG_QUANTITY ;;
#   }
#   dimension: booking_amount {
#     type: number
#     description: "Monetary amount of booking items in the source currency"
#     sql: BOOKING_AMOUNT ;;
#   }
#   dimension: booking_quantity {
#     type: number
#     description: "Ordered quantity for lines that are in booking"
#     sql: BOOKING_QUANTITY ;;
#   }
#   dimension: cancel_reason {
#     hidden: yes
#     sql: CANCEL_REASON ;;
#   }
#   dimension: cancelled_quantity {
#     type: number
#     description: "Cancelled quantity"
#     sql: CANCELLED_QUANTITY ;;
#   }
#   dimension_group: creation_ts {
#     type: time
#     description: "Timestamp when the line record was created in the source system"
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: CREATION_TS ;;
#   }
#   dimension: cycle_time_days {
#     type: number
#     description: "Number of days between order to fulfillment date"
#     sql: CYCLE_TIME_DAYS ;;
#   }
#   dimension: fulfilled_amount {
#     type: number
#     description: "Monetary amount of fulfilled items in the source currency"
#     sql: FULFILLED_AMOUNT ;;
#   }
#   dimension: fulfilled_quantity {
#     type: number
#     description: "Fulfilled quantity"
#     sql: FULFILLED_QUANTITY ;;
#   }
#   dimension_group: fulfillment {
#     type: time
#     description: "Date the line was fulfilled"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: FULFILLMENT_DATE ;;
#   }
#   dimension: fulfillment_days_after_promise_date {
#     type: number
#     description: "The number of days after the promised date that the items were fulfilled"
#     sql: FULFILLMENT_DAYS_AFTER_PROMISE_DATE ;;
#   }
#   dimension: fulfillment_days_after_request_date {
#     type: number
#     description: "The number of days after the request date that the items were fulfilled"
#     sql: FULFILLMENT_DAYS_AFTER_REQUEST_DATE ;;
#   }
#   dimension: has_return {
#     type: yesno
#     description: "Indicates whether the line is referenced by any return order lines"
#     sql: HAS_RETURN ;;
#   }
#   dimension: inventory_item_id {
#     type: number
#     description: "Foreign key identifying the item"
#     sql: INVENTORY_ITEM_ID ;;
#   }
#   dimension: invoiced_amount {
#     type: number
#     description: "Monetary amount of invoiced items in the source currency"
#     sql: INVOICED_AMOUNT ;;
#   }
#   dimension: invoiced_quantity {
#     type: number
#     description: "Invoiced quantity"
#     sql: INVOICED_QUANTITY ;;
#   }
#   dimension: is_backlog {
#     type: yesno
#     description: "Indicates whether line is in backlog if it is not in ENTERED, BOOKED, CLOSED, OR CANCELLED statuses"
#     sql: IS_BACKLOG ;;
#   }
#   dimension: is_backordered {
#     type: yesno
#     description: "Indicates line cannot be fulfilled with the current inventory."
#     sql: IS_BACKORDERED ;;
#   }
#   dimension: is_booked {
#     type: yesno
#     description: "Indicates whether the line is in or past the booked phase."
#     sql: IS_BOOKED ;;
#   }
#   dimension: is_booking {
#     type: yesno
#     description: "Indicates if line is in ENTERED or BOOKED statuses. Unlike IS_BOOKED, this will be FALSE once it passes the booking phase."
#     sql: IS_BOOKING ;;
#   }
#   dimension: is_cancelled {
#     type: yesno
#     description: "Indicates whether the line is completely cancelled"
#     sql: IS_CANCELLED ;;
#   }
#   dimension: is_fulfilled {
#     type: yesno
#     description: "Indicates whether the line is fulfilled"
#     sql: IS_FULFILLED ;;
#   }
#   dimension: is_fulfilled_by_promise_date {
#     type: yesno
#     description: "Indicates if line was fulfilled before the promise date"
#     sql: IS_FULFILLED_BY_PROMISE_DATE ;;
#   }
#   dimension: is_fulfilled_by_request_date {
#     type: yesno
#     description: "Indicates if line was fulfilled before the request date"
#     sql: IS_FULFILLED_BY_REQUEST_DATE ;;
#   }
#   dimension: is_open {
#     type: yesno
#     description: "Indicates whether the line is open"
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
#   dimension: line_category_code {
#     type: string
#     description: "Order line category code including ORDER or RETURN indicating if it was a return merchandise authorization (RMA) line"
#     sql: LINE_CATEGORY_CODE ;;
#   }
#   dimension: line_id {
#     type: number
#     description: "Nested primary key identifying the order line"
#     sql: LINE_ID ;;
#   }
#   dimension: line_number {
#     type: number
#     description: "Order line number"
#     sql: LINE_NUMBER ;;
#   }
#   dimension: line_status {
#     type: string
#     description: "Workflow status for the line"
#     sql: LINE_STATUS ;;
#   }
#   dimension: ordered_amount {
#     type: number
#     description: "Monetary amount of ordered items in the source currency"
#     sql: ORDERED_AMOUNT ;;
#   }
#   dimension: ordered_quantity {
#     type: number
#     description: "Ordered quantity"
#     sql: ORDERED_QUANTITY ;;
#   }
#   dimension: ordered_weight {
#     type: number
#     description: "The total weight of ordered items"
#     sql: ORDERED_WEIGHT ;;
#   }
#   dimension_group: promise_date {
#     type: time
#     description: "Date the line was promised"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: PROMISE_DATE ;;
#   }
#   dimension: quantity_uom {
#     type: string
#     description: "Ordered quantity unit of measure"
#     sql: QUANTITY_UOM ;;
#   }
#   dimension_group: request_date {
#     type: time
#     description: "Date the line was requested"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: REQUEST_DATE ;;
#   }
#   dimension: sales_orders__lines {
#     type: string
#     description: "Nested repeated field containing all line level details"
#     hidden: yes
#     sql: sales_orders__lines ;;
#   }
#   dimension_group: schedule_ship {
#     type: time
#     description: "Date scheduled to ship the line"
#     timeframes: [raw, date, week, month, quarter, year]
#     convert_tz: no
#     datatype: date
#     sql: SCHEDULE_SHIP_DATE ;;
#   }
#   dimension: shipped_amount {
#     type: number
#     description: "Monetary amount of shipped items in the source currency"
#     sql: SHIPPED_AMOUNT ;;
#   }
#   dimension: shipped_quantity {
#     type: number
#     description: "Shipped quantity"
#     sql: SHIPPED_QUANTITY ;;
#   }
#   dimension: shipped_weight {
#     type: number
#     description: "The total weight of shipped items"
#     sql: SHIPPED_WEIGHT ;;
#   }
#   dimension: unit_cost {
#     type: number
#     description: "Unit Cost for the gross margin analysis"
#     sql: UNIT_COST ;;
#   }
#   dimension: unit_list_price {
#     type: number
#     description: "List price for the item"
#     sql: UNIT_LIST_PRICE ;;
#   }
#   dimension: unit_selling_price {
#     type: number
#     description: "Actual price charged to customer"
#     sql: UNIT_SELLING_PRICE ;;
#   }
#   dimension: unit_weight {
#     type: number
#     description: "Conversion between weight unit of measure and base unit of measure"
#     sql: UNIT_WEIGHT ;;
#   }
#   dimension: weight_uom {
#     type: string
#     description: "Weight unit of measure code"
#     sql: WEIGHT_UOM ;;
#   }
# }

# view: sales_orders__lines__return_line_ids {

#   dimension: sales_orders__lines__return_line_ids {
#     type: number
#     description: "Array of IDs of all return lines that reference this order line"
#     value_format_name: id
#     sql: sales_orders__lines__return_line_ids ;;
#   }
# }

# view: sales_orders__lines__cancel_reason {

#   dimension: code {
#     type: string
#     description: "Cancel reason code"
#     sql: ${TABLE}.CODE ;;
#   }
#   dimension: language {
#     type: string
#     description: "Language code of the cancel reason"
#     sql: ${TABLE}.LANGUAGE ;;
#   }
#   dimension: meaning {
#     type: string
#     description: "Explanation of the cancel reason code"
#     sql: ${TABLE}.MEANING ;;
#   }
# }

# view: sales_orders__lines__item_categories {
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

# view: sales_orders__lines__item_descriptions {

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
