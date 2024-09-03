#########################################################{
# PURPOSE
# The SalesOrders table and its corresponding View sales_orders
# captures orders details by header_id (labeled Order ID)
#
# SOURCES
# Refines View sales_orders (defined in /views/base folder)
# Extends Views:
#   otc_common_currency_fields_ext
#   sales_orders_common_dimensions_ext
#   sales_orders_common_count_measures_ext
#
# REFERENCED BY
# Explore sales_orders
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion
#   parameter_customer_type, selected_customer_number, selected_customer_name,
#   selected_customer_country plus bill_to_customer_*, ship_to_customer_*,
#     and sold_to_customer_* dimensions
#   cancelled_sales_order_percent, fulfilled_sales_order_percent, etc...
#
# REPEATED STRUCTS
# - Also includes Repeated Struct for LINES. See view sales_orders__lines for
#   order line dimensions and measures.
#
# NOTES
# - This view includes both ORDERS and RETURNS. Use order_category_code to pick which to include.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Includes fields which reference CURRENCY_CONVERSION_SDT so this view must be included in the
#   Sales Orders Explore.
#########################################################}


include: "/views/base/sales_orders.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
include: "/views/core/sales_orders_common_count_measures_ext.view"


view: +sales_orders {
  extends: [otc_common_currency_fields_ext, sales_orders_common_dimensions_ext, sales_orders_common_count_measures_ext]

  fields_hidden_by_default: yes

  dimension: header_id {
    hidden: no
    primary_key: yes
    label: "Order ID"
    value_format_name: id
  }

  dimension: order_number {
    hidden: no
    value_format_name: id
  }

  dimension: ledger_id {
    hidden: no
    value_format_name: id
  }

  dimension: ledger_name {
    hidden: no
    description: "Name of ledger or set of books"
  }

  dimension: sales_rep {hidden: no}

  dimension: order_category_code {
    hidden: no
    sql: UPPER(${TABLE}.ORDER_CATEGORY_CODE) ;;
  }

  dimension: business_unit_id {
    hidden: no
    value_format_name: id
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: order_source_id {
    hidden: no
    sql: COALESCE(${TABLE}.ORDER_SOURCE_ID,-1);;
    value_format_name: id
  }

  dimension: order_source_name {
    hidden: no
    sql: COALESCE(${TABLE}.ORDER_SOURCE_NAME,"Unknown") ;;
  }


#########################################################
# DIMENSIONS: Customer
#{
# selected_customer_name, _country and _type extended from sales_orders_common_dimensions_ext

  dimension: bill_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_country {
    hidden: no
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: sold_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.SOLD_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: sold_to_customer_country {
    hidden: no
    sql: COALESCE(${TABLE}.SOLD_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: ship_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.SHIP_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: ship_to_customer_country {
    hidden: no
    sql: COALESCE(${TABLE}.SHIP_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end customer

#########################################################
# DIMENSIONS: Dates
#{

  dimension_group: ordered {
    hidden: no
    timeframes: [raw, date, week, month, quarter, year]
  }

  dimension: ordered_month_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Month Number"
    description: "Ordered month as number 1 to 12"
  }

  dimension: ordered_quarter_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Quarter Number"
    description: "Ordered quarter as number 1 to 4"
  }

  dimension: ordered_year_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Year Number"
    description: "Ordered year as integer"
    value_format_name: id
  }

  dimension_group: booked {
    hidden: no
    }

  dimension_group: fulfillment {
    hidden: no
  }

  dimension_group: request_date {
    hidden: no
    label: "Request"
  }

  dimension: fiscal_period_num {
    hidden: no
    group_label: "Fiscal Date"
    group_item_label: "Fiscal Period Number"
   }

  dimension: fiscal_period_name {
    hidden: no
    group_label: "Fiscal Date"
  }

  dimension: fiscal_period_set_name {
    hidden: no
    group_label: "Fiscal Date"
  }

  dimension: fiscal_period_type {
    hidden: no
    group_label: "Fiscal Date"
  }

  dimension: fiscal_quarter_num {
    hidden: no
    group_label: "Fiscal Date"
    group_item_label: "Fiscal Quarter Number"
  }

  dimension: fiscal_year_num {
    hidden: no
    group_label: "Fiscal Date"
    group_item_label: "Fiscal Year Number"
    value_format_name: id
  }

  dimension: fiscal_year_period {
    hidden: no
    type: string
    group_label: "Fiscal Date"
    label: "Fiscal Year-Period (YYYY-PPP)"
    description: "Fiscal Year-Period of the ordered date formatted as YYYY-PPP string"
    sql: CONCAT(CAST(${fiscal_year_num} AS STRING),"-",LPAD(CAST(${fiscal_period_num} AS STRING),3,'0'));;
  }

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
  }

#} end dates

#########################################################
# DIMENSIONS: Order Status
#{

  dimension: header_status {
    hidden: no
    group_label: "Order Status"
    label: "Order Status"
  }

  dimension: has_backorder {
    hidden: no
    group_label: "Order Status"
    label: "Has Backorder"
  }

  dimension: has_cancelled {
    hidden: no
    group_label: "Order Status"
  }

  dimension: has_hold {
    hidden: no
    group_label: "Order Status"
    label: "Has Been on Hold"
  }

  dimension: has_return_line {
    hidden: no
    group_label: "Order Status"
  }

  dimension: has_return_line_with_symbols {
    hidden: no
    group_label: "Order Status with Symbols"
    description: "✅ if order has at least 1 line with a return"
    sql: COALESCE(${has_return_line},false) ;;
    html: @{html_symbols_for_yes} ;;
  }

  dimension: is_blocked {
    hidden: no
    type: yesno
    group_label: "Order Status"
    description: "Indicates whether order is currently on hold or has an item on backorder"
    sql: ${has_backorder} OR ${is_held} ;;
  }

  dimension: is_blocked_with_symbols {
    hidden: no
    group_label: "Order Status with Symbols"
    description: "🟥 if order is currently on hold or has an item on backorder"
    sql: COALESCE(${is_blocked},false);;
    html: {% if value == true %}🟥 {% else %}   {% endif %}  ;;
  }

  dimension: is_booked {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_cancelled {
    hidden: no
    group_label: "Order Status"
    description: "Indicates whether the enitre order is cancelled"
  }

#--> not displayed in Explore but used in filtered measure Fillable Sales Order Count
  dimension: is_fillable {
    hidden: yes
    type: yesno
    group_label: "Order Status"
    description: "Indicates whether order can be met with available inventory (no items are backordered)"
#--> did not use ${is_backordered} = No because would count orders where ${TABLE}.IS_BACKORDERED = NULL
    sql: ${TABLE}.HAS_BACKORDER = FALSE ;;
  }

#--> derived as LOGICAL_AND(Lines.IS_FULFILLED)
  dimension: is_fulfilled {
    hidden: no
    group_label: "Order Status"
    description: "Indicates if all order lines are fulfilled (inventory is reserved and ready to be shipped)"
  }

  dimension: is_fulfilled_with_symbols {
    hidden: no
    group_label: "Order Status with Symbols"
    description: "✅ if all order lines are fulfilled (inventory is reserved and ready to be shipped)."
    sql: COALESCE(${is_fulfilled},false) ;;
    html: @{html_symbols_for_yes};;
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    type: yesno
    group_label: "Order Status"
    label: "Is On-Time & In-Full (OTIF)"
    description: "Indicates if all order lines are fulfilled by requested delivery date"
    sql: ${num_lines} > 0 AND ${num_lines} = ${num_lines_fulfilled_by_request_date} ;;
  }

  dimension: is_fulfilled_by_promise_date{
    hidden: no
    type: yesno
    group_label: "Order Status"
    label: "Is Fulfilled by Promise Date"
    description: "Indicates if all order lines are fulfilled by promised delivery date"
    sql: ${num_lines} > 0 AND ${num_lines} = ${num_lines_fulfilled_by_promise_date} ;;
  }

  dimension: is_held {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_intercompany {
    hidden: no
    group_label: "Order Status"
  }

  dimension: is_open {
    hidden: no
    group_label: "Order Status"
  }

  dimension: open_closed_cancelled {
    hidden: no
    type: string
    group_label: "Order Status"
    description: "Order is either open, closed or cancelled"
    sql: CASE WHEN ${header_status} in ("CLOSED","CANCELLED") THEN INITCAP(${header_status})
              WHEN ${is_open} THEN "Open"
              WHEN ${is_open} = false THEN 'Closed' END;;
  }

  dimension: open_closed_cancelled_with_symbols {
    group_label: "Order Status with Symbols"
    hidden: no
    type: string
    description: "Order status is indicated with colored symbol and text: 〇 (open), ◉ (closed) or X (cancelled)"
    sql: ${open_closed_cancelled} ;;
    html: {% if value == "Open" %}{%assign sym = "〇" %}{% assign color = "#4CBB17" %}
          {% elsif value == "Closed" %}{%assign sym = "◉"%}{% assign color = "#BFBDC1" %}
          {% elsif value == "Cancelled" %}{%assign sym = "X"%}{% assign color = "#EB9486" %}
            {% else %}
             {%assign sym = "" %}{% assign color = "#080808" %}
            {%endif%}<p style="color: {{color}}"><b> {{sym}} {{value}}</b> </p>;;
  }

#} end order status

#########################################################
# DIMENSIONS: Currency Conversion
#{
# target_currency_code and is_incomplete_conversion extended
# from otc_common_currency_fields_ext

  dimension: currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Source)"
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Currency Conversion"
    description: "Exchange rate between source and target currency for a specific date"
    sql: IF(${currency_code} = ${target_currency_code}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    # type, label, group_label, description defined in otc_common_currency_fields_ext
    sql: ${currency_code} <> ${target_currency_code} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

#} end currency conversion

#########################################################
# DIMENSIONS: Order Totals
#{

  dimension: total_ordered_amount {
    hidden: no
    group_label: "Order Totals"
    label: "Total Ordered Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: total_sales_ordered_amount {
    hidden: no
    group_label: "Order Totals"
    label: "Total Sales Amount (Source Currency)"
    value_format_name: decimal_2
    }

  dimension: total_ordered_amount_target_currency {
    hidden: no
    type: number
    group_label: "Order Totals"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of ordered amounts for all order lines converted to target currency"
    sql: COALESCE(${total_ordered_amount},0) * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: total_sales_amount_target_currency {
    hidden: no
    type: number
    group_label: "Order Totals"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of ordered amounts for all order lines excluding RETURN lines converted to target currency"
    sql: COALESCE(${total_sales_ordered_amount},0) * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: num_lines {
    hidden: no
    group_label: "Order Totals"
    label: "Number of Lines"
  }

  dimension: num_lines_fulfilled_by_request_date {
    hidden: no
    group_label: "Order Totals"
    label: "Number of Lines Fulfilled by Request Date"
  }

  dimension: num_lines_fulfilled_by_promise_date {
    hidden: no
    group_label: "Order Totals"
    label: "Number of Lines Fulfilled by Promise Date"
  }

#} end order totals

#########################################################
# MEASURES: Counts
#{
# see sales_orders_common_count_measures_ext for labels & descriptions

  measure: count {hidden: yes}

  measure: order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    drill_fields: [header_details*]
  }

  measure: sales_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [order_category_code: "-RETURN"]
    drill_fields: [header_details*]
  }

  measure: return_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [order_category_code: "RETURN"]
    drill_fields: [header_details*]
  }

  measure: blocked_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_blocked: "Yes"]
#--> returns table showing blocked order count and percent of total by has_backorder and is_held
    link: {
      label: "Show Sources of Blocks"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign drill_fields = 'sales_orders.has_backorder, sales_orders.is_held, sales_orders.sales_order_count, sales_orders.percent_of_sales_orders' %}
      {% assign default_filters = 'sales_orders.is_blocked=Yes' %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
#--> returns table of blocked orders
    link: {
      label: "Show Blocked Orders"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign drill_fields = 'sales_orders.order_number, sales_orders.order_catgory_code, sales_orders.header_status, sales_orders.ordered_date, sales_orders.selected_customer_name, sales_orders.total_sales_amount_target_currency, sales_orders.has_backorder, sales_orders.is_held' %}
      {% assign default_filters = 'sales_orders.is_blocked=Yes' %}
      {% assign sorts = 'sales_orders.total_sales_amount_target_currency+desc' %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
  }

  measure: cancelled_order_count {
    hidden: yes
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_cancelled: "Yes"]
  }

  measure: fillable_order_count {
    hidden: no
    type: count
    description: "Number of sales orders that can be met with the available inventory (none of items are backordered)"
    filters: [is_fillable: "Yes"]
  }

  measure: fulfilled_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_fulfilled: "Yes"]
  }

  measure: fulfilled_by_request_date_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_fulfilled_by_request_date : "Yes"]
  }

  measure: fulfilled_by_promise_date_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_fulfilled_by_promise_date : "Yes"]
  }

  measure: has_backorder_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [has_backorder: "Yes"]
  }

