#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions for measures
# used in both sales_orders and sales_orders_daily_agg
#
# To use extend into desired view.
#
# Defines label/descriptions for:
#   order_count
#   blocked_order_count
#   cancelled_order_count
#   fillable_order_count
#   fulfilled_order_count
#   fulfilled_by_request_date_order_count
#   fulfilled_by_promise_date_order_count
#   has_return_order_count
#   no_holds_order_count
#   non_cancelled_order_count
#   open_order_count
#
# Fully defines these measures including sql: property:
#   cancelled_order_percent
#   fulfilled_order_percent
#   fulfilled_by_request_date_order_percent
#   has_return_order_percent
#   no_holds_order_percent
#########################################################}

view: sales_orders_common_measures_ext {
  extension: required

  measure: order_count {
    label: "Sales Orders"
  }

  measure: blocked_order_count {
    label: "Blocked Orders"
    description: "Number of sales orders that are blocked (backordered or held)."
  }

  measure: cancelled_order_count {
    label: "Cancelled Orders"
    description: "Number of sales orders completely cancelled (all lines cancelled)."
  }

  measure: cancelled_order_percent {
    hidden: no
    type: number
    label: "Cancelled Percent"
    description: "The percentage of sales orders that have been cancelled (all lines cancelled)."
    sql: SAFE_DIVIDE(${cancelled_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: fillable_order_count {
    label: "Fillable Orders"
    description: "Number of sales orders that can be met with the available inventory (none of items are backordered)."
  }

  measure: fulfilled_order_count {
    label: "In-Full Orders"
    description: "Number of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
  }

  measure: fulfilled_order_percent {
    hidden: no
    type: number
    label: "In-Full Percent"
    description: "The percentage of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
    sql: SAFE_DIVIDE(${fulfilled_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: fulfilled_by_request_date_order_count {
    label: "On-Time & In-Full Orders"
    description: "Number of sales orders that are fulfilled on-time (all lines fulfilled by requested delivery date)."
  }

  measure: fulfilled_by_request_date_order_percent {
    hidden: no
    type: number
    label: "On-Time & In-Full Percent"
    description: "The percentage of sales orders that are on-time (all lines fulfilled by requested delivery date)."
    sql: SAFE_DIVIDE(${fulfilled_by_request_date_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: fulfilled_by_promise_date_order_count {
    label: "Fulfilled by Promise Date Order Count"
    description: "Number of sales orders that are fulfilled on-time (all lines fulfilled by promised delivery date)."
  }

  measure: has_return_order_count {
    label: "Has Return Orders"
    description: "Number of sales orders with at least one item returned (regardless of when returned)."
  }

  measure: has_return_order_percent {
    hidden: no
    type: number
    description: "The percentage of sales orders with at least one item returned."
    sql: SAFE_DIVIDE(${has_return_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: no_holds_order_count {
    label: "One Touch Orders"
    description: "Count of sales orders without any holds."
  }

  measure: no_holds_order_percent {
    hidden: no
    type: number
    label: "One Touch Percent"
    description: "The percentage of sales orders that never had a hold during processing."
    sql: SAFE_DIVIDE(${no_holds_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: non_cancelled_order_count {
    label: "Non-Cancelled Orders"
    description: "Number of sales orders completely cancelled (all lines cancelled)."
  }

  measure: open_order_count {
    label: "Open Orders"
    description: "Number of sales orders that are open."
  }




   }
