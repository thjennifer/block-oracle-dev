#########################################################{
# PURPOSE
# The SalesOrderDailyAgg table and its corresponding View sales_order_daily_agg reflect
# an aggregation of orders by the following dimensions:
#   Ordered Date
#   Business Unit ID
#   Order Source ID
#   Sold To Site ID
#   Ship To Site ID
#   Bill To Site ID
#
# SOURCES
# Refines View sales_order_daily_agg (defined in file balance_sheet_base.view)
#
# REFERENCED BY
# Explore sales_order_daily_agg
#
# KEY MEASURES
#
# CAVEATS

# HOW TO USE
# Fields are hidden by default so to expose a field in Explore set hidden property to no
#########################################################}

include: "/views/base/sales_orders_daily_agg.view"
include: "/views/core/common_dimensions.view"

view: +sales_orders_daily_agg {

  fields_hidden_by_default: yes
  extends: [common_dimensions]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${ordered_date_key},${business_unit_id},${order_source_id},${sold_to_site_use_id},${bill_to_site_use_id},${ship_to_site_use_id}) ;;
  }

  dimension: ordered_date_key {
    type: date
    hidden: yes
    sql: ${TABLE}.ORDERED_DATE) ;;
    convert_tz: no
  }

  dimension_group: ordered { hidden: no}




  measure: count {
    hidden:no
    label: "Count Rows"}

  measure: count_blocked_orders {
    hidden: no
    type: sum
    sql: ${num_blocked_orders} ;;
  }
  measure: count_cancelled_orders {
    hidden: no
    type: sum
    sql: ${num_cancelled_orders} ;;
  }
  measure: count_fillable_orders {
    hidden: no
    type: sum
    sql: ${num_fillable_orders} ;;
  }
  measure: count_fulfilled_orders {
    hidden: no
    type: sum
    sql: ${num_fulfilled_orders} ;;
  }
  measure: count_open_orders {
    hidden: no
    type: sum
    sql: ${num_open_orders} ;;
  }
  measure: count_orders {
    hidden: no
    type: sum
    sql: ${num_orders} ;;
  }
  measure: count_orders_fulfilled_by_promise_date {
    hidden: no
    type: sum
    sql: ${num_orders_fulfilled_by_promise_date} ;;
  }
  measure: count_orders_fulfilled_by_request_date {
    hidden: no
    type: sum
    sql: ${num_orders_fulfilled_by_request_date} ;;
  }
  measure: count_orders_with_no_holds {
    hidden: no
    type: sum
    sql: ${num_orders_with_no_holds} ;;
  }
  measure: count_orders_with_returns {
    hidden: no
    type: sum
    sql: ${num_orders_with_returns};;
  }

####### TEST STUFF
  dimension: is_diff_ship_to_and_bill_to {
    hidden: no
    type: yesno
    view_label: "Test Stuff"
    sql: ${ship_to_customer_number}<>${bill_to_customer_number} ;;
  }

 }