#--> filter to sales orders as not relevant to returns
   measure: has_return_sales_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [has_return_line: "Yes", order_category_code: "-RETURN"]
  }

  measure: no_holds_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [has_hold: "No"]
    drill_fields: [header_details*]
  }

  measure: non_cancelled_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_cancelled: "No"]
  }

  measure: open_order_count {
    hidden: no
    type: count
    #label & description defined in sales_orders_common_count_measures_ext
    filters: [is_open: "Yes"]
    # drill_fields: [header_details*]
  }

#} end counts

#########################################################
# MEASURES: Percent of Sales Orders
#{
# measures defined in and extended from sales_orders_common_count_measures_ext
# updates for Explore-specific links
  measure: has_backorder_order_percent {
#--> returns table of 50 items including category sorted in descending order by total backordered amount
    link: {
      label: "Show Top 50 Items with Highest Amount on Backorder"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign drill_fields = 'sales_orders__lines.item_part_number, sales_orders__lines.item_description, sales_orders__lines.category_description, sales_orders__lines.total_backordered_amount_target_currency' %}
      {% assign limit = 50 %}
      {% assign default_filters = 'sales_orders__lines.line_category_code=ORDER,sales_orders__lines.is_backordered=Yes' %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
  }

  measure: has_return_sales_order_percent {
    link: {
      label: "Show Orders and Lines with Returns"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign header_drill = 'sales_orders.order_number, sales_orders.order_category_code, sales_orders.header_status, sales_orders.ordered_date, sales_orders.selected_customer_name, sales_orders.total_sales_amount_target_currency' %}
      {% assign line_drill = 'sales_orders__lines.line_id, sales_orders__lines.line_number,sales_orders__lines.item_part_number, sales_orders__lines.item_description,sales_orders__lines.ordered_quantity, sales_orders__lines.quantity_uom,sales_orders__lines.ordered_amount_target_currency,sales_orders__lines.has_return' %}
      {% assign return_drill = 'sales_orders__lines__return_line_ids.return_line_id'%}
      {% assign drill_fields = header_drill | append: ',' | append: line_drill | append: ',' | append: return_drill %}
      {% assign default_filters = 'sales_orders.has_return_line=Yes' %}
      {% assign sorts='sales_orders.order_number, sales_orders__lines.line_number' %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
  }

#} end percent of sales orders


#########################################################
# SETS
#{

  set: header_details {
    fields: [order_number, order_category_code, header_status,ordered_date,sold_to_customer_name, bill_to_customer_name, total_sales_amount_target_currency]
  }

  set: header_drill_from_dash {
    fields: [order_number, order_category_code, header_status, ordered_date, selected_customer_name, total_sales_amount_target_currency]
  }

  set: line_drill_from_dash {
    fields: [sales_orders__lines.line_id, sales_orders__lines.line_number,
            sales_orders__lines.item_part_number, sales_orders__lines.item_description,
            sales_orders__lines.ordered_quantity, sales_orders__lines.quantity_uom,
            sales_orders__lines.ordered_amount_target_currency,
            sales_orders__lines.has_return]
  }

#} end sets
}
