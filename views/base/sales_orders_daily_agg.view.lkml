#########################################################{
# CREATED USING CREATE VIEW FROM TABLE
# Includes SalesOrderDailyAgg and Nested Repeated Structs for Lines and Lines Amounts
#
# Note, commented out ordered_month, ordered_quarter and ordered_year and using "dimension group: ordered" to derive these as date types
#########################################################}

view: sales_orders_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesOrdersDailyAgg` ;;

  # sql_table_name:  `thjennifer1.CORTEX_ORACLE_REPORTING.SalesOrdersDailyAgg` ;;
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
  dimension: lines {
    hidden: yes
    sql: ${TABLE}.LINES ;;
  }
  dimension: num_blocked_orders {
    type: number
    sql: ${TABLE}.NUM_BLOCKED_ORDERS ;;
  }
  dimension: num_cancelled_orders {
    type: number
    sql: ${TABLE}.NUM_CANCELLED_ORDERS ;;
  }
  dimension: num_fillable_orders {
    type: number
    sql: ${TABLE}.NUM_FILLABLE_ORDERS ;;
  }
  dimension: num_fulfilled_orders {
    type: number
    sql: ${TABLE}.NUM_FULFILLED_ORDERS ;;
  }
  dimension: num_open_orders {
    type: number
    sql: ${TABLE}.NUM_OPEN_ORDERS ;;
  }
  dimension: num_orders {
    type: number
    sql: ${TABLE}.NUM_ORDERS ;;
  }
  dimension: num_orders_fulfilled_by_promise_date {
    type: number
    sql: ${TABLE}.NUM_ORDERS_FULFILLED_BY_PROMISE_DATE ;;
  }
  dimension: num_orders_fulfilled_by_request_date {
    type: number
    sql: ${TABLE}.NUM_ORDERS_FULFILLED_BY_REQUEST_DATE ;;
  }
  dimension: num_orders_with_no_holds {
    type: number
    sql: ${TABLE}.NUM_ORDERS_WITH_NO_HOLDS ;;
  }
  dimension: num_orders_with_returns {
    type: number
    sql: ${TABLE}.NUM_ORDERS_WITH_RETURNS ;;
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
  # dimension: ordered_month {
  #   type: number
  #   sql: ${TABLE}.ORDERED_MONTH ;;
  # }
  # dimension: ordered_quarter {
  #   type: number
  #   sql: ${TABLE}.ORDERED_QUARTER ;;
  # }
  # dimension: ordered_year {
  #   type: number
  #   sql: ${TABLE}.ORDERED_YEAR ;;
  # }
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
  measure: count {
    type: count
    drill_fields: [ship_to_customer_name, sold_to_customer_name, business_unit_name, bill_to_customer_name, order_source_name]
  }
}

view: sales_orders_daily_agg__lines {

  dimension: amounts {
    hidden: yes
    sql: AMOUNTS ;;
  }
  dimension: item_category_name {
    type: string
    sql: ITEM_CATEGORY_NAME ;;
  }
  dimension: item_category_set_id {
    type: number
    sql: ITEM_CATEGORY_SET_ID ;;
  }
  dimension: item_category_set_name {
    type: string
    sql: ITEM_CATEGORY_SET_NAME ;;
  }
  dimension: item_organization_name {
    type: string
    sql: ITEM_ORGANIZATION_NAME ;;
  }
  dimension: num_order_lines {
    type: number
    sql: NUM_ORDER_LINES ;;
  }
  dimension: sales_orders_daily_agg__lines {
    type: string
    hidden: yes
    sql: sales_orders_daily_agg__lines ;;
  }
  dimension: total_cycle_time_days {
    type: number
    sql: TOTAL_CYCLE_TIME_DAYS ;;
  }
}

view: sales_orders_daily_agg__lines__amounts {

  dimension: currency_code {
    type: string
    sql: ${TABLE}.CURRENCY_CODE ;;
  }
  dimension: total_invoiced {
    type: number
    sql: ${TABLE}.TOTAL_INVOICED ;;
  }
  dimension: total_ordered {
    type: number
    sql: ${TABLE}.TOTAL_ORDERED ;;
  }
}
