view: sales_orders_daily_agg__lines {

  dimension: amounts {
    hidden: yes
    sql: AMOUNTS ;;
  }
  dimension: item_category_description {
    type: string
    sql: ITEM_CATEGORY_DESCRIPTION ;;
  }
  dimension: item_category_id {
    type: number
    sql: ITEM_CATEGORY_ID ;;
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
  dimension: item_organization_id {
    type: number
    sql: ITEM_ORGANIZATION_ID ;;
  }
  dimension: item_organization_name {
    type: string
    sql: ITEM_ORGANIZATION_NAME ;;
  }
  dimension: num_fulfilled_order_lines {
    type: number
    sql: NUM_FULFILLED_ORDER_LINES ;;
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
