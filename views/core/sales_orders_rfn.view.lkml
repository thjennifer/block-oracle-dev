include: "/views/base/sales_orders.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
include: "/views/core/sales_orders_common_measures_ext.view"

view: +sales_orders {
  extends: [sales_orders_common_dimensions_ext,sales_orders_common_measures_ext]

  fields_hidden_by_default: yes

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter parameter_use_test_or_demo_data %}.SalesOrders` ;;

  sql_table_name: {% assign p = sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
                  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
                  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesOrders` ;;

  # dimension: business_unit_name {
  #   hidden: no
  #   sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CAST(${business_unit_id} as STRING)) ;;
  # }

  dimension: header_id {
    hidden: no
    primary_key: yes
    value_format_name: id
  }

#########################################################
# Parameters
# parameter_target_currency to choose the desired currency into which the order currency should be converted
#{

  # parameter: parameter_target_currency {
  #   hidden: no
  #   type: string
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Target Currency"
  #   suggest_explore: currency_rate_md
  #   suggest_dimension: currency_rate_md.to_currency
  #   full_suggestions: yes
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

  dimension: currency_code {
    hidden: no
    label: "Currency (Source)"
    description: "Currency of the order."
  }

  dimension: ledger_id {
    hidden: no
    value_format_name: id
    }

  dimension: ledger_name {hidden: no}

  dimension: sales_rep {hidden: no}

  dimension: num_lines {
    hidden: no
    label: "Number of Lines"
  }

#########################################################
# Business Unit and Order Source Dimensions
#{

  dimension: business_unit_id {hidden: no}

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
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CONCAT("Bill to Customer Number: ",CAST(${bill_to_customer_number} AS STRING))) ;;
  }

    dimension: bill_to_customer_country {
      sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
    }

#} end business unit and order source dimensions

