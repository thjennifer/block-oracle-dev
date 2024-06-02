include: "/views/base/sales_orders.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
view: +sales_orders {
  extends: [sales_orders_common_dimensions_ext]
  label: "Sales Orders TEST"

  fields_hidden_by_default: yes


  sql_table_name: `@{GCP_PROJECT_ID}.{% parameter parameter_use_test_or_demo_data %}.SalesOrders` ;;

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CAST(${business_unit_id} as STRING)) ;;
  }

  dimension: header_id {
    hidden: no
    primary_key: yes
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

  parameter: parameter_use_test_or_demo_data {
    hidden: no
    type: unquoted
    view_label: "🔍 Filters & 🛠 Tools"
    label: "Use Test or Demo Data"
    allowed_value: {label: "test" value:"CORTEX_ORACLE_REPORTING_VISION"}
    allowed_value: {label: "demo" value: "CORTEX_ORACLE_REPORTING"}
    default_value: "CORTEX_ORACLE_REPORTING_VISION"
  }

  filter: filter_ordered_date {
    hidden: no
    type: date
    view_label: "🔍 Filters & 🛠 Tools"
    sql: {% condition %} ${ordered_date} {% endcondition %} ;;
  }

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

  dimension: ledger_id {hidden: yes}

  dimension: ledger_name {hidden: yes}

  dimension: sales_rep {hidden: no}

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

  dimension: is_backordered {
    hidden: no
    group_label: "Order Status"
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
    description: "Yes if all order lines are fulfilled."
    # derived as LOGICAL_AND(Lines.IS_FULFILLED)
  }

  dimension: is_on_time {
    hidden: no
    type: yesno
    description: "All lines of order fulfilled by promise date."
    sql: ${num_lines} = ${num_lines_fulfilled_by_promise_date} ;;
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

#} end header status


#########################################################
# Measures
#
#{

  measure: count {
    hidden: no
    label: "Total Sales Orders"
    drill_fields: [header_details*]
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




#} end measures
  set: header_details {
    fields: [header_id,order_number,header_status,ordered_date,sold_to_site_use_id, bill_to_site_use_id, total_order_amount]
  }


#########################################################
# TEST STUFF
# TO BE REMOVED
#{

  dimension: num_lines {
    hidden: no
    view_label: "TEST STUFF"
  }

  dimension: num_lines_fulfilled_by_promise_date {
    hidden: no
    view_label: "TEST STUFF"
  }


  measure: total_amount {
    hidden: no
    type: sum
    view_label: "TEST STUFF"
    sql: ${total_order_amount} ;;
  }

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


}
