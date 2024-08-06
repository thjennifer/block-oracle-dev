#########################################################{
# PURPOSE
# The SalesOrders table and its corresponding View sales_orders
# captures orders details by header_id (labeled Order ID)
#
# SOURCES
# Refines View sales_orders (defined in /views/base folder)
# Extends Views:
#   sales_orders_common_dimensions_ext
#   sales_orders_common_count_measures_ext
#
# REFERENCED BY
# Explore sales_orders
#
# EXTENDED FIELDS found in both sales_orders and sales_orders_daily_agg
# Extends common dimensions:
#    parameter_customer_type, selected_customer_number, selected_customer_name,
#    selected_customer_country plus bill_to_customer_*, ship_to_customer_*,
#    and sold_to_customer_* dimensions
#
# Extends common count measures:
#    e.g., cancelled_sales_order_percent, fulfilled_sales_order_percent, etc...
#
# KEY MEASURES
#    Amount in Local Currency, Amount in Target Currency
#    Cumulative Amount in Local Currency, Cumulative Amount in Target Currency
#    Exchange Rate (based on last date in the period)
#    Avg Exchange Rate, Max Exchange Rate
#    Current Ratio, Current Assets, and Current Liabilities
#
# CAVEATS
# This table includes both ORDERS and RETURNS. Use order_category_code to pick which to include.
# All of the OTC dashboards focus on ORDERS and exclude RETURNS from reported KPIs.
# Fields hidden by default. Update field's 'hidden' property to show/hide.
#
# HOW TO USE
# To query this table, always include Fiscal Year and Fiscal Period as dimensions
# and filter to:
#   - a single Client MANDT (handled with Constant defined in Manifest file)
#   - a single Language (the Explore based on this view uses User Attribute locale to select language in joined view language_map_sdt)
#   - a single Target Currency
#   - a single Hierarchy Name or Financial Statement Version
#   - a single Chart of Accounts
#   - a single Company
#########################################################}


include: "/views/base/sales_orders.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
include: "/views/core/sales_orders_common_count_measures_ext.view"


view: +sales_orders {
  extends: [sales_orders_common_dimensions_ext,sales_orders_common_count_measures_ext]

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

  dimension: ledger_name {hidden: no}

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
    sql: COALESCE(${TABLE}.ORDER_SOURCE_NAME,COALESCE(CAST(NULLIF(${order_source_id},-1) AS STRING),"Unknown")) ;;
  }


