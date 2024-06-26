include: "/views/base/sales_invoices__lines.view"
include: "/views/core/otc_derive_common_product_fields_ext.view"

view: +sales_invoices__lines {
    extends: [otc_derive_common_product_fields_ext]

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${line_id}) ;;
  }

  dimension: line_id {}

  dimension: line_description {}

  dimension: is_intercompany {
    description: "Yes indicates transaction was internal within the company."
  }


#########################################################
# Order Details
#
#{

  dimension: order_header_id {
    group_label: "Order Details"
  }

  dimension: order_line_id {
    primary_key: no
    group_label: "Order Details"
    value_format_name: id
    }

  dimension: order_source_id {
    group_label: "Order Details"
  }

  dimension: order_source_name {
    group_label: "Order Details"
  }
#} end order details



#########################################################
# Dates
#
#{

  dimension_group: ledger {
    timeframes: [raw, date, week, month, quarter, year]
  }

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
# Item Dimensions
# Item Descriptions and Categories extended from otc_derive_common_product_fields_ext
#{

  dimension: inventory_item_id {}

  dimension: item_part_number {}

  dimension: unit_discount_price {
    group_label: "Item Prices and Discounts"
    description: "Unit List Price minus Unit Selling Price"
    sql: ROUND(${TABLE}.UNIT_DISCOUNT_PRICE,2) ;;
    value_format_name: decimal_2
  }

  dimension: unit_list_price {
    group_label: "Item Prices and Discounts"
    sql: ROUND(${TABLE}.UNIT_LIST_PRICE,2) ;;
    value_format_name: decimal_2
  }

  dimension: unit_selling_price {
    group_label: "Item Prices and Discounts"
    sql: ROUND(${TABLE}.UNIT_SELLING_PRICE,2) ;;
    value_format_name: decimal_2
  }

  dimension: is_discount_selling_price {
    type: yesno
    group_label: "Item Prices and Discounts"
    description: "Yes if line item was sold at a discounted price."
    sql: ${unit_discount_price} <> 0 ;;
  }

  dimension: percent_discount {
    type: number
    group_label: "Item Prices and Discounts"
    description: "Perecent discount off item price."
    sql: 1 - SAFE_DIVIDE(${unit_selling_price},${unit_list_price}) ;;
    value_format_name: percent_1
  }

  dimension: unit_list_price_target_currency {
    group_label: "Item Prices and Discounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Unit List Price ({{currency}}){%else%}Unit List Price (Target Currency){%endif%}"
    sql: ${unit_list_price} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: unit_selling_price_target_currency {
    group_label: "Item Prices and Discounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Unit Selling Price ({{currency}}){%else%}Unit Selling Price (Target Currency){%endif%}"
    sql: ${unit_selling_price} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

#} end item dimensions

#########################################################
# Quantity Dimensions
#{
  dimension: ordered_quantity {
    group_label: "Quantities"
  }

  dimension: invoiced_quantity {
    group_label: "Quantities"
  }

  dimension: credited_quantity {
    group_label: "Quantities"
  }

  dimension: invoiced_or_credited_quantity {
    type: number
    group_label: "Quantities"
    description: "Invoiced Quantity when value is positive. Credited Quantity when value is negative."
    sql: COALESCE(${invoiced_quantity},${credited_quantity}) ;;
  }

  dimension: quantity_uom {
    group_label: "Quantities"
    label: "Quantity UoM"
    description: "Quantity Unit of Measure"
  }
#} end quantity dimensions


#########################################################
# Amount Dimensions & Currency Conversion
#{
  dimension: revenue_amount {
    group_label: "Amounts"
    label: "Net Revenue Amount (Source Currency)"
    description: "Amount in source currency recognized as revenue for accounting purposes."
    value_format_name: decimal_2
  }

  dimension: gross_revenue_amount {
    group_label: "Amounts"
    label: "Gross Revenue Amount (Source Currency)"
    description: "Item Invoiced/Credited Quantity * Unit List Price."
    sql: COALESCE(${invoiced_quantity},${credited_quantity})*${unit_list_price} ;;
    value_format_name: decimal_2
  }

  dimension: transaction_amount {
    group_label: "Amounts"
    label: "Transaction Amount (Source Currency)"
    description: "Invoice line amount in source currency."
    value_format_name: decimal_2
  }

  dimension: tax_amount {
    group_label: "Amounts"
    label: "Tax Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: discount_amount {
    group_label: "Amounts"
    label: "Discount Amount (Source Currency)"
    description: "Item Invoiced Quantity * Unit Discount Price."
    sql: ${invoiced_quantity}*${unit_discount_price} ;;
    value_format_name: decimal_2
  }

  dimension: currency_source {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Source)"
    description: "Currency of the order header."
    sql: ${sales_invoices.currency_code} ;;
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
    sql: IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Amounts"
    sql: ${sales_invoices.currency_code} <> {% parameter otc_common_parameters_xvw.parameter_target_currency %} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  dimension: revenue_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Net Revenue Amount ({{currency}}){%else%}Net Revenue Amount (Target Currency){%endif%}"
    description: "Amount in target currency recognized as revenue for accounting purposes."
    sql: ${revenue_amount} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: gross_revenue_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Gross Revenue Amount ({{currency}}){%else%}Gross Revenue Amount (Target Currency){%endif%}"
    description: "Amount in target currency recognized as revenue for accounting purposes."
    sql: ${revenue_amount} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: transaction_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Transaction Amount ({{currency}}){%else%}Transaction Amount (Target Currency){%endif%}"
    description: "Invoice line amount in target currency."
    sql: ${transaction_amount} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: tax_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount ({{currency}}){%else%}Tax Amount (Target Currency){%endif%}"
    sql: ${tax_amount} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }

  dimension: discount_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Discount Amount ({{currency}}){%else%}Discount Amount (Target Currency){%endif%}"
    sql: ${discount_amount} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
    value_format_name: decimal_2
  }


