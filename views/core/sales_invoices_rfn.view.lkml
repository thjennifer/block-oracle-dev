include: "/views/base/sales_invoices.view"

view: +sales_invoices {

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
    sql: COALESCE(COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CONCAT("Bill To Customer Number: ",${bill_to_customer_number})),"Unknown") ;;
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
    hidden: no
    description: "Yes if invoice is complete else No."
  }

  dimension: is_complete_with_symbols {
    hidden: no
    description: "✅ if invoice is complete."
    sql: COALESCE(${is_complete},false) ;;
    html: @{symbols_for_yes} ;;
  }

#########################################################
# Dates
#{

  dimension_group: invoice {
    timeframes: [raw, date, week, month, quarter, year]
  }

  dimension: invoice_month_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Month Num"
    description: "Invoice Month as Number 1 to 12"
  }

  dimension: invoice_quarter_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Quarter Num"
    description: "Invoice Quarter as Number 1 to 4"
  }

  dimension: invoice_year_num {
    hidden: no
    group_label: "Invoice Date"
    group_item_label: "Year Num"
    description: "Invoice Year as Integer"
    value_format_name: id
  }

  dimension_group: exchange {}

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
# Invoice Total Amounts as Dimensions and with Currency Conversion
#
#{


  dimension: currency_code {
    group_label: "Amounts"
    label: "Currency Code (Source)"
    description: "Currency code of the invoice transaction."
  }

  dimension: target_currency_code {
    type: string
    group_label: "Amounts"
    label: "Currency Code (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    type: number
    group_label: "Amounts"
    sql: IF(${currency_code} = ${target_currency_code}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
  }

  dimension: is_incomplete_conversion {
    type: yesno
    group_label: "Amounts"
    sql: ${currency_code} <> ${target_currency_code} AND ${currency_conversion_sdt.from_currency} is NULL ;;
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
    label: "Invoice Amount (Source Currency)"
  }

  dimension: total_revenue_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Invoice Net Revenue Amount (@{label_get_target_currency}){%else%}Invoice Net Revenue Amount (Target Currency){%endif%}"
    description: "Total amount recognized as revenue for accounting purposes for the entire invoice (in target currency)."
    sql: ${total_revenue_amount} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: total_transaction_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Invoice Amount (@{label_get_target_currency}){%else%}Invoice Amount (Target Currency){%endif%}"
    description: "Total transaction amount of invoice in target currency."
    sql: ${total_transaction_amount} * ${currency_conversion_rate}   ;;
    value_format_name: decimal_2
  }

  dimension: total_tax_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Invoice Tax Amount (@{label_get_target_currency}){%else%}Invoice Tax Amount (Target Currency){%endif%}"
    description: "Total tax amount of invoice in target currency."
    sql: ${total_tax_amount} * ${currency_conversion_rate}  ;;
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

  measure: invoice_count_formatted {
    hidden: yes
    type: count
    group_label: "Formatted for Large Numbers"
    value_format_name: format_large_numbers_d1
    drill_fields: [invoice_header_details*]
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

  # dummy field used for dynamic drill links
  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }



#} end measures

  set: invoice_header_details {
    fields: [ invoice_id,
              invoice_number,
              invoice_date,
              invoice_type_name,
              total_transaction_amount_target_currency,
              total_tax_amount_target_currency]
  }


}
