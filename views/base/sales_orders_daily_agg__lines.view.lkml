view: sales_orders_daily_agg__lines {

  dimension: amounts {
    hidden: yes
    sql: AMOUNTS ;;
  }
  dimension: item_category_description {
    type: string
    description: "Item category description"
    sql: ITEM_CATEGORY_DESCRIPTION ;;
  }
  dimension: item_category_id {
    type: number
    description: "Foreign key identifying item categories"
    sql: ITEM_CATEGORY_ID ;;
  }
  dimension: item_category_name {
    type: string
    description: "Item category name"
    sql: ITEM_CATEGORY_NAME ;;
  }
  dimension: item_category_set_id {
    type: number
    description: "Foreign key identifying item category sets"
    sql: ITEM_CATEGORY_SET_ID ;;
  }
  dimension: item_category_set_name {
    type: string
    description: "Item category set name"
    sql: ITEM_CATEGORY_SET_NAME ;;
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
  dimension: line_category_code {
    type: string
    description: "Order line category code including ORDER or RETURN indicating if it was a return merchandise authorization (RMA) line"
    sql: LINE_CATEGORY_CODE ;;
  }
  dimension: num_fulfilled_order_lines {
    type: number
    description: "Total number of fulfilled orders lines across orders"
    sql: NUM_FULFILLED_ORDER_LINES ;;
  }
  dimension: num_order_lines {
    type: number
    description: "Total number of orders lines across orders"
    sql: NUM_ORDER_LINES ;;
  }
  dimension: sales_orders_daily_agg__lines {
    type: string
    description: "Nested repeated field containing measures also aggregated by line level attributes. These measures exclude cancelled lines."
    hidden: yes
    sql: sales_orders_daily_agg__lines ;;
  }
  dimension: total_cycle_time_days {
    type: number
    description: "Sum of number of days between ORDER_DATE and FULLFILLED_DATE across orders. This can be used with NUM_ORDERS to calculate the average cycle time."
    sql: TOTAL_CYCLE_TIME_DAYS ;;
  }
}