#########################################################
# Customer Dimensions
# selected_customer_name, _country and _type extebded from sales_orders_common_dimensions_ext
#{
  dimension: bill_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_country {
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: sold_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.SOLD_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: sold_to_customer_country {
    sql: COALESCE(${TABLE}.SOLD_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: ship_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.SHIP_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: ship_to_customer_country {
    sql: COALESCE(${TABLE}.SHIP_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end business unit / order source / customer dimensions

#########################################################
# Dates
#{

  dimension_group: ordered {
    hidden: no
    timeframes: [raw, date, week, month, quarter, year]
  }

  dimension: ordered_month_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Month Num"
    description: "Ordered Month as Number 1 to 12"
  }

  dimension: ordered_quarter_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Quarter Num"
    description: "Ordered Quarter as Number 1 to 4"
  }

  dimension: ordered_year_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Year Num"
    description: "Ordered Year as Integer"
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
  }
  dimension: fiscal_year_num {
    hidden: no
    group_label: "Fiscal Date"
    value_format_name: id
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
# Order Status
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
    description: "Yes, if at least one order line does not enough available inventory to fill."
  }

  dimension: has_cancelled {
    hidden: no
    group_label: "Order Status"
    description: "At least one order line was cancelled. Use IS_CANCELLED to check if the entire order is cancelled."
  }

  dimension: has_hold {
    hidden: no
    group_label: "Order Status"
    label: "Has Been On Hold"
    description: "Order has been held at some point in process flow. Use Is Held to identify if order is currently on hold."
  }

  dimension: has_return_line {
    hidden: no
    group_label: "Order Status"
    description: "Yes if sales order has at least 1 line with a return."
  }

  dimension: has_return_line_with_symbols {
    hidden: no
    group_label: "Order Status with Symbols"
    description: "✅ if sales order has at least 1 line with a return."
    sql: ${has_return_line} ;;
    html: @{symbols_for_yes_no} ;;
  }

  dimension: is_blocked {
    hidden: no
    type: yesno
    group_label: "Order Status"
    description: "Yes if order is either held or has an item on backorder."
    sql: ${has_backorder} OR ${is_held} ;;
  }

  dimension: is_blocked_with_symbols {
    hidden: no
    group_label: "Order Status with Symbols"
    description: "🟥 if order is either held or has an item on backorder."
    sql: ${is_blocked};;
    html: {% if value == true %}🟥 {% else %}   {% endif %}  ;;
  }

  dimension: is_booked {
    hidden: no
    group_label: "Order Status"
    description: "The header is in or past the booked phase."
  }

  dimension: is_cancelled {
    hidden: no
    group_label: "Order Status"
    description: "Entire order is cancelled."
  }

  # not displayed in Explore but used in filtered measure Fillable Sales Order Count
  dimension: is_fillable {
    hidden: yes
    type: yesno
    group_label: "Order Status"
    description: "Yes, if sales order can be met with available inventory (no items are backordered)."
    # did not use ${is_backordered} = No becuase would count orders where ${TABLE}.IS_BACKORDERED = NULL
    sql: ${TABLE}.HAS_BACKORDER = FALSE ;;
  }

  dimension: is_fulfilled {
    hidden: no
    group_label: "Order Status"
    description: "Yes if all order lines are fulfilled (inventory is reserved and ready to be shipped)."
    # derived as LOGICAL_AND(Lines.IS_FULFILLED)
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    type: yesno
    group_label: "Order Status"
    label: "Is On-Time & In-Full (OTIF)"
    description: "Yes if all lines of order are fulfilled by requested delivery date."
    sql: ${num_lines} > 0 AND ${num_lines} = ${num_lines_fulfilled_by_request_date} ;;
  }

  dimension: is_fulfilled_by_promise_date{
    hidden: no
    type: yesno
    group_label: "Order Status"
    label: "Is Fulfilled by Promise Date"
    description: "Yes if all lines of order are fulfilled by promised delivery date."
    sql: ${num_lines} > 0 AND ${num_lines} = ${num_lines_fulfilled_by_promise_date} ;;
  }

  dimension: is_fulfilled_with_symbols {
    hidden: no
    group_label: "Order Status with Symbols"
    description: "✅ if all order lines are fulfilled (inventory is reserved and ready to be shipped). Else  ❌"
    sql: ${is_fulfilled} ;;
    html: @{symbols_for_yes_no};;
  }

  dimension: is_held {
    hidden: no
    group_label: "Order Status"
    description: "Yes indicates order is Currently Held"
  }

  dimension: is_intercompany {
    hidden: no
    group_label: "Order Status"
    description: "Yes indicates transaction was internal within the company."
  }

  dimension: is_open {
    hidden: no
    group_label: "Order Status"
  }

  dimension: open_closed_cancelled {
    hidden: no
    type: string
    group_label: "Order Status"
    description: "Order is either open, closed or cancelled."
    sql: CASE WHEN ${header_status} in ("CLOSED","CANCELLED") THEN INITCAP(${header_status})
              WHEN ${is_open} THEN "Open"
              WHEN ${is_open} = false THEN 'Closed' END;;
  }

  dimension: open_closed_cancelled_with_symbols {
    group_label: "Order Status with Symbols"
    hidden: no
    type: string
    description: "Order status is indicated with colored symbol and text: 〇 (open), ◉ (closed) or X (cancelled)."
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
# Currency Conversion
#{

  dimension: currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Source)"
    description: "Currency of the order."
  }

  dimension: target_currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Target)"
    description: "Converted target currency of the order from the source currency."
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Currency Conversion"
    description: "Exchange rate between source and target currency for a specific date."
    sql: IF(${sales_orders.currency_code} = ${target_currency_code}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
  }

