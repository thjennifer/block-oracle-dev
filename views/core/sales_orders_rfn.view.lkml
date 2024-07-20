include: "/views/base/sales_orders.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
include: "/views/core/sales_orders_common_count_measures_ext.view"


view: +sales_orders {
  extends: [sales_orders_common_dimensions_ext,sales_orders_common_count_measures_ext]

  fields_hidden_by_default: no

  dimension: header_id {
    hidden: no
    primary_key: yes
    value_format_name: id
  }

#########################################################
# Parameters
# parameter_target_currency to choose the desired currency into which the order currency should be converted
#{

  # parameter: parameter_customer_type {
  #   hidden: no
  #   type: unquoted
  #   view_label: "@{view_label_for_filters}"
  #   label: "Customer Type"
  #   description: "Select customer type to use for Customer Name and Country to display and filter by."
  #   allowed_value: {label: "Bill To" value: "bill" }
  #   allowed_value: {label: "Sold To" value: "sold" }
  #   allowed_value: {label: "Ship To" value: "ship" }
  #   default_value: "bill"
  # }

  # parameter: parameter_use_test_or_demo_data {
  #   hidden: no
  #   type: unquoted
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Use Test or Demo Data"
  #   allowed_value: {label: "test" value:"test"}
  #   allowed_value: {label: "demo" value: "demo"}
  #   default_value: "test"
  # }

  # parameter: parameter_use_test_or_demo_data {
  #   hidden: no
  #   type: unquoted
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Use Test or Demo Data"
  #   allowed_value: {label: "test" value:"CORTEX_ORACLE_EBS_REPORTING_VISION"}
  #   allowed_value: {label: "demo" value: "CORTEX_ORACLE_EBS_REPORTING"}
  #   default_value: "CORTEX_ORACLE_EBS_REPORTING_VISION"
  # }

  # filter: filter_ordered_date {
  #   hidden: no
  #   type: date
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   sql: {% condition %} ${ordered_date} {% endcondition %} ;;
  # }

#} end parameters

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

  dimension: num_lines {
    hidden: no
    label: "Number of Lines"
  }

#########################################################
# Business Unit / Order Source / Customer Dimensions
#{

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

  # dimension: selected_customer_name {
  #   group_label: "Selected Customer Type"
  #   label: "{% if _field._is_selected %}
  #           {% assign cust = parameter_customer_type._parameter_value %}
  #               {% if cust == 'bill' %}Bill To
  #               {% elsif cust == 'sold' %}Sold To
  #               {% elsif cust == 'ship' %}Ship To
  #               {% endif %}Customer
  #           {%else%}Selected Customer Name{%endif%}"
  #   sql:{% assign cust = parameter_customer_type._parameter_value %}
  #       {% if cust == 'bill' %}${bill_to_customer_name}
  #       {% elsif cust == 'sold' %}${sold_to_customer_name}
  #       {% elsif cust == 'ship' %}${ship_to_customer_name}
  #       {% endif %}
  #       ;;
  # }

  # dimension: selected_customer_country {
  #   group_label: "Selected Customer Type"
  #   label: "{% if _field._is_selected %}
  #   {% assign cust = parameter_customer_type._parameter_value %}
  #   {% if cust == 'bill' %}Bill To
  #   {% elsif cust == 'sold' %}Sold To
  #   {% elsif cust == 'ship' %}Ship To
  #   {% endif %}Country
  #   {%else%}Selected Customer Country{%endif%}"
  #   sql:{% assign cust = parameter_customer_type._parameter_value %}
  #       {% if cust == 'bill' %}${bill_to_customer_country}
  #       {% elsif cust == 'sold' %}${sold_to_customer_country}
  #       {% elsif cust == 'ship' %}${ship_to_customer_country}
  #       {% endif %}
  #       ;;
  # }

  # dimension: selected_customer_type {
  #   group_label: "Selected Customer Type"
  #   sql:  {% assign cust = parameter_customer_type._parameter_value %}
  #         '{{cust}}';;
  # }



#} end business unit / order source / customer dimensions

#########################################################
# Dates
#
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
#
#{

  dimension: header_status {
    hidden: no
    group_label: "Order Status"
  }

  dimension: has_backorder {
    hidden: no
    group_label: "Order Status"
    label: "Has Backorder"
    description: "Yes, if at least one order line does not enough available inventory to fill."
  }

  dimension: is_fillable {
    hidden: yes
    type: yesno
    group_label: "Order Status"
    description: "Yes, if sales order can be met with available inventory (no items are backordered)."
    # did not use ${is_backordered} = No becuase would count orders where ${TABLE}.IS_BACKORDERED = NULL
    sql: ${TABLE}.HAS_BACKORDER = FALSE ;;
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

  dimension: has_cancelled {
    hidden: no
    group_label: "Order Status"
    description: "At least one order line was cancelled. Use IS_CANCELLED to check if the entire order is cancelled."
  }

  dimension: is_fulfilled {
    hidden: no
    group_label: "Order Status"
    description: "Yes if all order lines are fulfilled (inventory is reserved and ready to be shipped)."
    # derived as LOGICAL_AND(Lines.IS_FULFILLED)
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
    description: "Yes indicates transaction was internal within the company."
  }

  dimension: is_open {
    hidden: no
    group_label: "Order Status"
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

  dimension: open_closed_cancelled {
    hidden: no
    type: string
    group_label: "Order Status"
    sql: CASE WHEN ${header_status} in ("CLOSED","CANCELLED") THEN INITCAP(${header_status})
              WHEN ${is_open} THEN "Open"
              WHEN ${is_open} = false THEN 'Closed' END;;
  }

  dimension: open_closed_cancelled_with_symbols {
    group_label: "Order Status with Symbols"
    hidden: no
    type: string
    sql: ${open_closed_cancelled} ;;
    html: {% if value == "Open" %}{%assign sym = "〇" %}{% assign color = "#4CBB17" %}
          {% elsif value == "Closed" %}{%assign sym = "◉"%}{% assign color = "#BFBDC1" %}
          {% elsif value == "Cancelled" %}{%assign sym = "X"%}{% assign color = "#EB9486" %}
            {% else %}
             {%assign sym = "" %}{% assign color = "#080808" %}
            {%endif%}<p style="color: {{color}}"><b> {{sym}} {{value}}</b> </p>;;
  }

  dimension: is_fulfilled_by_request_date {
    hidden: no
    type: yesno
    group_label: "Order Status"
    label: "Is On-Time & In-Full (OTIF)"
    description: "All lines of order are fulfilled by requested delivery date."
    sql: ${num_lines} > 0 AND ${num_lines} = ${num_lines_fulfilled_by_request_date} ;;
  }

  dimension: is_fulfilled_by_promise_date{
    hidden: no
    type: yesno
    group_label: "Order Status"
    label: "Is Fulfilled by Promise Date"
    description: "All lines of order are fulfilled by promised delivery date."
    sql: ${num_lines} > 0 AND ${num_lines} = ${num_lines_fulfilled_by_promise_date} ;;
  }

#} end header status

#########################################################
# Total Order Amounts
#{

  dimension: currency_code {
    hidden: no
    group_label: "Order Amounts"
    label: "Currency (Source)"
    description: "Currency of the order."
  }

  dimension: total_ordered_amount {
    hidden: no
    group_label: "Order Amounts"
    label: "Total Order Amount (Source Currency)"
    description: "Total amount for an order in source currency."
    value_format_name: decimal_2
  }

  dimension: total_sales_ordered_amount {
    hidden: no
    group_label: "Order Amounts"
    label: "Total Sales Amount (Source Currency)"
    description: "Total sales amount for an order in source currency. Includes only lines with line category code of 'ORDER'."
    value_format_name: decimal_2
    }

  dimension: total_ordered_amount_target_currency {
    hidden: no
    type: number
    group_label: "Order Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Order Amount ({{currency}}){%else%}Total Order Amount (Target Currency){%endif%}"
    description: "Total amount for an order in target currency."
    sql: COALESCE(${total_ordered_amount},0) * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_2
  }

  dimension: total_sales_ordered_amount_target_currency {
    hidden: no
    type: number
    group_label: "Order Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    description: "Total sales amount for an order in target currency. Includes only lines with line category code of 'ORDER'"
    sql: COALESCE(${total_sales_ordered_amount},0) * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_2
  }

#} end order amount


#########################################################
# Measures
#
#{

  measure: count {
    hidden: yes }

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

  measure: sales_order_count_formatted {
    hidden: yes
    type: number
    sql: ${sales_order_count} ;;
    # drill_fields: [header_drill_from_dash*]
    value_format_name: format_large_numbers_d1
    # drill_fields: [drill_monthly_orders*]
    link: {
      label: "Show Sales Orders by Month"
      # url: "{{dummy_drill_monthly_orders._link}}"
      url: "@{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign drill_fields = 'sales_orders.ordered_month,sales_orders.sales_order_count'%}
      {% assign measure = sales_orders.sales_order_count %}
      {% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#CE642D\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}
      @{link_generate_explore_url}
      "
    }
    link: {
      label: "Open Order Line Details Dashboard"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }
# {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=500&column_limit=15"


  measure: return_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [order_category_code: "RETURN"]
    drill_fields: [header_details*]
  }

  measure: order_count_with_details_link {
    hidden: yes
    type: number
    sql: ${order_count} ;;

    ## dynamic capture of filters with link
    # link: {
    #   label: "Open Order Details Dashboard"
    #   icon_url: "/favicon.ico"
    #   url: "
    #   @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign filters_mapping = '@{link_otc_shared_filters}' | strip_new_lines | append: '||across_sales_and_billing_summary_xvw.order_status|Order Status||deliveries.is_blocked|Is Blocked' %}

    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::otc_order_details' %}

    #   {% assign default_filters_override = false %}

    #   @{link_generate_dashboard_url}
    #   "
    # }
  }

  measure: has_backorder_sales_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    filters: [has_backorder: "Yes", order_category_code: "-RETURN"]
  }

  # measure: has_backorder_sales_order_percent {
  #   hidden: no
  #   type: number
  #   label: "Has Backorder Percent"
  #   description: "The percentage of sales orders that have at least one order line on backorder."
  #   sql: SAFE_DIVIDE(${has_backorder_sales_order_count},${order_count}) ;;
  #   value_format_name: percent_1
  # }

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
      url: "{{ dummy_drill_orders_with_block._link}}&sorts=sales_orders.total_sales_ordered_amount_target_currency+desc&f[sales_orders.is_blocked]=Yes"
    }
  }

  measure: has_return_sales_order_percent {
    link: {
      label: "Show Orders and Lines with Returns"
      url: "{{ dummy_drill_orders_with_return._link}}&f[sales_orders.has_return_line]=Yes"
    }

    link: {
      label: "Open Order Line Details Dashboard"
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
    label: "Fillable Orders"
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
    label: "Open Orders"
    description: "Number of sales orders that are open."
    filters: [is_open: "Yes", order_category_code: "-RETURN"]
    # drill_fields: [header_details*]
  }

  measure: ship_to_customer_count {
    hidden: no
    type: count_distinct
    sql: ${ship_to_customer_number} ;;
  }

  measure: total_count_lines {
    hidden: no
    type: sum
    sql: ${num_lines} ;;
  }

  measure: average_count_lines {
    hidden: no
    type: average
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
    type: percent_of_total
    sql: ${sales_order_count} ;;
  }

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

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }

#} end measures


  set: header_details {
    fields: [header_id,order_number,header_status,ordered_date,sold_to_customer_name, bill_to_customer_name, total_sales_ordered_amount_target_currency]
  }

  set: header_drill_from_dash {
    fields: [order_number, header_status, ordered_date, selected_customer_name, total_sales_ordered_amount_target_currency]
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

}
