include: "/views/base/sales_payments.view"

view: +sales_payments {

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesPayments` ;;


  dimension: payment_schedule_id {
    primary_key: yes
  }

  dimension: cash_receipt_id {hidden: no}
  dimension: invoice_id {hidden: no}
  dimension: invoice_number {hidden: no}

#########################################################
# Business Unit / Order Source / Customer Dimensions
#{

  dimension: business_unit_id {hidden: no}

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: bill_to_site_use_id {
    group_label: "Bill to Customer"
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    # sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CONCAT("Bill to Customer Number: ",CAST(${bill_to_customer_number} AS STRING))) ;;
  }

  dimension: bill_to_customer_number {
    group_label: "Bill to Customer"
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end business unit / order source / customer dimensions




#########################################################
# Dates
#{

  dimension_group: ledger {}

  dimension: fiscal_gl_month {
    group_label: "Ledger Date"
    label: "Fiscal GL Month Number"
    description: "Fiscal GL month of the ledger date as an integer."
  }

  dimension: fiscal_gl_quarter {
    group_label: "Ledger Date"
    label: "Fiscal GL Quarter Number"
    description: "Fiscal GL Quarter of the ledger date as an integer."
  }

  dimension: fiscal_gl_quarter {
    group_label: "Ledger Date"
    label: "Fiscal GL Quarter Number"
    description: "Fiscal GL Quarter of the ledger date as an integer."
  }

  dimension: fiscal_gl_year {
    group_label: "Ledger Date"
    label: "Fiscal GL Year Number"
    description: "Fiscal GL Year of ledger date as an integer."
  }

  dimension: fiscal_gl_year_month {
    group_label: "Ledger Date"
    label: "Fiscal GL YYYY-MM"
    description: "Fiscal GL Year-Month formatted as YYYY-MM string."
    sql: CONCAT(CAST(${fiscal_gl_year} AS STRING),"-",LPAD(CAST(${fiscal_gl_month} AS STRING),2,'0'));;
  }

  dimension: fiscal_period_name {
    group_label: "Ledger Date"
  }
  dimension: fiscal_period_set_name {
    group_label: "Ledger Date"
  }
  dimension: fiscal_period_type {
    group_label: "Ledger Date"
  }

  dimension_group: discount {}
  dimension_group: due {}
  dimension_group: payment {}


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
# Amounts as dimensions including Currency Conversions
#{

  dimension: amount_adjusted {
    hidden: no
    group_label: "Amounts"
    label: "Amount Adjusted (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_applied {
    hidden: no
    group_label: "Amounts"
    label: "Amount Applied (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_credited {
    hidden: no
    group_label: "Amounts"
    label: "Amount Credited (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_discounted {
    hidden: no
    group_label: "Amounts"
    label: "Amount Discounted (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_due_original {
    hidden: no
    group_label: "Amounts"
    label: "Amount Due Original (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining {
    hidden: no
    group_label: "Amounts"
    label: "Amount Due Remaining (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: tax_original {
    hidden: no
    group_label: "Amounts"
    label: "Tax Amount Original (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: tax_remaining {
    hidden: no
    group_label: "Amounts"
    label: "Tax Amount Remaining (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: currency_code {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Source)"
    description: "Currency of the payment transaction."
  }

  dimension: currency_target {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Amounts"
    sql: IF(${currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Amounts"
    sql: ${currency_code} <> {% parameter otc_common_parameters_xvw.parameter_target_currency %} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  dimension: amount_adjusted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
    sql: ${amount_adjusted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: ${amount_applied} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Credited ({{currency}}){%else%}Amount Credited (Target Currency){%endif%}"
    sql: ${amount_credited} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Discounted ({{currency}}){%else%}Amount Discounted (Target Currency){%endif%}"
    sql: ${amount_discounted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Original ({{currency}}){%else%}Amount Due Original (Target Currency){%endif%}"
    sql: ${amount_due_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Remaining ({{currency}}){%else%}Amount Due Remaining (Target Currency){%endif%}"
    sql: ${amount_due_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Original ({{currency}}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Remaining ({{currency}}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

#} end amount dimensions


  measure: count {hidden:yes}

  measure: payment_count {
    hidden: no
    type: count
  }

#####REVIEW need to confirm the payment_class_code filters needed if any
  measure: total_amount_adjusted_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
    sql: ${amount_adjusted_target_currency} ;;
    # filters: [payment_class_code: "INV,CM"]
    value_format_name: decimal_2
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: ${amount_applied_target_currency}  ;;
    # filters: [payment_class_code: "PMT,CM"]
    # sql: ${amount_applied_target_currency} ;;
    # filters: [payment_class_code: "INV"]
    value_format_name: decimal_2
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Credited ({{currency}}){%else%}Amount Credited (Target Currency){%endif%}"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: decimal_2
  }

#####REVIEW need to confirm the payment_class_code filters needed if any
  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Discounted ({{currency}}){%else%}Amount Discounted (Target Currency){%endif%}"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Original ({{currency}}){%else%}Amount Due Original (Target Currency){%endif%}"
    sql: ${amount_due_original_target_currency} ;;
    # filters: [payment_class_code: "INV,CM"]
    value_format_name: decimal_2
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Remaining ({{currency}}){%else%}Amount Due Remaining (Target Currency){%endif%}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Original ({{currency}}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Remaining ({{currency}}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: decimal_2
  }







#########################################################
# TEST STUFF
#{

  dimension: is_null_business_unit_name {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.BUSINESS_UNIT_NAME IS NULL;;
  }

  dimension: is_null_bill_to_site_id {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.BILL_TO_SITE_USE_ID IS NULL;;
  }

 dimension: is_null_bill_to_customer_number {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER IS NULL;;
}

  dimension: is_null_bill_to_customer_name {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.BILL_TO_CUSTOMER_NAME IS NULL ;;
  }

  dimension: is_null_bill_to_customer_country {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY IS NULL;;
  }

  dimension: is_null_cash_receipt_id {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.CASH_RECEIPT_ID IS NULL;;
  }


  dimension: is_null_invoice_id {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.INVOICE_ID IS NULL;;
  }

  dimension: is_null_invoice_number {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.INVOICE_NUMBER IS NULL;;
  }

  dimension: invoice_number_2 {
    hidden: no
    view_label: "TEST STUFF"
    type: string
    sql: REGEXP_REPLACE(${TABLE}.INVOICE_NUMBER,'[^0-9]', '');;

  }

  dimension: invoice_number_length {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: LENGTH(${invoice_number}) ;;
  }


#}

   }
