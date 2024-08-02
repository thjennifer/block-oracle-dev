## when column is duplicate of another in header (like is_open) then restate sql using ${TABLE}. reference
include: "/views/base/sales_orders__lines.view"
include: "/views/core/sales_orders_common_amount_measures_ext.view"
include: "/views/core/otc_derive_common_product_fields_ext.view"
# include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +sales_orders__lines {

  fields_hidden_by_default: yes
  extends: [sales_orders_common_amount_measures_ext,otc_derive_common_product_fields_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${line_id}) ;;
  }

  dimension: line_id {
    hidden: no
    sql: COALESCE(${TABLE}.LINE_ID,-1) ;;
    value_format_name: id
  }

  dimension: line_number {
    hidden: no
  }

  dimension: return_line_ids {
    primary_key: no
  }


#########################################################
# Parameters
# parameter_display_product_level to show either Item or Categories in visualization
#{


  parameter: parameter_display_product_level {
    hidden: no
    type: unquoted
    view_label: "@{view_label_for_filters}"
    label: "Display Categories or Items"
    description: "Select whether to display categories or items in report. Use with dimensions Selected Product Dimension ID and Selected Product Dimension Description."
    allowed_value: {label: "Category" value: "Category"}
    allowed_value: {label: "Item" value: "Item"}
    default_value: "Category"
  }

#} end parameters

#########################################################
# Item dimensions
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
    hidden: no
    group_label: "Item Attributes"
    value_format_name: id
  }

  dimension: item_organization_name {
    hidden: no
    group_label: "Item Attributes"
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
  }

  dimension: selected_product_dimension_description {
    hidden: no
    group_label: "Item Categories & Descriptions"
    label: "{% if _field._is_selected %}
                {% if parameter_display_product_level._parameter_value == 'Item' %}Item{%else%}Category{%endif%}
            {%else%}Selected Product Dimension Description{%endif%}"
    description: "Values are either Item Description or Item Category Description based on user selection for Parameter Display Categories or Items."
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${item_description}{%else%}${category_description}{%endif%} ;;
    can_filter: yes
  }

  dimension: selected_product_dimension_id {
    hidden: no
    type: number
    group_label: "Item Categories & Descriptions"
    label: "{% if _field._is_selected %}
    {% if parameter_display_product_level._parameter_value == 'Item' %}Inventory Item ID{%else%}Category ID{%endif%}
    {%else%}Selected Product Dimension ID{%endif%}"
    description: "Values are either Item Inventory ID or Item Category ID based on user selection for Parameter Display Categories or Items."
    sql: {% if parameter_display_product_level._parameter_value == 'Item' %}${inventory_item_id}{%else%}${category_id}{%endif%} ;;
    can_filter: yes
    value_format_name: id
  }


#} end item dimensions


#########################################################
# Dates
#{

  dimension_group: fulfillment {
    hidden: no
    timeframes: [raw,date,week,month,quarter,year,yesno]
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

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    description: "Creation timestamp of record in Oracle source table."
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    description: "Last update timestamp of record in Oracle source table."
  }


#} end dates

