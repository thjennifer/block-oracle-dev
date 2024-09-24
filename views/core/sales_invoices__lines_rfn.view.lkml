#########################################################{
# PURPOSE
# UNNESTED view of Repeated Struct LINES found in SalesInvoices table.
# Captures invoice lines details by invoice_id
#
# SOURCES
# Refines View sales_invoices__lines
# Extends Views:
#   otc_common_fiscal_gl_dates_ext
#   otc_common_item_descriptions_ext
#   otc_common_item_categories_ext
#   sales_invoices_common_amount_fields_ext
#
# REFERENCED BY
# Explore sales_invoices
#
# EXTENDED FIELDS
#    fiscal_gl_date, fiscal_gl_quarter_num, fiscal_gl_period_name, etc...
#    item_description, language_code
#    category_id, category_description, category_name_code
#    total_transaction_amount_target_currency, total_tax_amount_target_currency, and other amounts
#
# REPEATED STRUCTS
# - Also includes Repeated Structs for Item Descriptions and Item Categories. Select fields from
#   these Repeated Structs have been defined here so these do not have to be unnested. See each related
#   view which could be added to Explore if needed:
#     sales_invoices__lines__item_descriptions
#     sales_invoices__lines__item_categories
#
# NOTES
# - This view includes both ORDER and RETURN lines. Use line_category_code to pick which to include.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - When the field name is duplicated in the header (like creation date), the sql property is restated to use the ${TABLE} reference.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_invoices__lines.view"
include: "/views/core/otc_common_fiscal_gl_dates_ext.view"
include: "/views/core/otc_common_item_descriptions_ext.view"
include: "/views/core/otc_common_item_categories_ext.view"
include: "/views/core/sales_invoices_common_amount_fields_ext.view"

view: +sales_invoices__lines {
  extends: [otc_common_fiscal_gl_dates_ext, otc_common_item_descriptions_ext, otc_common_item_categories_ext, sales_invoices_common_amount_fields_ext]

  fields_hidden_by_default: yes

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${sales_invoices.invoice_id},${line_id}) ;;
  }

  dimension: line_id {
    hidden: no
    full_suggestions: yes
  }

  dimension: line_number {
    hidden: no
    full_suggestions: yes
  }

  dimension: line_description {
    hidden: no
    full_suggestions: yes
  }

  dimension: is_intercompany {
    hidden: no
    full_suggestions: yes
  }

  dimension: is_intercompany_with_symbols {
    hidden: yes
    group_label: "Line Status with Symbols"
    label: "Item is Intercompany"
    description: "✅ if transaction was internal within the company"
    sql: ${is_intercompany} ;;
    can_filter: no
    html: @{html_symbols_for_yes} ;;
  }

#########################################################
# DIMENSIONS: Order Details
#{

  dimension: order_header_id {
    hidden: no
    group_label: "Order Details"
    label: "Order ID"
    value_format_name: id
    full_suggestions: yes
  }

  dimension: order_header_number {
    hidden: no
    group_label: "Order Details"
    label: "Order Number"
    value_format_name: id
    full_suggestions: yes
#--> opens Order Line Details dashboard for given Order Number
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_invoices_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      @{link_build_dashboard_url}
      "
    }
  }

  dimension: order_line_id {
    hidden: no
    primary_key: no
    group_label: "Order Details"
    value_format_name: id
    full_suggestions: yes
    }

  dimension: order_source_id {
    hidden: no
    group_label: "Order Details"
    sql: COALESCE(${TABLE}.ORDER_SOURCE_ID,-1) ;;
    value_format_name: id
    full_suggestions: yes
  }

  dimension: order_source_name {
    hidden: no
    group_label: "Order Details"
    sql: COALESCE(${TABLE}.ORDER_SOURCE_NAME,"Unknown") ;;
    full_suggestions: yes
  }
#} end order details

#########################################################
# DIMENSIONS: Dates
#{
# Fiscal Dates extended from otc_common_fiscal_gl_dates_ext and grouped under Ledger Date.

  dimension_group: ledger {
    hidden: no
    description: "Date when the invoice line was applied to the ledger"
  }

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    sql: ${TABLE}.CREATION_TS ;;
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    sql: ${TABLE}.LAST_UPDATE_TS ;;
  }

