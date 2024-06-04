include: "/views/base/sales_invoices.view"

view: +sales_invoices {

  sql_table_name: {% assign p = sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesInvoices` ;;


  dimension: invoice_id {
    hidden: no
    primary_key: yes
    description: "Distinct ID of invoice."
    value_format_name: id
  }

  dimension: invoice_number {
    description: "Invoice number. Note, this is a string data type and may not be a unique value."
  }

  dimension: invoice_type {
    group_label: "Invoice Type"
    label: "Invoice Type Code"
  }

  dimension: invoice_type_id {
    group_label: "Invoice Type"
    value_format_name: id
  }

  dimension: invoice_type_name {
    group_label: "Invoice Type"
    description: "Name or description of invoice type."
  }

  dimension: invoice_type_id_and_name {
    group_label: "Invoice Type"
    description: "Combination of ID and Name in form of 'ID: Name' "
    sql: CONCAT(${invoice_type_id},": ",${invoice_type_name}) ;;
  }

  dimension: bill_to_site_use_id {
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_number {
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_name {
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CONCAT("Bill To Customer Number: ",${bill_to_customer_number})) ;;
  }

  dimension: bill_to_customer_country {
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: business_unit_name {
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ",${business_unit_id})) ;;
  }

  dimension: ledger_id {
    value_format_name: id
  }

  dimension: is_complete {

  }

  dimension: currency_code {
    label: "Currency Code (Source)"
    description: "Currency code of the invoice transaction."
  }
#########################################################
# Dates
#
#{

  dimension_group: invoice {
    timeframes: [raw,date,week,month,quarter,year]
  }

  dimension_group: creation {
    timeframes: [raw,date,week,month,quarter,year]
  }

  dimension_group: last_update {
    timeframes: [raw,date,week,month,quarter,year]
  }

#} end dates

#########################################################
# Measures
#
#{

  measure: count {
    hidden: yes
  }

  measure: invoice_count {
    type: count
  }

#} end measures

#########################################################
# TEST STUFF
#
#{
  dimension: test_invoice_month {
    view_label: "TEST STUFF"
    type: number
    sql: ${TABLE}.INVOICE_MONTH ;;
  }

  dimension: test_invoice_quarter {
    view_label: "TEST STUFF"
    type: number
    sql: ${TABLE}.INVOICE_QUARTER ;;
  }

  dimension: test_invoice_year {
    view_label: "TEST STUFF"
    type: number
    sql: ${TABLE}.INVOICE_YEAR ;;
  }

#}
 }
