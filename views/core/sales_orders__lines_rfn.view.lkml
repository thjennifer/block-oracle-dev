## when column is duplicate of another in header (like is_open) then restate sql using ${TABLE}. reference
include: "/views/base/sales_orders.view"

view: +sales_orders__lines {

  fields_hidden_by_default: yes

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${line_id}) ;;
  }

  dimension: line_id {
    hidden: no
  }

  dimension: line_number {
    hidden: no
  }

  dimension: return_line_ids {
    primary_key: no
  }


#########################################################
# Parameters
# parameter_language to select the display language for item descriptions
# parameter_category_set_name to select category set to use for item categories
# parameter_target_currency to choose the desired currency into which the order currency should be converted
#{

  parameter: parameter_language {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Language"
    description: "Select language to display for item descriptions. Default is 'US'."
    suggest_explore: item_md
    suggest_dimension: item_md__item_descriptions.language
    default_value: "US"
  }

  parameter: parameter_category_set_name {
    hidden: no
    type: string
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Category Set Name"
    suggest_explore: item_md
    suggest_dimension: item_md__item_categories.category_set_name
    default_value: "Purchasing"
  }

  parameter: parameter_display_product_level {
    hidden: no
    type: unquoted
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Display Categories or Items"
    allowed_value: {label: "Category" value: "Category"}
    allowed_value: {label: "Item" value: "Item"}
    default_value: "Category"
  }

#} end parameters