#} end dates

#########################################################
# DIMENSIONS: Item
#{
# values for item_description, language_code, category_description, category_id, category_name_code are:
# - extended into this view from otc_common_item_descriptions_ext and otc_common_item_categories
# - pulled from the Repeated Struct fields ITEM_CATEGORIES and ITEM_DESCRIPTIONS

  dimension: inventory_item_id {
    hidden: no
    label: "Item ID"
    value_format_name: id
    full_suggestions: yes
  }

  dimension: item_part_number {
    hidden: no
    value_format_name: id
    full_suggestions: yes
  }

  dimension: item_organization_id {
    hidden: no
    value_format_name: id
    full_suggestions: yes
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
    full_suggestions: yes
  }

#} end item dimensions

#########################################################
# DIMENSIONS: Item Quantities
#{

  dimension: quantity_uom {
    hidden: no
    group_label: "Quantities"
    label: "Quantity UoM"
    sql: UPPER(${TABLE}.QUANTITY_UOM) ;;
    full_suggestions: yes
  }

  dimension: ordered_quantity {
    hidden: no
    group_label: "Quantities"
    value_format_name: decimal_2
    full_suggestions: yes
  }

  dimension: invoiced_quantity {
    hidden: no
    group_label: "Quantities"
    value_format_name: decimal_2
    full_suggestions: yes
  }

  dimension: credited_quantity {
    hidden: no
    group_label: "Quantities"
    value_format_name: decimal_2
    full_suggestions: yes
  }

  dimension: invoiced_or_credited_quantity {
    hidden: no
    type: number
    group_label: "Quantities"
    description: "Invoiced Quantity when value is positive. Credited Quantity when value is negative"
    sql: COALESCE(${invoiced_quantity},${credited_quantity}) ;;
    value_format_name: decimal_2
    full_suggestions: yes
  }


#} end item quantities