#} end currency conversion

#########################################################
# Order Totals as Dimensions
#{

  dimension: total_ordered_amount {
    hidden: no
    group_label: "Order Totals"
    label: "Total Ordered Amount (Source Currency)"
    description: "Total amount for an order in source currency."
    value_format_name: decimal_2
  }

  dimension: total_sales_ordered_amount {
    hidden: no
    group_label: "Order Totals"
    label: "Total Sales Amount (Source Currency)"
    description: "Total sales amount for an order in source currency. Includes only lines with line category code of 'ORDER'."
    value_format_name: decimal_2
    }

  dimension: total_ordered_amount_target_currency {
    hidden: no
    type: number
    group_label: "Order Totals"
    label: "@{label_build}"
    description: "Total amount for an order in target currency."
    sql: COALESCE(${total_ordered_amount},0) * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: total_sales_amount_target_currency {
    hidden: no
    type: number
    group_label: "Order Totals"
    # label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    label: "@{label_build}"
    description: "Total sales amount for an order in target currency. Includes only lines with line category code of 'ORDER'"
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

#} end order amount

#########################################################
# Count Measures
# see sales_orders_common_count_measures_ext for labels & descriptions
#{

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
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [order_category_code: "-RETURN"]
    drill_fields: [header_details*]
  }

  # measure: sales_order_count_formatted {
  #   hidden: no
  #   type: number
  #   sql: ${sales_order_count} ;;
  #   value_format_name: format_large_numbers_d1
  #   link: {
  #     label: "Show Sales Orders by Month"
  #     # url: "{{dummy_drill_monthly_orders._link}}"
  #     url: "@{link_generate_variable_defaults}
  #     {% assign link = link_generator._link %}
  #     {% assign drill_fields = 'sales_orders.ordered_month,sales_orders.sales_order_count'%}
  #     {% assign measure = sales_orders.sales_order_count %}
  #     @{link_line_chart_1_date_1_measure}
  #     @{link_generate_explore_url}
  #     "
  #   }
    # link: {
    #   label: "Order Line Details"
    #   icon_url: "/favicon.ico"
    #   url: "
    #   @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign qualify_filter_names = false %}
    #   {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}
    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
    #   {% assign default_filters_override = false %}
    #   @{link_generate_dashboard_url}
    #   "
    # }
  # }

  measure: return_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [order_category_code: "RETURN"]
    drill_fields: [header_details*]
  }

  measure: has_backorder_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [has_backorder: "Yes", order_category_code: "-RETURN"]
  }

  measure: blocked_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_blocked: "Yes", order_category_code: "-RETURN"]
    link: {
      label: "Source of Block"
      url: "{{dummy_drill_block_order_source._link}}&f[sales_orders.is_blocked]=Yes"
    }
    link: {
      label: "Show Blocked Orders"
      url: "{{ dummy_drill_orders_with_block._link}}&sorts=sales_orders.total_sales_amount_target_currency+desc&f[sales_orders.is_blocked]=Yes"
    }

    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters='is_blocked=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: cancelled_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_cancelled: "Yes", order_category_code: "-RETURN"]
  }

  measure: has_return_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [has_return_line: "Yes", order_category_code: "-RETURN"]
  }

  measure: fillable_sales_order_count {
    hidden: no
    type: count
    description: "Number of sales orders that can be met with the available inventory (none of items are backordered)."
    filters: [is_fillable: "Yes", order_category_code: "-RETURN"]
  }

  measure: fulfilled_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_fulfilled: "Yes", order_category_code: "-RETURN"]
  }

  measure: fulfilled_by_request_date_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_fulfilled_by_request_date : "Yes", order_category_code: "-RETURN"]
  }

  measure: fulfilled_by_promise_date_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_fulfilled_by_promise_date : "Yes", order_category_code: "-RETURN"]
  }

  measure: no_holds_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [has_hold: "No", order_category_code: "-RETURN"]
    drill_fields: [header_details*]
  }

  measure: non_cancelled_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_cancelled: "No", order_category_code: "-RETURN"]
  }

  measure: open_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [is_open: "Yes", order_category_code: "-RETURN"]
    # drill_fields: [header_details*]
  }

  measure: total_count_lines {
    hidden: yes
    type: sum
    sql: ${num_lines} ;;
  }

  measure: average_count_lines {
    hidden: yes
    type: average
    label: "Average Line Count per Order"
    description: "Average number of lines per order"
    sql: ${num_lines} ;;
    value_format_name: decimal_1
  }

  measure: max_open_closed_cancelled {
    hidden: yes
    type: max
    sql: ${open_closed_cancelled} ;;
  }

  measure: percent_of_sales_orders {
    hidden: no
    type: percent_of_total
    description: "Column Percent of Sales Orders"
    direction: "column"
    sql: ${sales_order_count} ;;
  }