#########################################################
# Item dimensions
#
#
#{

  dimension: inventory_item_id {
    hidden: no
    value_format_name: id
  }

  dimension: item_part_number {
    hidden: no
    value_format_name: id
  }

  dimension: item_organization_id {
    hidden:no
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
  }

  dimension: item_description {
    hidden: no
    group_label: "Item Description and Category"
    sql: COALESCE((SELECT d.TEXT FROM UNNEST(${item_descriptions}) AS d WHERE d.language = {% parameter sales_orders__lines.parameter_language %} ), CAST(${inventory_item_id} AS STRING)) ;;
    full_suggestions: yes
  }

  dimension: item_description_language {
    hidden: no
    group_label: "Item Description and Category"
    sql: (SELECT d.LANGUAGE FROM UNNEST(${item_descriptions}) AS d WHERE d.LANGUAGE = {% parameter sales_orders__lines.parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: category_description {
    hidden: no
    group_label: "Item Description and Category"
    sql: COALESCE(COALESCE((select c.description FROM UNNEST(${item_categories}) AS c where c.category_set_name = {% parameter parameter_category_set_name %} )
         ,COALESCE(CAST(NULLIF(${category_id},-1) AS STRING),"Unknown")));;
    full_suggestions: yes
  }

  dimension: category_id {
    hidden: no
    group_label: "Item Description and Category"
    sql: COALESCE((select c.id FROM UNNEST(${item_categories}) AS c where c.category_set_name = {% parameter parameter_category_set_name %}), -1 ) ;;
    full_suggestions: yes
  }

  dimension: category_group {
    hidden: no
    group_label: "Item Description and Category"
    sql: COALESCE((select c.category_name FROM UNNEST(${item_categories}) AS c where c.category_set_name = {% parameter parameter_category_set_name %}),"Unknown" ) ;;
    full_suggestions: yes
  }

  dimension: selected_product_dimension_description {
    hidden: no
    group_label: "Item Description and Category"
    label: "{% if selected_product_dimension_description._is_selected %}
                {% if parameter_display_product_level._parameter_value == 'Item' %}Item{%else%}Category{%endif%}
            {%else%}Selected Product Dimenstion Description{%endif%}"
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${item_description}{%else%}${category_description}{%endif%} ;;
  }

  dimension: selected_product_dimension_id {
    hidden: no
    group_label: "Item Description and Category"
    label: "{% if selected_product_dimension_id._is_selected %}
    {% if parameter_display_product_level._parameter_value == 'Item' %}Inventory Item ID{%else%}Category ID{%endif%}
    {%else%}Selected Product Dimenstion ID{%endif%}"
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${inventory_item_id}{%else%}${category_id}{%endif%} ;;
  }


#} end item dimensions


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
    timeframes: [raw,date,week,month,quarter,year,yesno]
  }

  dimension_group: schedule_ship {
    hidden: no
    description: "Scheduled ship date of order line."
    timeframes: [raw,date,week,month,quarter,year,yesno]
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


  dimension: is_fulfilled {
    hidden: no
    type: yesno
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_FULFILLED ;;
  }

  dimension: is_fulfilled_by_promise_date {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_promise_date_yes_no_null {
    hidden: no
    type: string
    group_label: "Line Status"
    label: "Is Fulfilled by Promise Date (Yes/No/Null)"
    sql: CASE WHEN ${TABLE}.IS_FULFILLED_BY_PROMISE_DATE THEN 'Yes'
              WHEN ${TABLE}.IS_FULFILLED_BY_PROMISE_DATE = FALSE then 'No'
         ELSE NULL END
        ;;
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: is_fulfilled_by_request_date_yes_no_null {
    hidden: no
    type: string
    group_label: "Line Status"
    label: "Is Fulfilled by Request Date (Yes/No/Null)"
    sql: CASE WHEN ${TABLE}.IS_FULFILLED_BY_REQUEST_DATE THEN 'Yes'
              WHEN ${TABLE}.IS_FULFILLED_BY_REQUEST_DATE = FALSE then 'No'
         ELSE NULL END
        ;;
  }

#} end  line status

#########################################################
# Line Cycle Times
#{

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
    sql: UPPER(${TABLE}.QUANTITY_UOM) ;;
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
    value_format_name: decimal_2
  }
  dimension: shipped_amount {
    hidden: no
    value_format_name: decimal_2
  }
  dimension: unit_cost {
    hidden: no
    value_format_name: decimal_2
  }
  dimension: unit_list_price {
    hidden: no
    value_format_name: decimal_2
  }
  dimension: unit_selling_price {
    hidden: no
    value_format_name: decimal_2
  }



#} end item ordered/shipped amounts, prices and cost



  measure: count_order_lines {
    hidden: no
    type: count
    drill_fields: [order_line_details*]
  }

  measure: total_sales_amount_by_source_currency {
    hidden: no
    type: sum
    description: "Sum of sales for order lines in source currency. Currency Code is required field to avoid summing across multiple currencies."
    required_fields: [sales_orders.currency_code]

    sql: ${ordered_amount} ;;
    value_format_name: decimal_0
  }

  measure: total_ordered_quantity_by_item {
    hidden: no
    type: sum
    description: "Sum of order quantity by item. Inventory Item ID is required field to avoid summing across multiple Unit of Measures."
    sql: ${ordered_quantity} ;;
    required_fields: [inventory_item_id]
    value_format_name: format_large_numbers_d1
  }

  measure: total_fulfilled_quantity_by_item {
    hidden: no
    type: sum
    description: "Sum of fulfilled quantity by item. Inventory Item ID is required field to avoid summing across multiple Unit of Measures."
    sql: ${fulfilled_quantity} ;;
    required_fields: [inventory_item_id]
    value_format_name: format_large_numbers_d1
  }

  measure: difference_ordered_fulfilled_quantity_by_item {
    hidden: no
    type: number
    description: "Ordered minus fulfilled quantity by item. Inventory Item ID is required field to avoid reporting quantitites across multiple Unit of Measures."
    sql: ${total_ordered_quantity_by_item} - ${total_fulfilled_quantity_by_item} ;;
    required_fields: [inventory_item_id]
    value_format_name: format_large_numbers_d1
  }

  measure: count_inventory_item {
    type: count_distinct
    description: "Distinct Count of Inventory Item ID"
    sql: ${inventory_item_id} ;;
  }



  measure: average_days_from_promise_to_fulfillment {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and delivery promise date per order line"
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
    description: "Average number of days from order to fulfillment per order line. Item Category or ID must be in query or compution will return null."
    sql: {% if inventory_item_id._is_selected or item_part_number._is_selected or item_description._is_selected or category_description._is_selected or selected_product_dimension_description._is_selected%}${cycle_time_days}{% else %}null{%endif%};;
    value_format_name: decimal_2
    # required_fields: [category_description]
  }



  set: order_line_details {
    fields: [sales_orders.header_id, sales_orders.order_number, sales_orders.ordered_date, line_id, line_number, status_code, inventory_item_id, sales_orders__lines__item_descriptions.item_description, ordered_quantity, ordered_amount]
  }



  ########### TEST STUFF
  # measure: count_distinct_inventory_item {
  #   hidden: no
  #   view_label: "TEST STUFF"
  #   type: count_distinct
  #   sql: ${inventory_item_id} ;;
  # }

  measure: count_distinct_item_part_number {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${item_part_number} ;;
  }

  measure: average_order_lines_per_order {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: ${count_order_lines} / ${sales_orders.count} ;;
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

  dimension: has_fulfilled_quantity_gt_0 {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${fulfilled_quantity} > 0 ;;
  }

  dimension: is_difference_in_unit_list_and_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price}<>${unit_selling_price} ;;
  }

  dimension: is_unit_list_gt_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price}>${unit_selling_price} ;;
  }

  # dimension: is_fulfillment_different_than_actual_ship {
  #   hidden: no
  #   type: yesno
  #   view_label: "TEST STUFF"
  #   sql: ${fulfillment_date} <> ${actual_ship_date} ;;
  # }





  dimension: test_item_category_id {
    hidden: no
    sql: (select c.id FROM UNNEST(${item_categories}) AS c where c.category_set_name = 'Purchasing') ;;
    view_label: "TEST STUFF"
  }

  measure: count_inventory_item_id {
    view_label: "TEST STUFF"
    hidden: no
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }
  # (SELECT value.string_value FROM UNNEST(event_params) AS param WHERE param.key='page_location')

  dimension: test_parameter_value {
    view_label: "TEST STUFF"
    hidden: no
    type: string
    sql: {% assign p = parameter_display_product_level._parameter_value %}'{{p}}' ;;
  }

   }