#########################################################
# DIMENSIONS: Item prices & discounts
#{

  dimension: unit_list_price {
    hidden: no
    group_label: "Item Prices and Discounts"
    label: "Unit List Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_selling_price {
    hidden: no
    group_label: "Item Prices and Discounts"
    label: "Unit Selling Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: gross_unit_selling_price {
    hidden: no
    group_label: "Item Prices and Discounts"
    label: "Gross Unit Selling Price (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_discount_price {
    hidden: no
    group_label: "Item Prices and Discounts"
    label: "Unit Discount Amount (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: unit_list_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Prices and Discounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Post-tax list price of item converted to target currency"
    sql: ${unit_list_price} * ${sales_invoices.currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: unit_selling_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Prices and Discounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Actual pre-tax price charged to customer converted to target currency"
    sql: ${unit_selling_price} * ${sales_invoices.currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: gross_unit_selling_price_target_currency {
    hidden: no
    type: number
    group_label: "Item Prices and Discounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Actual post-tax price charged to customer converted to target currency"
    sql: ${gross_unit_selling_price} * ${sales_invoices.currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: unit_discount_amount_target_currency {
    hidden: no
    type: number
    group_label: "Item Prices and Discounts"
    description: "Post-tax unit list price minus post-tax unit selling price. Reported in target currency"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${unit_discount_price} * ${sales_invoices.currency_conversion_rate} ;;
    value_format_name: decimal_2
  }

  dimension: is_discount_selling_price {
    hidden: no
    type: yesno
    group_label: "Item Prices and Discounts"
    description: "Indicates whether the item was sold at a discounted price"
    sql: ${unit_discount_price} <> 0 ;;
    full_suggestions: yes
  }

  dimension: is_discount_selling_price_with_symbols {
    hidden: yes
    type: string
    group_label: "Item Prices and Discounts"
    label: "Item is Discounted"
    description: "✅ if line item was sold at a discounted price"
    sql: ${is_discount_selling_price} ;;
    html: @{html_symbols_for_yes} ;;
    full_suggestions: yes
  }

  dimension: percent_discount {
    hidden: yes
    type: number
    group_label: "Item Prices and Discounts"
    description: "Percent discount off unit list price"
    sql: 1 - SAFE_DIVIDE(${gross_unit_selling_price},${unit_list_price}) ;;
    value_format_name: percent_1
  }

#} end item price and cost

#########################################################
# DIMENSIONS: Amounts
#{
# hidden from explore because measures for each are defined.
# other properties for _target_currency dimensions extended from sales_payments_common_amount_fields_ext

  dimension: revenue_amount {
    group_label: "Amounts"
    label: "Revenue Amount (Source Currency)"
    description: "Amount in source currency recognized as revenue for accounting purposes"
    value_format_name: decimal_2
  }

  dimension: gross_transaction_amount {
    group_label: "Amounts"
    label: "Gross Invoice Amount (Source Currency)"
    description: "Item Invoiced/Credited Quantity * Unit List Price. Amount with taxes and before any discounts"
    sql: COALESCE(${invoiced_quantity},${credited_quantity})*${unit_list_price} ;;
    value_format_name: decimal_2
  }

  dimension: transaction_amount {
    group_label: "Amounts"
    label: "Invoice Amount (Source Currency)"
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
    description: "Item Invoiced Quantity * Unit Discount Price"
    sql: ${invoiced_quantity}*${unit_discount_price} ;;
    value_format_name: decimal_2
  }

  dimension: revenue_amount_target_currency {
    sql: ${revenue_amount} * ${sales_invoices.currency_conversion_rate}  ;;
  }

  dimension: gross_transaction_amount_target_currency {
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Gross Invoice Amount' -%}@{label_currency_if_selected}"
    description: "Gross transaction amount with taxes and before any discounts converted to target currency"
    sql: ${gross_transaction_amount} * ${sales_invoices.currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: transaction_amount_target_currency {
    sql: ${transaction_amount} * ${sales_invoices.currency_conversion_rate}  ;;
  }

  dimension: tax_amount_target_currency {
    sql: ${tax_amount} * ${sales_invoices.currency_conversion_rate}  ;;
  }

  dimension: discount_amount_target_currency {
    sql: ${discount_amount} * ${sales_invoices.currency_conversion_rate}  ;;
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amounts
#{

  measure: invoice_line_count {
    hidden: no
    type: count
    description: "Distinct count of invoice lines"
    drill_fields: [invoice_line_details*]
  }

  measure: total_invoiced_quantity {
    type: sum
    sql: ${invoiced_quantity} ;;
  }

#} end non-amount measures

#########################################################
# MEASURES: Amounts
#{
# defined in and extended from sales_invoices_common_amount_fields_ext
# updated here for drill fields or links

  measure: total_transaction_amount_target_currency {
    drill_fields: [invoice_line_details*]
  }

  measure: total_revenue_amount_target_currency {
    drill_fields: [invoice_line_details*]
  }

  measure: total_gross_transaction_amount_target_currency {
    drill_fields: [invoice_line_details*]
  }

  measure: total_tax_amount_target_currency {
    drill_fields: [invoice_line_details*]
  }

  measure: total_discount_amount_target_currency {
    drill_fields: [invoice_line_details*]
  }

#} end amount measures

#########################################################
# MEASURES: Amounts in Source Currency
#{

  measure: total_transaction_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Invoice Amount in Source Currency"
    description: "Sum of invoice transaction amount in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_invoices.currency_code._is_selected -%}${transaction_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_invoices.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_revenue_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Revenue Amount in Source Currency"
    description: "Sum of invoice revenue amount in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_invoices.currency_code._is_selected -%}${revenue_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_invoices.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_gross_transaction_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Gross Invoice Amount in Source Currency"
    description: "Sum of gross invoice revenue amount in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_invoices.currency_code._is_selected -%}${gross_transaction_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_invoices.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_tax_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Tax Amount in Source Currency"
    description: "Sum of tax amount in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_invoices.currency_code._is_selected -%}${tax_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_invoices.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

  measure: total_discount_amount_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Discount Amount in Source Currency"
    description: "Sum of discount amount in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if sales_invoices.currency_code._is_selected -%}${discount_amount}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: {%- if sales_invoices.currency_code._is_selected -%}{{rendered_value}}{%- else -%}Add Currency (Source) to query as dimension{%- endif -%} ;;
  }

#} end amounts in source currency

#########################################################
# MEASURES: Average Unit Prices and Discounts
#{

  measure: average_unit_list_price_target_currency {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average post-tax unit list price in target currency"
    sql: ${unit_list_price_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: average_unit_selling_price_target_currency {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average pre-tax unit price charged to customer in target currency"
    sql: ${unit_selling_price_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: average_gross_unit_selling_price_target_currency {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Average post-tax unit price charged to customer in target currency"
    sql: ${gross_unit_selling_price_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: average_unit_list_price_when_discount_target_currency {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Average Unit List Price when Discount' -%}@{label_currency_if_selected}"
    description: "Average post-tax unit list price in target currency across invoice lines when there is a discount"
    sql: ${unit_list_price_target_currency} ;;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: decimal_2
#--> opens Invoice Line Details dashboard with filter is_discounted = Yes
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_invoices_to_invoice_details}' | append: '||sales_invoices__lines.is_discount_selling_price|is_discounted||sales_invoices__lines.is_intercompany|is_intercompany' %}
      @{link_map_otc_target_dash_id_invoice_details}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: average_unit_selling_price_when_discount_target_currency {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Average Unit Selling Price when Discount' -%}@{label_currency_if_selected}"
    description: "Average pre-tax unit price charged to customer in target currency when there is a discount"
    sql: ${unit_selling_price_target_currency} ;;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: decimal_2
#--> opens Invoice Line Details dashboard with filter is_discounted = Yes
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_invoices_to_invoice_details}' | append: '||sales_invoices__lines.is_discount_selling_price|is_discounted||sales_invoices__lines.is_intercompany|is_intercompany' %}
      @{link_map_otc_target_dash_id_invoice_details}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: average_gross_unit_selling_price_when_discount_target_currency {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Average Gross Unit Selling Price when Discount' -%}@{label_currency_if_selected}"
    description: "Average post-tax unit price charged to customer in target currency when there is a discount"
    sql: ${gross_unit_selling_price_target_currency} ;;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: decimal_2
#--> opens Invoice Line Details dashboard with filter is_discounted = Yes
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_invoices_to_invoice_details}' | append: '||sales_invoices__lines.is_discount_selling_price|is_discounted||sales_invoices__lines.is_intercompany|is_intercompany' %}
      @{link_map_otc_target_dash_id_invoice_details}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: discount_invoice_line_count {
    type: count
    group_label: "Average Unit Prices & Discounts"
    description: "Count of invoice lines when there is a discount"
    filters: [is_discount_selling_price: "Yes"]
  }

  measure: discount_invoice_line_percent {
    hidden: no
    group_label: "Average Unit Prices & Discounts"
    label: "Percent of Invoice Lines with Discount"
    type: number
    description: "Frequency of discounts computed as invoice lines with discount divided by total invoice lines"
    sql: SAFE_DIVIDE(${discount_invoice_line_count},${invoice_line_count});;
    value_format_name: percent_1
  }

  measure: average_percent_discount {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "Average % Discount"
    description: "Average percent discount off list price per invoice line (all lines even if there is no discount)"
    sql: ${percent_discount};;
    value_format_name: percent_1
  }

  measure: average_percent_discount_when_taken {
    hidden: no
    type: average
    group_label: "Average Unit Prices & Discounts"
    label: "Average % Discount when Discount Taken"
    description: "For invoice lines with a discount, average percent discount off list price"
    sql: ${percent_discount};;
    filters: [is_discount_selling_price: "Yes"]
    value_format_name: percent_1
  }

#--> formatted on scale of 0 to 100 for to support shared tooltips in dashboard
  measure: discount_invoice_line_percent_formatted {
    hidden: yes
    type: number
    sql: ${discount_invoice_line_percent} * 100 ;;
    value_format_name: decimal_1
    html: {{rendered_value}}% ;;
  }

#--> formatted on scale of 0 to 100 for to support shared tooltips in dashboard
  measure: average_percent_discount_when_taken_formatted {
    hidden: yes
    type: number
    sql: ${average_percent_discount_when_taken} * 100;;
    value_format_name: decimal_1
    html: {{ rendered_value }}% ;;
  }

#} end average unit prices and discount measures

#########################################################
# SETS
#{

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
           total_transaction_amount_target_currency,
           total_gross_transaction_amount_target_currency,
           total_discount_amount_target_currency,
           total_tax_amount_target_currency
          ]
}

#} end sets

}