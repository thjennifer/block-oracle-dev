#########################################################{
# PURPOSE
# The SalesAppliedReceivables table and its corresponding View
# sales_applied_receivables captures information about
# cash receipts and applied amounts.
#
# SOURCES
# Refines View sales_applied_receivables
# Extends Views:
#   otc_common_fiscal_gl_dates_ext
#   otc_common_currency_fields_ext
#   sales_applied_receivables_common_amount_measures_ext
#
# REFERENCED BY
#   Explore sales_applied_receivables
#
# EXTENDED FIELDS
#   fiscal_gl_date, fiscal_gl_period_name, etc...
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion
#   total_amount_applied_target_currency, total_ammount_received_target_currency, etc...
#
# NOTES
# - Includes attributes about original invoice including invoice date and amount
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Includes fields which reference CURRENCY_CONVERSION_SDT so this view must be included in the
#   Sales Applied Receivables Explore.
#########################################################}

include: "/views/base/sales_applied_receivables.view"
include: "/views/core/otc_common_fiscal_gl_dates_ext.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_applied_receivables_common_amount_measures_ext.view"

view: +sales_applied_receivables {
  fields_hidden_by_default: yes
  extends: [otc_common_fiscal_gl_dates_ext, otc_common_currency_fields_ext, sales_applied_receivables_common_amount_measures_ext]

  dimension: receivable_application_id {
    primary_key: yes
    value_format_name: id
  }

  dimension: business_unit_id {
    hidden: no
    value_format_name: id
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: application_type {
    hidden: no
  }

  dimension: ledger_id {
    hidden: no
    # description: "ID of ledger or set of books"
    value_format_name: id
  }

  dimension: ledger_name {
    hidden: no
    # description: "Name of ledger or set of books"
  }

#########################################################
# DIMENSIONS: Customer
#{
  dimension: bill_to_site_use_id {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_number {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end customer dimensions

#########################################################
# DIMENSIONS: Dates
#{
# Fiscal Dates extended from otc_common_fiscal_gl_dates_ext and grouped under Ledger Date

  dimension_group: event {
    hidden: no
  }

  dimension: event_month_num {
    hidden: no
    group_label: "Event Date"
    group_item_label: "Month Number"
    # description: "Event Month as Number 1 to 12"
  }

  dimension: event_quarter_num {
    hidden: no
    group_label: "Event Date"
    group_item_label: "Quarter Number"
    # description: "Event Quarter as Number 1 to 4"
  }

  dimension: event_year_num {
    hidden: no
    group_label: "Event Date"
    group_item_label: "Year Number"
    # description: "Event Year as Integer"
    value_format_name: id
  }

  dimension_group: ledger {
    hidden: no
  }

  dimension_group: exchange {
    hidden: no
    description: "Date to use for exchange rate calculation. If the exchange date is not populated, the event date is used."
  }

  dimension_group: invoice__invoice {
    hidden: no
    label: "Invoice"
  }

  dimension_group: cash_receipt__deposit {
    hidden: no
  }

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    # description: "Creation timestamp of record in Oracle source table"
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    # description: "Last update timestamp of record in Oracle source table"
  }

#} end dates

#########################################################
# DIMENSIONS: Currency Conversion
#{
# target_currency_code and is_incomplete_conversion extended from
# otc_common_currency_fields_ext

  dimension: currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Source)"
    description: "Currency of the applied receivable"
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
# DIMENSIONS: Invoice Details
#{
# Details of Invoice for which payments are applied

  dimension: invoice_id {
    hidden: no
    group_label: "Invoice Details"
    value_format_name: id
  }

  dimension: invoice__invoice_number {
    hidden: no
    group_label: "Invoice Details"
    label: "Invoice Number"
  }

  dimension: invoice__invoice_type {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: "Invoice Type"
  }

  dimension: invoice__invoice_type_id {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: "Invoice Type ID"
  }

  dimension: invoice__invoice_type_name {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: "Invoice Type Name"
  }

  dimension: invoice__is_complete {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: "Is Complete"
  }

  #} end invoice details dimensions

#########################################################
# DIMENSIONS: Cash Receipt Details
#{
# Details of Cash Receipts

  dimension: cash_receipt_id {
    hidden: no
    group_label: "Cash Receipt Details"
    label: "Receipt ID"
    value_format_name: id
  }

  dimension: cash_receipt__receipt_number {
    hidden: no
    group_label: "Cash Receipt Details"
    group_item_label: ""
    label: "Receipt Number"
    value_format_name: id
  }

  dimension: cash_receipt__is_confirmed {
    hidden: no
    group_label: "Cash Receipt Details"
    group_item_label: "Is Confirmed"
  }

  dimension: cash_receipt__status {
    hidden: no
    sql: ${TABLE}.CASH_RECEIPT.STATUS ;;
    group_label: "Cash Receipt Details"
    group_item_label: "Status"
  }

  dimension: cash_receipt_history_id {
    group_label: "Cash Receipt Details"
    value_format_name: id
  }

#} end cash receipt details

#########################################################
# DIMENSIONS: Amounts
#{

#--> displayed as measure
  dimension: amount_applied {
    hidden: yes
    label: "Amount Applied (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: cash_receipt__amount {
    hidden: yes
    group_label: "Cash Receipt Details"
    group_item_label: ""
    label: "Cash Receipt Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: invoice__total_revenue_amount {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: ""
    label: "Invoice Revenue Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: invoice__total_tax_amount {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: ""
    label: "Invoice Tax Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: invoice__total_transaction_amount {
    hidden: no
    group_label: "Invoice Details"
    group_item_label: ""
    label: "Invoice Amount (Source Currency)"
    value_format_name: decimal_2
  }

#--> displayed as measure
  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${amount_applied}*${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: cash_receipt_amount_target_currency {
    hidden: no
    type: number
    group_label: "Cash Receipt Details"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${cash_receipt__amount}*${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: invoice_revenue_amount_target_currency {
    hidden: no
    type: number
    group_label: "Invoice Details"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${invoice__total_revenue_amount} * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: invoice_tax_amount_target_currency {
    hidden: no
    type: number
    group_label: "Invoice Details"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${invoice__total_tax_amount} * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: invoice_transaction_amount_target_currency {
    hidden: no
    type: number
    group_label: "Invoice Details"
    label: "@{label_currency_defaults}{%- assign field_name = 'Invoice Amount' -%}@{label_currency_if_selected}"
    sql: ${invoice__total_transaction_amount} * ${currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

#} end amount dimensions

#########################################################
# MEASURES: Amounts
#{
  measure: total_amount_applied_in_source_currency {
    hidden: no
    type: sum
    label: "Total Amount Applied in Source Currency"
    description: "Sum of amount applied in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_applied_receivables.currency_code._is_selected -%}${amount_applied}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_applied_receivables.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_amount_received_in_source_currency {
    hidden: no
    type: sum
    label: "Total Amount Received in Source Currency"
    description: "Sum of cash receipt amount in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_applied_receivables.currency_code._is_selected -%}${cash_receipt__amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_applied_receivables.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_amount_applied_target_currency {
    drill_fields: [application_details*]
  }

  measure: total_amount_received_target_currency {
    drill_fields: [application_details*]
  }

  measure: total_amount_applied_target_currency_formatted {
    drill_fields: [application_details*]
  }

  measure: total_amount_received_target_currency_formatted {
    drill_fields: [application_details*]
  }

#} end amount measures

#########################################################
# MEASURES: Misc
#{
   measure: application_count {
    hidden: no
    type: count
    drill_fields: [application_details*]
  }

#} end misc measures

#########################################################
# SETS
#{
  set: application_details {
    fields: [receivable_application_id,application_type, event_date,total_amount_applied_target_currency,
             invoice__invoice_number, invoice__invoice_date, invoice_transaction_amount_target_currency,
             cash_receipt_id, cash_receipt__receipt_number, cash_receipt__deposit_date,cash_receipt_amount_target_currency]
  }
#} end sets
   }
