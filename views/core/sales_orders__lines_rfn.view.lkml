## when column is duplicate of another in header (like is_open) then restate sql using ${TABLE}. reference
include: "/views/base/sales_orders.view"

view: +sales_orders__lines {

  fields_hidden_by_default: yes

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${line_id}) ;;
  }

  dimension: return_line_ids {
    primary_key: no
  }

  dimension: line_id {
    hidden: no
  }

  dimension: line_number {
    hidden: no
  }

  dimension: inventory_item_id {
    hidden: no
    value_format_name: id
  }

  dimension: item_part_number {
    hidden: no
    value_format_name: id
  }

#########################################################
# Dates
#{

  dimension_group: fulfillment {
    hidden: no
    sql: ${TABLE}.FULFILLMENT_DATE ;;
  }

  dimension_group: request_date {
    hidden: no
    label: "Request"
    description: "Requested delivery date for the order line."
    timeframes: [raw,date,week,month,quarter,year,yesno]
    sql:${TABLE}.REQUEST_DATE ;;
  }

  dimension_group: promise_date {
    hidden: no
    label: "Promise"
    description: "Promised delivery date."
    timeframes: [raw,date,week,month,quarter,year,yesno]
  }

  dimension_group: actual_ship {
    hidden: no
    description: "Actual ship date of order line."
  }

  dimension_group: schedule_ship {
    hidden: no
    description: "Scheduled ship date of order line."
  }

  dimension_group: creation {
    hidden: yes
    description: "Creation date of order line."
    sql: ${TABLE}.CREATION_DATE ;;
  }

  dimension_group: last_update {
    hidden: yes
    description: "Last update date of order line."
    sql: ${TABLE}.LAST_UPDATE_DATE ;;
  }

#} end dates

#########################################################
# Order Line Status
#{


  dimension: status_code {
    hidden: no
    group_label: "Line Status"
    label: "Line Status"
    full_suggestions: yes
  }

