#########################################################{
# PURPOSE
# Provide the same labels/descriptions for AMOUNT measures
# used in:
#    sales_invoices__lines
#    sales_invoices_daily_agg__lines
#    sales_invoices_daily_agg__lines__amounts
#
# To use, extend into desired view.
#
# Define all but sql: property for amount dimensions:
#   revenue_amount_target_currency
#   transaction_amount_target_currency
#   tax_amount_target_currency
#   discount_amount_target_currency
#
# Fully defines these measures including sql: property
# and link where applicable:
#   total_transaction_amount_target_currency (labeled Total Invoice Amount)
#   total_revenue_amount_target_currency
#   total_tax_amount_target_currency
#   total_discount_amount_target_currency
#
# Adds formatting and/or links to these measures for dashboard display:
#   total_transaction_amount_target_currency_formatted
#   total_discount_amount_target_currency_formatted
#   total_tax_amount_target_currency_formatted
#########################################################}

view: sales_invoices_common_amount_fields_ext {
  extension: required

#########################################################
# DIMENSIONS: Amounts
#{
# define all but SQL property

  dimension: revenue_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of revenue amounts across all lines converted to target currency
    {%- else -%}Amount recognized as revenue for accounting purposes converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: transaction_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Invoice Amount' -%}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of pre-tax transaction amounts across all lines converted to target currency
    {%- else -%}Invoice line pre-tax transaction amount converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: tax_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of tax amounts across all lines converted to target currency
    {%- else -%}Tax amount associated with the transaction line converted to target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: discount_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of discount amounts across all lines converted to target currency
    {%- else -%}Item Invoiced Quantity * Unit Discount Price in target currency{%- endif -%}"
    value_format_name: decimal_2
  }
#} end amount dimensions

#########################################################
# MEASURES: Amounts
#{
  measure: total_transaction_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_currency_defaults}{%- assign field_name = 'Total Invoice Amount' -%}@{label_currency_if_selected}"
    description: "Total pre-tax transaction amount in target currency"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  # measure: total_gross_transaction_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "@{label_currency_defaults}{%- assign field_name = 'Total Gross Invoice Amount' -%}@{label_currency_if_selected}"
  #   sql: ${gross_transaction_amount_target_currency} ;;
  #   description: "Total transaction amount with taxes and before any discounts in target currency"
  #   value_format_name: decimal_2
  # }

  measure: total_revenue_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${revenue_amount_target_currency} ;;
    description: "Total amount in target currency recognized as revenue for accounting purposes"
    value_format_name: decimal_2
  }

  measure: total_tax_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${tax_amount_target_currency} ;;
    description: "Total tax amount in target currency"
    value_format_name: decimal_2
  }

  measure: total_discount_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${discount_amount_target_currency} ;;
    description: "Total discount amount in target currency"
    value_format_name: decimal_2
  }

#} end amount measures

#########################################################
# MEASURES: Formatted Amounts
#{
# amounts formatted with Large Number Format and with drill links

  measure: total_transaction_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign field_name = 'Total Invoice Amount' -%}{%- assign add_formatted = true -%}@{label_currency_if_selected}"
    description: "Total pre-tax transaction amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_transaction_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_invoices_to_invoice_details}'| append: '||invoice_month|date'%}
      @{link_map_otc_target_dash_id_invoice_details}
      @{link_build_dashboard_url}
      "
    }
  }

  # measure: total_gross_transaction_amount_target_currency_formatted {
  #   hidden: no
  #   type: number
  #   group_label: "Amounts Formatted as Large Numbers"
  #   label: "@{label_currency_defaults}{%- assign field_name = 'Total Gross Invoice Amount' -%}{%- assign add_formatted = true -%}@{label_currency_if_selected}"
  #   description: "Total transaction amount with taxes and before any discounts in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
  #   sql: ${total_gross_transaction_amount_target_currency} ;;
  #   value_format_name: format_large_numbers_d1
  # }

  measure: total_revenue_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total amount in target currency recognized as revenue for accounting purposes. Formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_revenue_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_tax_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total tax amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_tax_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_invoices_to_invoice_details}'%}
      @{link_map_otc_target_dash_id_invoice_details}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: total_discount_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Total discount amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_discount_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_invoices_to_invoice_details}'%}
      @{link_map_otc_target_dash_id_invoice_details}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign use_default_filters_to_override = false %}
      @{link_build_dashboard_url}
      "
    }
  }



#} end formatted amount measures

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


}