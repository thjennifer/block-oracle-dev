include: "/views/core/sales_orders_rfn.view"

view: +sales_orders {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesOrders` ;;

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesOrders` ;;

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
  #   sql: ${ordered_amount} * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
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

  dimension: test_null_fiscal_period_num {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.FISCAL_PERIOD_NUM IS NULL ;;
  }

  dimension: test_null_ledger_id {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.LEDGER_ID IS NULL ;;
  }

#} end test stuff
}