#} end count measures

#########################################################
# Add Links to Order Percent Measures
# measures defined in and extended from sales_orders_common_count_measures_ext
#{
  measure: has_backorder_sales_order_percent {
    link: {
      label: "Show Top 20 Items with Highest Amount on Backorder"
      url: "{{dummy_backordered_by_item._link}}&f[sales_orders__lines.total_backordered_amount_target_currency]=%3E0&limit=20"
    }

    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters='is_backordered=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }

  }



  measure: has_return_sales_order_percent {
    link: {
      label: "Show Orders and Lines with Returns"
      url: "{{ dummy_drill_orders_with_return._link}}&f[sales_orders.has_return_line]=Yes"
    }

    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters='has_return=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  #} end measures

#########################################################
# Helper measures
# hidden measures used to support drills and links
#{

  measure: dummy_drill_monthly_orders {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [drill_monthly_orders*]
  }

  measure: dummy_drill_block_order_source {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [drill_block_order_source*]
  }

  measure: dummy_drill_orders_with_block {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [drill_orders_with_block*]
  }

  measure: dummy_drill_orders_with_return{
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [drill_orders_with_return*]
  }

  measure: dummy_backordered_by_item {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [backordered_by_item*]
  }

 #} end helper measures

#########################################################
# Sets
#{

  set: header_details {
    fields: [header_id,order_number,header_status,ordered_date,sold_to_customer_name, bill_to_customer_name, total_sales_amount_target_currency]
  }

  set: header_drill_from_dash {
    fields: [order_number, header_status, ordered_date, selected_customer_name, total_sales_amount_target_currency]
  }

  set: drill_orders_with_block {
    fields: [header_drill_from_dash*,has_backorder,is_held]
  }

  set: drill_monthly_orders {
    fields: [ordered_month, sales_order_count]
  }

  set: drill_block_order_source {
    fields: [has_backorder,is_held,sales_order_count,percent_of_sales_orders]
  }

  set: line_drill_from_dash {
    fields: [sales_orders__lines.line_id, sales_orders__lines.line_number,
            sales_orders__lines.item_part_number, sales_orders__lines.item_description,
            sales_orders__lines.ordered_quantity, sales_orders__lines.quantity_uom,
            sales_orders__lines.ordered_amount_target_currency,
            sales_orders__lines.has_return]
  }

  set: return_order_lines {
    fields: [sales_orders__lines__return_line_ids.return_line_id]
  }

  set: drill_orders_with_return {
    fields: [header_drill_from_dash*,line_drill_from_dash*,return_order_lines*]
  }

  set: backordered_by_item {
    fields: [sales_orders__lines.item_part_number, sales_orders__lines.item_description, sales_orders__lines.category_description, sales_orders__lines.total_backordered_amount_target_currency]
  }

#} end sets
}
