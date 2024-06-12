include: "/views/base/sales_invoices.view"

view: +sales_invoices {

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesInvoices` ;;


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

#########################################################
# Dates
#{

  dimension_group: invoice {
    timeframes: [raw, date, week, month, quarter, year]
  }

  dimension_group: creation {
    hidden: no
    timeframes: [raw, date, time]
    description: "Creation date of record in Oracle source table."
  }

  dimension_group: last_update {
    hidden: no
    timeframes: [raw, date, time]
    description: "Last update date of record in Oracle source table."
  }

#} end dates

#########################################################
# Invoice Total Amounts as Dimensions and with Currency Conversion
#
#{


  dimension: currency_code {
    group_label: "Amounts"
    label: "Currency Code (Source)"
    description: "Currency code of the invoice transaction."
  }

  dimension: total_revenue_amount {
    group_label: "Amounts"
    label: "Invoice Revenue Amount (Source Currency)"
  }

  dimension: total_tax_amount {
    group_label: "Amounts"
    label: "Invoice Tax Amount (Source Currency)"
  }

  dimension: total_transaction_amount {
    group_label: "Amounts"
    label: "Invoice Transaction Amount (Source Currency)"
  }

  dimension: total_revenue_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Invoice Revenue Amount ({{currency}}){%else%}Invoice Revenue Amount (Target Currency){%endif%}"
    description: "Total amount recognized as revenue for accounting purposes for the entire invoice (in target currency)."
    sql: ${total_revenue_amount} * IF(${currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: total_transaction_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Invoice Transaction Amount ({{currency}}){%else%}Invoice Transactions Amount (Target Currency){%endif%}"
    description: "Total transaction amount of invoice in target currency."
    sql: ${total_transaction_amount} * IF(${currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: total_tax_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Invoice Tax Amount ({{currency}}){%else%}Invoice Tax Amount (Target Currency){%endif%}"
    description: "Total tax amount of invoice in target currency."
    sql: ${total_tax_amount} * IF(${currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

#} end invoice amounts as dimensions



#########################################################
# Measures
#
#{

  measure: count {
    hidden: yes
  }

  measure: invoice_count {
    type: count
    drill_fields: [invoice_header_details*]
  }

#} end measures

set: invoice_header_details {
  fields: [invoice_id,invoice_number,invoice_date,invoice_type_name, total_revenue_amount_target_currency, total_tax_amount_target_currency]
}

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

  measure: count_distinct_ledger_id {
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${ledger_id},-1) ;;
  }

  dimension: invoice_number_length {
    view_label: "TEST STUFF"
    type: number
    sql: LENGTH(${invoice_number}) ;;
  }

#}
 }