#} end amount dimensions




  measure: invoice_line_count {
    type: count
    drill_fields: [invoice_line_details*]
  }

  measure: average_unit_list_price_target_currency {
    type: average
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Unit List Price ({{currency}}){%else%}Average Unit List Price (Target Currency){%endif%}"
    sql: ${unit_list_price_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: average_unit_selling_price_target_currency {
    type: average
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Unit Selling Price ({{currency}}){%else%}Average Unit Selling Price (Target Currency){%endif%}"
    sql: ${unit_selling_price_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: average_unit_list_price_when_discount_target_currency {
    type: average
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Unit List Price when Discount ({{currency}}){%else%}Average Unit List Price when Discount (Target Currency){%endif%}"
    sql: ${unit_list_price_target_currency} ;;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: decimal_2
  }

  measure: average_unit_selling_price_when_discount_target_currency {
    type: average
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Unit Selling Price when Discount ({{currency}}){%else%}Average Unit Selling Price when Discount (Target Currency){%endif%}"
    sql: ${unit_selling_price_target_currency} ;;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: decimal_2
  }

  measure: discount_invoice_line_count {
    type: count
    filters: [is_discount_selling_price: "Yes"]
  }

  measure: discount_invoice_line_percent {
    type: number
    sql: SAFE_DIVIDE(${discount_invoice_line_count},${invoice_line_count}) ;;
    value_format_name: percent_1
  }

  measure: average_percent_discount {
    type: average
    label: "Average % Discount"
    description: "Average percent discount off list price per invoice line (all lines even if there is no discount."
    sql: ${percent_discount} ;;
    value_format_name: percent_1
  }

  measure: average_percent_discount_when_taken {
    type: average
    label: "Average % Discount When Discount Taken"
    description: "For invoice lines with a discount, average percent discount off list price."
    sql: ${percent_discount} ;;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: percent_1
  }

  measure: total_transaction_amount_target_currency {
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Transaction Amount ({{currency}}){%else%}Total Transaction Amount (Target Currency){%endif%}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_revenue_amount_target_currency {
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Net Revenue Amount ({{currency}}){%else%}Total Net Revenue Amount (Target Currency){%endif%}"
    sql: ${revenue_amount_target_currency} ;;
    drill_fields: [invoice_line_details*]
    value_format_name: decimal_0
  }

  measure: total_gross_revenue_amount_target_currency {
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Gross Revenue Amount ({{currency}}){%else%}Total Gross Revenue Amount (Target Currency){%endif%}"
    sql: ${gross_revenue_amount_target_currency} ;;
    drill_fields: [invoice_line_details*]
    value_format_name: decimal_0
  }

  measure: total_tax_amount_target_currency {
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Tax Amount ({{currency}}){%else%}Total Tax Amount (Target Currency){%endif%}"
    sql: ${tax_amount_target_currency} ;;
    drill_fields: [invoice_line_details*]
    value_format_name: decimal_0
  }

  measure: total_discount_amount_target_currency {
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Discount Amount ({{currency}}){%else%}Total Discount Amount (Target Currency){%endif%}"
    sql: ${discount_amount_target_currency} ;;
    drill_fields: [invoice_line_details*]
    value_format_name: decimal_0
  }

  measure: total_invoiced_quantity {
    type: sum
    sql: ${invoiced_quantity} ;;
  }




set: invoice_line_details {
  fields: [sales_invoices.invoice_number,
           sales_invoices.invoice_date,
           ledger_date,
           line_number,
           is_intercompany,
           inventory_item_id,
           item_description,
           unit_list_price_target_currency,
           unit_selling_price_target_currency,
           invoiced_or_credited_quantity,
           total_revenue_amount_target_currency,
           total_gross_revenue_amount_target_currency,
           total_discount_amount_target_currency,
           total_tax_amount_target_currency
          ]
}

# Item Quantity
# Item List price (per unit)
# Unit Adjusted Price (per unit after discounts / rebates)
# Item Intercompany Amount (actual value they paid for all units on that particular invoice)
# Item Net Amount (Item Quantity multiplied by Item Adjusted Price)
# Item Invoiced Amount (Item Quantity multiplied by Unit List Price)
# Item Tax Amount




 }