#????? only 1 value of 'ORDER' -- is this needed
  dimension: category_code {
    hidden: no
    label: "Line Category Code"
  }

  dimension: is_backlog {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is not in ENTERED, BOOKED, CLOSED, OR CANCELLED statuses."
    full_suggestions: yes
  }

  dimension: is_backordered {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line cannot be fulfilled with the current inventory."
    full_suggestions: yes
    sql: ${TABLE}.IS_BACKORDERED ;;
  }

  dimension: is_booked {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is in or past the BOOKED phase."
    full_suggestions: yes
    sql: ${TABLE}.IS_BOOKED ;;
  }

  dimension: is_booking {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is in ENTERED or BOOKED statuses. Unlike IS_BOOKED, this will be No once it passes the booking phase."
    full_suggestions: yes
  }

  dimension: is_cancelled {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_CANCELLED ;;
  }

  dimension: cancel_reason {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_open {
    hidden: no
    type: yesno
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_OPEN ;;
  }

  dimension: has_return {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.HAS_RETURN ;;
  }

#} end order line status


#########################################################
# Order Line Fulfillment Flags and Days
#{

  dimension: is_fulfilled {
    hidden: no
    type: yesno
    group_label: "Fulfillment Flags"
    full_suggestions: yes
    sql: ${TABLE}.IS_FULFILLED ;;
  }

  dimension: is_fulfilled_by_promise_date {
    hidden: no
    group_label: "Fulfillment Flags"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_promise_date_yes_no_null {
    hidden: no
    type: string
    group_label: "Fulfillment Flags"
    label: "Is Fulfilled by Promise Date (Yes/No/Null)"
    sql: CASE WHEN ${TABLE}.IS_FULFILLED_BY_PROMISE_DATE THEN 'Yes'
              WHEN ${TABLE}.IS_FULFILLED_BY_PROMISE_DATE = FALSE then 'No'
         ELSE NULL END
        ;;
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    group_label: "Fulfillment Flags"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_request_date_yes_no_null {
    hidden: no
    type: string
    group_label: "Fulfillment Flags"
    label: "Is Fulfilled by Request Date (Yes/No/Null)"
    sql: CASE WHEN ${TABLE}.IS_FULFILLED_BY_REQUEST_DATE THEN 'Yes'
              WHEN ${TABLE}.IS_FULFILLED_BY_REQUEST_DATE = FALSE then 'No'
         ELSE NULL END
        ;;
  }

# shown in Explore as measure average_days_from_promise_to_fulfillment
  dimension: fulfillment_days_after_promise_date {
    hidden: yes
    group_label: "Fulfillment Flags"
    label: "Fulfillment Days from Promise Date"
    description: "Number of days between Fulfillment Date and Delivery Promise Date."
  }

# shown in Explore as measure average_days_from_request_to_fulfillment
  dimension: fulfillment_days_after_request_date {
    hidden: yes
    group_label: "Fulfillment Flags"
    label: "Fulfillment Days from Request Date"
    description: "Number of days between Fulfillment Date and Delivery Request Date."
  }

# shown in Explore as measure average_cycle_time_days
  dimension: cycle_time_days {
    hidden: yes
    description: "Number of Days between Ordered Date and Fulfillment Date"
  }

#} end order line fulfillment status


#########################################################
# Item quantities and weights
#{


  dimension: quantity_uom {
    hidden: no
    group_label: "Quantities"
    label: "Quantity UoM"
    description: "Unit of Measure for the Line Quantity"
  }

  dimension: ordered_quantity {
    hidden: no
    group_label: "Quantities"
    # required_fields: [item_part_number]
  }

  dimension: fulfilled_quantity {
    hidden: no
    group_label: "Quantities"
    # required_fields: [item_part_number]
  }

  dimension: shipped_quantity {
    hidden: no
    group_label: "Quantities"
    # required_fields: [item_part_number]
  }

  dimension: invoiced_quantity {
    hidden: no
    group_label: "Quantities"
    # required_fields: [item_part_number]
  }

  dimension: cancelled_quantity {
    hidden: no
    group_label: "Quantities"
    # required_fields: [item_part_number]
  }

  dimension: weight_uom {
    hidden: no
    group_label: "Weights"
    label: "Weight UoM"
    description: "Unit of Measure for the Line Weight"
  }

  dimension: unit_weight {
    hidden: no
    group_label: "Weights"
  }

  dimension: ordered_weight {
    hidden: no
    group_label: "Weights"
    }

  dimension: shipped_weight {
    hidden: no
    group_label: "Weights"
  }

#} end item quantities and weights

#########################################################
# Item ordered/shipped amounts, prices and cost
#{

  dimension: ordered_amount {
    hidden: no
  }
  dimension: shipped_amount {
    hidden: no
  }
  dimension: unit_cost {
    hidden: no
  }
  dimension: unit_list_price {
    hidden: no
  }
  dimension: unit_selling_price {
    hidden: no
  }

#} end item ordered/shipped amounts, prices and cost

  measure: count_inventory_item {
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }

  measure: count_order_lines {
    hidden: no
    type: count
  }

  measure: sum_ordered_amount {
    hidden: no
    type: sum
    sql: ${ordered_amount} ;;
  }

  measure: average_days_from_promise_to_fulfillment {
    hidden: no
    type: average
    description: "Average Number of Days between Fulfillment Date and Delivery Promise Date per Order Line"
    sql: ${fulfillment_days_after_promise_date} ;;
  }

  measure: average_days_from_request_to_fulfillment {
    hidden: no
    type: average
    description: "Average Number of Days between Fulfillment Date and Delivery Request Date per Order Line"
    sql: ${fulfillment_days_after_request_date} ;;
  }

  measure: average_cycle_time_days {
    hidden: no
    type: average
    description: "Average Number of Days from Order to Fulfillment per Order Line"
    sql: ${cycle_time_days} ;;
  }


  ########### TEST STUFF
  measure: count_distinct_inventory_item {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }

  measure: count_distinct_item_part_number {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }

  dimension: is_null_unit_cost {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_cost} is null ;;
  }

  dimension: is_null_unit_list_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price} is null ;;
  }

  dimension: is_null_unit_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_selling_price} is null ;;
  }

  dimension: is_difference_in_unit_list_and_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price}<>${unit_selling_price} ;;
  }

  # dimension: is_fulfillment_different_than_actual_ship {
  #   hidden: no
  #   type: yesno
  #   view_label: "TEST STUFF"
  #   sql: ${fulfillment_date} <> ${actual_ship_date} ;;
  # }

  dimension: test_item_description {
    hidden: no
    sql: (select d.TEXT FROM UNNEST(${item_descriptions}) AS d where d.language = 'US') ;;
    view_label: "TEST STUFF"
  }

  dimension: test_item_category_name {
    hidden: no
    sql: (select c.category_name FROM UNNEST(${item_categories}) AS c where c.category_set_name = 'Purchasing') ;;
    view_label: "TEST STUFF"
  }

  dimension: test_item_category_id {
    hidden: no
    sql: (select c.id FROM UNNEST(${item_categories}) AS c where c.category_set_name = 'Purchasing') ;;
    view_label: "TEST STUFF"
  }

  # (SELECT value.string_value FROM UNNEST(event_params) AS param WHERE param.key='page_location')

   }
