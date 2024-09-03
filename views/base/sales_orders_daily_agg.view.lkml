view: sales_orders_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesOrdersDailyAgg` ;;

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
dimension: lines {
  hidden: yes
  sql: ${TABLE}.LINES ;;
}
dimension: num_backordered_orders {
  type: number
  description: "Total number of orders that are currently backordered"
  sql: ${TABLE}.NUM_BACKORDERED_ORDERS ;;
}
dimension: num_blocked_orders {
  type: number
  description: "Total number of orders that are held or backordered"
  sql: ${TABLE}.NUM_BLOCKED_ORDERS ;;
}
dimension: num_cancelled_orders {
  type: number
  description: "Total number of orders that were cancelled"
  sql: ${TABLE}.NUM_CANCELLED_ORDERS ;;
}
dimension: num_fillable_orders {
  type: number
  description: "Total number of orders that can be met immediately with the available inventory, i.e. not backordered. Orders' fillable/backordered status can be considered unknown so backordered + fillable may not equal the total number of orders."
  sql: ${TABLE}.NUM_FILLABLE_ORDERS ;;
}
dimension: num_fulfilled_orders {
  type: number
  description: "Total number of orders that are fulfilled completely for all lines"
  sql: ${TABLE}.NUM_FULFILLED_ORDERS ;;
}
dimension: num_open_orders {
  type: number
  description: "Total number of open orders"
  sql: ${TABLE}.NUM_OPEN_ORDERS ;;
}
dimension: num_orders {
  type: number
  description: "Total number of orders"
  sql: ${TABLE}.NUM_ORDERS ;;
}
dimension: num_orders_fulfilled_by_promise_date {
  type: number
  description: "Total number of orders fulfilled by the promise date"
  sql: ${TABLE}.NUM_ORDERS_FULFILLED_BY_PROMISE_DATE ;;
}
dimension: num_orders_fulfilled_by_request_date {
  type: number
  description: "Total number of orders fulfilled by the request date"
  sql: ${TABLE}.NUM_ORDERS_FULFILLED_BY_REQUEST_DATE ;;
}
dimension: num_orders_with_no_holds {
  type: number
  description: "Total number of orders with no holds at any point in the process"
  sql: ${TABLE}.NUM_ORDERS_WITH_NO_HOLDS ;;
}
dimension: num_orders_with_returns {
  type: number
  description: "Total number of orders where at least one line was returned"
  sql: ${TABLE}.NUM_ORDERS_WITH_RETURNS ;;
}
dimension: order_category_code {
  type: string
  description: "Order category code including ORDER or RETURN indicating if it was a return merchandise authorization (RMA)"
  sql: ${TABLE}.ORDER_CATEGORY_CODE ;;
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
measure: count {
  type: count
  drill_fields: [ship_to_customer_name, sold_to_customer_name, business_unit_name, bill_to_customer_name, order_source_name]
}
}

# view: sales_orders_daily_agg__lines {

#   dimension: amounts {
#     hidden: yes
#     sql: AMOUNTS ;;
#   }
#   dimension: item_category_description {
#     type: string
#     description: "Item category description"
#     sql: ITEM_CATEGORY_DESCRIPTION ;;
#   }
#   dimension: item_category_id {
#     type: number
#     description: "Foreign key identifying item categories"
#     sql: ITEM_CATEGORY_ID ;;
#   }
#   dimension: item_category_name {
#     type: string
#     description: "Item category name"
#     sql: ITEM_CATEGORY_NAME ;;
#   }
#   dimension: item_category_set_id {
#     type: number
#     description: "Foreign key identifying item category sets"
#     sql: ITEM_CATEGORY_SET_ID ;;
#   }
#   dimension: item_category_set_name {
#     type: string
#     description: "Item category set name"
#     sql: ITEM_CATEGORY_SET_NAME ;;
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
#   dimension: line_category_code {
#     type: string
#     description: "Order line category code including ORDER or RETURN indicating if it was a return merchandise authorization (RMA) line"
#     sql: LINE_CATEGORY_CODE ;;
#   }
#   dimension: num_fulfilled_order_lines {
#     type: number
#     description: "Total number of fulfilled orders lines across orders"
#     sql: NUM_FULFILLED_ORDER_LINES ;;
#   }
#   dimension: num_order_lines {
#     type: number
#     description: "Total number of orders lines across orders"
#     sql: NUM_ORDER_LINES ;;
#   }
#   dimension: sales_orders_daily_agg__lines {
#     type: string
#     description: "Nested repeated field containing measures also aggregated by line level attributes. These measures exclude cancelled lines."
#     hidden: yes
#     sql: sales_orders_daily_agg__lines ;;
#   }
#   dimension: total_cycle_time_days {
#     type: number
#     description: "Sum of number of days between ORDER_DATE and FULLFILLED_DATE across orders. This can be used with NUM_ORDERS to calculate the average cycle time."
#     sql: TOTAL_CYCLE_TIME_DAYS ;;
#   }
# }

# view: sales_orders_daily_agg__lines__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     description: "Indicates whether some of the source currency amounts could not be converted to the target currency because of missing conversion rates from CurrencyRateMD"
#     sql: ${TABLE}.IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     description: "Code indicating the target converted currency type"
#     sql: ${TABLE}.TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_backlog {
#     type: number
#     description: "Sum of backlog amounts across orders and lines"
#     sql: ${TABLE}.TOTAL_BACKLOG ;;
#   }
#   dimension: total_booking {
#     type: number
#     description: "Sum of booking amounts across orders and lines"
#     sql: ${TABLE}.TOTAL_BOOKING ;;
#   }
#   dimension: total_fulfilled {
#     type: number
#     description: "Sum of fulfilled amounts across orders and lines"
#     sql: ${TABLE}.TOTAL_FULFILLED ;;
#   }
#   dimension: total_invoiced {
#     type: number
#     description: "Sum of invoiced amounts across orders and lines"
#     sql: ${TABLE}.TOTAL_INVOICED ;;
#   }
#   dimension: total_ordered {
#     type: number
#     description: "Sum of ordered amounts across orders and lines"
#     sql: ${TABLE}.TOTAL_ORDERED ;;
#   }
#   dimension: total_shipped {
#     type: number
#     description: "Sum of shipped amounts across orders and lines"
#     sql: ${TABLE}.TOTAL_SHIPPED ;;
#   }
# }
