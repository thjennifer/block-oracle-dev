include: "/views/base/sales_cash_receipts.view"

view: +sales_cash_receipts {


  dimension: cash_receipt_id {
    primary_key: yes
    label: "Receipt ID"
    value_format_name: id
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

  dimension: invoice_id {
    value_format_name: id
  }

  dimension: ledger_id {
    value_format_name: id
  }

#########################################################
# Dates
# Fiscal Dates based on Ledger Date
#{

  dimension_group: receipt {}

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

  dimension_group: deposit {}

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

  dimension: amount {
    hidden: no
    group_label: "Amounts"
    label: "Amount Received (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_applied {
    hidden: no
    group_label: "Amounts"
    label: "Amount Applied (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: currency_code {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Source)"
    description: "Currency of the receipt transaction."
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

  dimension: amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Received ({{currency}}){%else%}Amount Received (Target Currency){%endif%}"
    sql: ${amount} * ${currency_conversion_rate}  ;;
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

#} end amount dimensions

  measure: count {hidden: yes}

  measure: receipt_count {
    type: count
    drill_fields: [receipts_detail*]
  }

  measure: total_amount_received_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Received ({{currency}}){%else%}Amount Received (Target Currency){%endif%}"
    sql: ${amount_target_currency} ;;
    # filters: [payment_class_code: "INV,CM"]
    value_format_name: decimal_2
    drill_fields: [receipts_detail*]
  }

  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: ${amount_applied_target_currency}  ;;
    value_format_name: decimal_2
    drill_fields: [receipts_detail*]
  }

set: receipts_detail {
  fields: [receipt_number, receipt_date, ledger_date, bill_to_customer_name,status,is_confirmed,amount_target_currency,amount_applied_target_currency]
}

}
