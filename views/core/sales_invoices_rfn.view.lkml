#########################################################{
# PURPOSE
# The SalesInvoices table and its corresponding View sales_invoices
# captures invoice details by invoice_id
#
# SOURCES
# Refines View sales_invoices
# Extends view otc_common_currency_fields_ext.view
#
# REFERENCED BY
# Explore sales_invoices
#
# EXTENDED FIELDS
#    target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion
#
# REPEATED STRUCTS
# - Also includes Repeated Struct for LINES. See view sales_invoices__lines for
#   invoice line dimensions and measures.
#
# NOTES
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Includes fields which reference view CURRENCY_CONVERSION_SDT so this view must be included in the
#   Sales Invoices Explore.
#########################################################}

include: "/views/base/sales_invoices.view"
include: "/views/core/otc_common_currency_fields_ext.view"

view: +sales_invoices {

  fields_hidden_by_default: yes

  extends: [otc_common_currency_fields_ext]

  dimension: invoice_id {
    hidden: no
    primary_key: yes
    description: "Distinct ID of invoice"
    value_format_name: id
  }

  dimension: invoice_number {
    hidden: no
    description: "Invoice number. Note, this is a string data type and may not be a unique value"
  }

  dimension: business_unit_id {
    hidden: no
    value_format_name: id
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ",${business_unit_id})) ;;
  }

  dimension: ledger_id {
    hidden: no
    description: "ID of ledger or set of books"
    value_format_name: id
  }

  dimension: ledger_name {
    hidden: no
    description: "Name of ledger or set of books"
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

  dimension_group: invoice {
    hidden: no
  }

#--> invoice month_num, quarter_num and year_num in table so
#--> adding to Invoice Date group label to appear with other dates
  dimension: invoice_month_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Month Number"
    description: "Invoice Month as Number 1 to 12"
  }

  dimension: invoice_quarter_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Quarter Number"
    description: "Invoice Quarter as Number 1 to 4"
  }

  dimension: invoice_year_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Year Number"
    description: "Invoice Year as Integer"
    value_format_name: id
  }

  dimension_group: exchange {
    hidden: no
    description: "Date the exchange rate is calculated. If missing, invoice date is used"
  }

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    description: "Creation timestamp of record in Oracle source table"
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    description: "Last update timestamp of record in Oracle source table"
  }

#} end dates

#########################################################
# DIMENSIONS: Invoice Type & Status
#{

  dimension: invoice_type {
    hidden: no
    group_label: "Invoice Type"
    label: "Invoice Type Code"
  }

  dimension: invoice_type_id {
    hidden: no
    group_label: "Invoice Type"
    value_format_name: id
  }

  dimension: invoice_type_name {
    hidden: no
    group_label: "Invoice Type"
    description: "Name or description of invoice type"
  }

  dimension: invoice_type_id_and_name {
    hidden: no
    group_label: "Invoice Type"
    description: "Combination of ID and Name in form of 'ID: Name' "
    sql: CONCAT(${invoice_type_id},": ",${invoice_type_name}) ;;
  }

  dimension: is_complete {
    hidden: no
    description: "Yes if invoice is complete else No"
  }

  dimension: is_complete_with_symbols {
    hidden: no
    description: "✅ if invoice is complete"
    sql: COALESCE(${is_complete},false) ;;
    html: @{html_symbols_for_yes} ;;
  }

#} end invoice type and status

#########################################################
# DIMENSIONS: Currency Conversion
#{
# target_currency_code and is_incomplete_conversion extended from
# otc_common_currency_fields_ext

  dimension: currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Source)"
    description: "{%- assign v = _view._name | split: '_' -%}Currency of the {{v[1] | remove: 's' | append: '.'}}"
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
# DIMENSIONS: Invoices Totals
#{

  dimension: total_revenue_amount {
    hidden: no
    group_label: "Invoice Totals"
    label: "Invoice Revenue Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: total_tax_amount {
    hidden: no
    group_label: "Invoice Totals"
    label: "Invoice Tax Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: total_transaction_amount {
    hidden: no
    group_label: "Invoice Totals"
    label: "Invoice Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: total_revenue_amount_target_currency {
    hidden: no
    type: number
    group_label: "Invoice Totals"
    label: "@{label_defaults}{%- assign field_name = 'Invoice Revenue Amount' -%}@{label_currency_if_selected}"
    description: "Total amount recognized as revenue for accounting purposes for the entire invoice (in target currency)"
    sql: ${total_revenue_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: total_tax_amount_target_currency {
    hidden: no
    type: number
    group_label: "Invoice Totals"
    label: "@{label_defaults}{%- assign field_name = 'Invoice Tax Amount' -%}@{label_currency_if_selected}"
    description: "Total tax amount of invoice in target currency"
    sql: ${total_tax_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: total_transaction_amount_target_currency {
    hidden: no
    type: number
    group_label: "Invoice Totals"
    label: "@{label_defaults}{%- assign field_name = 'Invoice Amount' -%}@{label_currency_if_selected}"
    description: "Total transaction amount of invoice in target currency"
    sql: ${total_transaction_amount} * ${currency_conversion_rate}   ;;
    value_format_name: decimal_2
  }

#} end invoice totals as dimensions

#########################################################
# MEASURES: Counts
#{

  measure: invoice_count {
    hidden: no
    type: count
    drill_fields: [invoice_header_details*]
  }

#--> format as Large Number for dashboard display
  measure: invoice_count_formatted {
    hidden: no
    type: number
    sql: ${invoice_count} ;;
    # group_label: "Formatted for Large Numbers"
    value_format_name: format_large_numbers_d1
    drill_fields: [invoice_header_details*]
#--> link to Invoice Line Details dashboard
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'%}
      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details' %}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

#} end count measures

#########################################################
# MEASURES: Helper
#{
# used to support links and drills; hidden from explore

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }

#} end helper measures

#########################################################
# SETS
#{
  set: invoice_header_details {
    fields: [ invoice_id,
              invoice_number,
              invoice_date,
              invoice_type_name,
              total_transaction_amount_target_currency,
              total_tax_amount_target_currency]
  }
#} end sets

}
