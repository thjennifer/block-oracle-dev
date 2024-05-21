include: "/views/base/sales_orders.view"
include: "/views/core/common_dimensions.view"
view: +sales_orders {
  extends: [common_dimensions]

  fields_hidden_by_default: yes

  dimension: header_id {
    hidden: no
    primary_key: yes
  }

  dimension: order_number {
    hidden: no
    value_format_name: id
  }

  dimension_group: ordered {
    hidden: no
  }

  dimension: header_status {
    hidden: no
    group_label: "Order Status"

  }

  dimension: currency_code {
    hidden: no
    label: "Currency (Order)"
    description: "Order Currency"
  }

  dimension: is_backordered {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_booked {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_cancelled {
    hidden: no
    group_label: "Order Status"
    description: "Entire order is cancelled."
  }

  dimension: has_cancelled {
    hidden: no
    group_label: "Order Status"
    description: "At least one order line was cancelled. Use IS_CANCELLED to check if the entire order is cancelled."
  }

  dimension: is_fulfilled {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_held {
    hidden: no
    group_label: "Order Status"
    description: "Order is Currently Held"
  }

  dimension: has_hold {
    hidden: no
    group_label: "Order Status"
    label: "Has Been On Hold"
    description: "Order has been held at some point in process flow. Use Is Held to identify if order is currently on hold."
  }

  dimension: is_intercompany {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_open {
    hidden: no
    group_label: "Order Status"
  }

  dimension: has_return {
    hidden: no
    group_label: "Order Status"
    description: "Sales order has at least 1 line with a return."
  }

#Not defined in data model yet
  # dimension: has_return_line {
  #   hidden: no
  #   view_label: "Return Status"
  #   description: "Sales order has had at least one of the order lines returned"
  # }

  measure: count {
    hidden: no
    label: "Order Count"
  }

  measure: total_amount {
    hidden: no
    type: sum
    view_label: "TEST STUFF"
    sql: ${total_order_amount} ;;
  }


   }