#########################################################
# Dates
#
#{

  dimension_group: ordered {
    hidden: no
    timeframes: [raw, date, week, month, quarter, year, yesno]
  }

  dimension_group: booked {
    hidden: no
    timeframes: [raw, date, week, month, quarter, year, yesno]
    }

  dimension_group: booked {
    hidden: no
    timeframes: [raw, date, week, month, quarter, year, yesno]
  }

  dimension_group: request_date {
    hidden: no
    label: "Request"
    timeframes: [raw, date, week, month, quarter, year, yesno]
  }

  dimension: fiscal_month {
    hidden: no
    group_label: "Ordered Date"
   }
  dimension: fiscal_period_name {
    hidden: no
    group_label: "Ordered Date"
  }
  dimension: fiscal_period_set_name {
    hidden: no
    group_label: "Ordered Date"
  }
  dimension: fiscal_period_type {
    hidden: no
    group_label: "Ordered Date"
  }
  dimension: fiscal_quarter {
    hidden: no
    group_label: "Ordered Date"
  }
  dimension: fiscal_year {
    hidden: no
    group_label: "Ordered Date"
  }

  dimension_group: creation {
    hidden: yes
    timeframes: [raw, date, week, month, quarter, year, yesno]
  }

  dimension_group: last_update {
    hidden: yes
    timeframes: [raw, date, week, month, quarter, year, yesno]
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

  dimension: has_return_line {
    hidden: no
    group_label: "Order Status"
    description: "Sales order has at least 1 line with a return."
  }

  dimension: is_blocked {
    hidden: no
    type: yesno
    group_label: "Order Status"
    description: "Order is either held or backordered."
    sql: ${has_backorder} OR ${is_held} ;;
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
    group_label: "Order Status"
    hidden: no
    type: string
    sql: ${open_closed_cancelled} ;;
    html: {% if value == "Open" %}{%assign sym = "〇" %}{% assign color = "#98B6B1" %}
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

  dimension: total_order_amount {
    hidden: no
    label: "Total Order Amount (Source Currency)"
    description: "Total amount for an order in source currency."
    value_format_name: decimal_2
  }

  dimension: total_order_amount_target_currency {
    hidden: no
    type: number
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Order Amount ({{currency}}){%else%}Total Order Amount (Target Currency){%endif%}"
    description: "Total amount for an order in target currency."
    sql: COALESCE(${total_order_amount},0) * IF(${sales_orders.currency_code} = {% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
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
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
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

  measure: has_backorder_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [has_backorder: "Yes"]
  }

  # measure: has_backorder_order_percent {
  #   hidden: no
  #   type: number
  #   label: "Has Backorder Percent"
  #   description: "The percentage of sales orders that have at least one order line on backorder."
  #   sql: SAFE_DIVIDE(${has_backorder_order_count},${order_count}) ;;
  #   value_format_name: percent_1
  # }

  measure: blocked_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [is_blocked: "Yes"]
  }

  measure: cancelled_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [is_cancelled: "Yes"]
  }

  measure: has_return_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [has_return_line: "Yes"]
  }

  measure: fillable_order_count {
    hidden: no
    type: count
    label: "Fillable Orders"
    description: "Number of sales orders that can be met with the available inventory (none of items are backordered)."
    filters: [is_fillable: "Yes"]
  }

  measure: fulfilled_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [is_fulfilled: "Yes"]
  }

  measure: fulfilled_by_request_date_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [is_fulfilled_by_request_date : "Yes"]
  }

  measure: fulfilled_by_promise_date_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [is_fulfilled_by_promise_date : "Yes"]
  }

  measure: no_holds_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [has_hold: "No"]
    drill_fields: [header_details*]
  }

  measure: non_cancelled_order_count {
    hidden: no
    type: count
    #label defined in sales_orders_common_measures_ext
    #description defined in sales_orders_common_measures_ext
    filters: [is_cancelled: "No"]
  }

  measure: open_order_count {
    hidden: no
    type: count
    label: "Open Orders"
    description: "Number of sales orders that are open."
    filters: [is_open: "Yes"]
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




#} end measures
  set: header_details {
    fields: [header_id,order_number,header_status,ordered_date,sold_to_customer_name, bill_to_customer_name, total_order_amount_target_currency]
  }


#########################################################
# TEST STUFF
# TO BE REMOVED
#{

  # dimension: num_lines {
  #   hidden: no
  #   view_label: "TEST STUFF"
  # }


  # dimension: is_partial_fulfillment {
  #   hidden: no
  #   type: yesno
  #   view_label: "TEST STUFF"
  #   sql: ${num_lines_fulfilled_by_promise_date} > 1 AND ${num_lines} <> ${num_lines_fulfilled_by_promise_date} ;;
  # }

  dimension: num_lines_fulfilled_by_promise_date {
    hidden: no
    view_label: "TEST STUFF"
  }




  # dimension: ordered_amount_target_currency {
  #   hidden: yes
  #   type: number
  #   group_label: "Currency Conversion"
  #   sql: ${ordered_amount} * IF(${sales_orders.currency_code} = {% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
  #   value_format_name: decimal_2
  # }

  measure: date_count {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${ordered_raw} ;;
  }

  measure: count_country {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${ship_to_customer_country} ;;
  }

  parameter: sold_ship_bill {
    hidden: no
    type: unquoted
    view_label: "TEST STUFF"
    allowed_value: {label: "Bill To" value: "bi" }
    allowed_value: {label: "Sold To" value: "so" }
    allowed_value: {label: "Ship To" value: "sh" }
    default_value: "so"
  }

  dimension: customer_number_is_null {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign c = sold_ship_bill._parameter_value %}
         CASE WHEN --{{c}}
          {% if c == "bi"%}${bill_to_customer_number}
          {% elsif c == "so" %}${sold_to_customer_number}
          {% else %}${ship_to_customer_number}
          {% endif %} is null
          THEN 'yes' else 'no' end;;
  }


  dimension: customer_name_is_null {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign c = sold_ship_bill._parameter_value %}
         CASE WHEN --{{c}}
          {% if c == "bi"%}${bill_to_customer_name}
          {% elsif c == "so" %}${sold_to_customer_name}
          {% else %}${ship_to_customer_name}
          {% endif %} is null
          THEN 'yes' else 'no' end;;
  }

  dimension: customer_country_is_null {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign c = sold_ship_bill._parameter_value %}
         CASE WHEN --{{c}}
          {% if c == "bi"%}${bill_to_customer_country}
          {% elsif c == "so" %}${sold_to_customer_country}
          {% else %}${ship_to_customer_country}
          {% endif %} is null
          THEN 'yes' else 'no' end;;
  }

  measure: distinct_customer_count {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql:  {% assign c = sold_ship_bill._parameter_value %}
          {% if c == "bi"%}${bill_to_site_use_id}
          {% elsif c == "so" %}${sold_to_site_use_id}
          {% else %}${ship_to_site_use_id}
          {% endif %}
      ;;
  }

  dimension: is_pre_2021_order {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: EXTRACT(YEAR FROM ${ordered_raw}) < 2021;;
  }

  dimension: test_ordered_month {
    hidden: no
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDERED_MONTH ;;
  }

  dimension: test_ordered_quarter {
    hidden: no
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDERED_QUARTER ;;
  }

  dimension: test_ordered_year {
    hidden: no
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDERED_YEAR ;;
  }

  dimension: test_null_business_unit_name {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.BUSINESS_UNIT_NAME IS NULL ;;
  }

  dimension: test_null_fiscal_month {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.FISCAL_MONTH IS NULL ;;
  }

  dimension: test_null_ledger_id {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.LEDGER_ID IS NULL ;;
  }

#} end test stuff
   }