#########################################################
# Line Status
#{


  dimension: line_status {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
  }

  dimension: line_category_code {
    hidden: no
  }

  dimension: is_backlog {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line is not in ENTERED, BOOKED, CLOSED, OR CANCELLED statuses."
    full_suggestions: yes
  }

  dimension: is_backlog_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    sql: ${is_backlog} ;;
    html: @{symbols_for_yes_no} ;;
  }

  dimension: is_backordered {
    hidden: no
    group_label: "Line Status"
    description: "Yes if line cannot be fulfilled with the current inventory."
    full_suggestions: yes
    sql: ${TABLE}.IS_BACKORDERED ;;
  }

  dimension: is_backordered_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    sql: ${is_backordered} ;;
    html: @{symbols_for_yes_no} ;;
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

  dimension: is_booking_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    sql: ${is_booking} ;;
    html: @{symbols_for_yes_no} ;;
  }

  dimension: is_cancelled {
    hidden: no
    group_label: "Line Status"
    full_suggestions: yes
    sql: ${TABLE}.IS_CANCELLED ;;
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

  dimension: has_return_with_symbols {
    hidden: no
    group_label: "Line Status with Symbols"
    sql: ${has_return} ;;
    html: @{symbols_for_yes_no} ;;
  }

  dimension: is_sales_order {
    hidden: yes
    type: yesno
    description: "Line Category Code equals Order (and is not a return)"
    sql: ${line_category_code} = 'ORDER' ;;
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

  dimension: is_shipped {
    hidden: no
    type: yesno
    group_label: "Line Status"
    sql: ${shipped_quantity} > 0 ;;
  }

  dimension: is_invoiced {
    hidden: no
    type: yesno
    group_label: "Line Status"
    sql: ${invoiced_quantity} <> 0 ;;
  }


#} end  line status

#########################################################
# Cancel Reasons
#{
  dimension: cancel_reason_code {
    hidden: no
    type: string
    group_label: "Cancel Reasons"
    sql: (SELECT d.CODE FROM UNNEST(CANCEL_REASON) AS d WHERE d.language = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: cancel_reason_description {
    hidden: no
    type: string
    group_label: "Cancel Reasons"
    label: "Cancel Reason"
    sql: (SELECT d.MEANING FROM UNNEST(CANCEL_REASON) AS d WHERE d.language = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }

  dimension: cancel_reason_language_code {
    hidden: no
    group_label: "Cancel Reasons"
    description: "Language in which to display cancel reasons."
    sql: (SELECT d.LANGUAGE FROM UNNEST(CANCEL_REASON) AS d WHERE d.LANGUAGE = {% parameter otc_common_parameters_xvw.parameter_language %} ) ;;
    full_suggestions: yes
  }
#} end cancel reasons

#########################################################
# Fulfillment Cycle Days Dimensions
# dimensions hidden and shown in Explore as average measure
#{

# shown in Explore as measure average_days_from_promise_to_fulfillment
  dimension: fulfillment_days_after_promise_date {
    hidden: yes
    label: "Fulfillment Days after Promise Date"
    description: "Number of days between Fulfillment Date and Delivery Promise Date."
  }

# shown in Explore as measure average_days_from_request_to_fulfillment
  dimension: fulfillment_days_after_request_date {
    hidden: yes
    label: "Fulfillment Days after Request Date"
    description: "Number of days between Fulfillment Date and Delivery Request Date."
  }

# shown in Explore as measure average_cycle_time_days
  dimension: cycle_time_days {
    hidden: yes
    description: "Number of Days between Ordered Date and Fulfillment Date"
  }

#} end fulfillment cycle days dimensions


#########################################################
# Item quantities and weights as dimensions
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
  }

  dimension: booking_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: backlog_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: fulfilled_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: shipped_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: invoiced_quantity {
    hidden: no
    group_label: "Quantities"
  }

  dimension: cancelled_quantity {
    hidden: no
    group_label: "Quantities"
    # required_fields: [item_part_number]
  }

  dimension: difference_ordered_fulfilled_quantity {
    hidden: yes
    group_label: "Quantities"
    label: "Difference between Ordered and Fulfilled Quantities"
    sql: ${ordered_quantity} - COALESCE(${fulfilled_quantity},0) ;;
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
# Item prices and cost
#{

  dimension: unit_cost {
    hidden: no
    group_label: "Item Attributes"
    label: "Unit Cost (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_list_price {
    hidden: no
    group_label: "Item Attributes"
    label: "Unit List Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_selling_price {
    hidden: no
    group_label: "Item Attributes"
    label: "Unit Selling Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_list_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Attributes"
    label: "@{label_build}"
    sql: ${unit_list_price} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: unit_selling_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Attributes"
    label: "@{label_build}"
    sql: ${unit_selling_price} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  ## need to add gross_selling_price_target_currency
  dimension: unit_discount_amount_target_currency {
    hidden: no
    group_label: "Item Attributes"
    label: "@{label_build}"
    sql: ${unit_list_price_target_currency} - ${unit_selling_price_target_currency} ;;
    value_format_name: decimal_2

  }


#} end item prices and cost

#########################################################
# Amounts as dimensions including Currency Conversions
#{
  dimension: ordered_amount {
    hidden: no
    group_label: "Amounts"
    label: "Ordered Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: booking_amount {
    hidden: no
    group_label: "Amounts"
    label: "Booking Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: backlog_amount {
    hidden: no
    group_label: "Amounts"
    label: "Backlog Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: shipped_amount {
    hidden: no
    group_label: "Amounts"
    label: "Shipped Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: invoiced_amount {
    hidden: no
    group_label: "Amounts"
    label: "Invoiced Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount {
    hidden: no
    group_label: "Amounts"
    label: "Fulfilled Amount (Source Currency)"
    value_format_name: decimal_2
  }



  dimension: currency_code {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Source)"
    description: "Currency of the order header."
    sql: ${sales_orders.currency_code} ;;
  }

  dimension: target_currency_code {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Amounts"
    sql: IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Amounts"
    sql: ${currency_code} <> ${target_currency_code} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  dimension: ordered_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${ordered_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: booking_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${booking_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: backlog_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${backlog_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${fulfilled_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${shipped_amount} * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: invoiced_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${invoiced_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

#} end amount dimensions

  measure: count_order_lines {
    hidden: no
    type: count
    label: "Order Lines Count"
    drill_fields: [order_line_details*]
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
    value_format_name: decimal_0
    link: {
      label: "Show Fulfillment Details"
      url: "{{dummy_drill_fulfillment_details._link}}&sorts=sales_orders__lines.difference_ordered_fulfilled_quantity+desc"
    }
  }

  measure: count_inventory_item {
    type: count_distinct
    description: "Distinct Count of Inventory Item ID"
    sql: ${inventory_item_id} ;;
  }



  measure: average_fulfillment_days_after_promise_date {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and promised delivery date per order line. Positive values indicate fulfillment occurred after requested delivery date."
    sql: ${fulfillment_days_after_promise_date} ;;
  }

  measure: average_fulfillment_days_after_request_date {
    hidden: no
    type: average
    description: "Average number of days between fulfillment date and requested delivery date per order line. Positive values indicate fulfillment occurred after requested delivery date. "
    sql: ${fulfillment_days_after_request_date} ;;
  }

  measure: average_cycle_time_days {
    hidden: no
    type: average
    description: "Average number of days from order to fulfillment per order line. Item Category or ID must be in query or compution will return null."
    sql: {% if inventory_item_id._is_selected or item_part_number._is_selected or item_description._is_selected or category_id._is_selected or category_description._is_selected or selected_product_dimension_id._is_selected or selected_product_dimension_description._is_selected%}${cycle_time_days}{% else %}null{%endif%};;
    value_format_name: decimal_2
    filters: [is_cancelled: "No"]
    link: {
      label: "Show Fulfillment Details"
      url: "{{dummy_drill_fulfillment_details._link}}&sorts=sales_orders__lines.cycle_time_days+desc"
      # url: "@{link_generate_variable_defaults}
      # {% assign link = link_generator._link %}
      # {% assign drill_fields = 'sales_orders.selected_customer_number,sales_orders.selected_customer_name,sales_orders__lines.total_backlog_amount_target_currency'%}
      # @{link_generate_explore_url}
      # "
    }
  }

#########################################################
# Amounts measures
#{

  measure: total_sales_amount_by_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    description: "Sum of sales for order lines in source currency. Currency Code is required field to avoid summing across multiple currencies."
    required_fields: [sales_orders.currency_code]
    sql: ${ordered_amount} ;;
    filters: [line_category_code: "-RETURN"]
    value_format_name: decimal_0
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    #group label defined in sales_orders_common_amount_measures_ext
    #label defined in sales_orders_common_amount_measures_ext
    #description defined in sales_orders_common_amount_measures_ext
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},${sales_orders.non_cancelled_sales_order_count})  ;;
    # value_format defined in sales_orders_common_amount_measures_ext
  }

  measure: total_backlog_amount_target_currency_formatted {
    link: {
      label: "Show Customers with Highest Backlog"
      url: "{{dummy_backlog_by_customer._link}}"
      # url: "@{link_generate_variable_defaults}
      # {% assign link = link_generator._link %}
      # {% assign drill_fields = 'sales_orders.selected_customer_number,sales_orders.selected_customer_name,sales_orders__lines.total_backlog_amount_target_currency'%}
      # @{link_generate_explore_url}
      # "
    }
  }

  measure: total_backordered_amount_target_currency {
    type: sum
    sql: ${ordered_amount_target_currency} ;;
    filters: [line_category_code: "-RETURN",is_backordered: "Yes"]
  }

  measure: total_backordered_amount_target_currency_formatted {
    type: number
    sql: ${total_backordered_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Show Items with Highest Amount on Backorder"
      url: "{{dummy_backordered_by_item._link}}"
    }

  }


#} end target currency dimensions and measures

  measure: dummy_backlog_by_customer {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [backlog_by_customer*]
  }

  measure: dummy_backlog_by_item {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [backlog_by_item*]
  }

  measure: dummy_backordered_by_item {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [backordered_by_item*]
  }

  measure: dummy_drill_fulfillment_details {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [drill_fulfillment_details*]
  }

  set: order_line_details {
    fields: [sales_orders.order_number, sales_orders.ordered_date, line_id, line_number, line_status, item_part_number, sales_orders__lines.item_description, ordered_quantity, ordered_amount_target_currency]
  }

  set: backlog_by_customer {
    fields: [sales_orders.selected_customer_number, sales_orders.selected_customer_name, total_backlog_amount_target_currency]
  }

  set: backlog_by_item {
    fields: [item_part_number, item_description, category_description, total_backlog_amount_target_currency]
  }

  set: backordered_by_item {
    fields: [item_part_number, item_description, category_description, total_backordered_amount_target_currency]
  }

  set: drill_fulfillment_details {
    fields: [order_line_details*,fulfilled_quantity, difference_ordered_fulfilled_quantity, fulfilled_amount_target_currency, fulfillment_date,cycle_time_days]
  }





   }
