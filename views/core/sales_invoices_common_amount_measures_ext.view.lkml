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

view: sales_invoices_common_amount_measures_ext {
  extension: required

#########################################################
# MEASURES: Amounts
#{
  measure: total_transaction_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_defaults}{%- assign field_name = 'Total Invoice Amount' -%}@{label_currency_if_selected}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_revenue_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_defaults}@{label_field_name}@{label_currency_if_selected}"
    sql: ${revenue_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_tax_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_defaults}@{label_field_name}@{label_currency_if_selected}"
    sql: ${tax_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_discount_amount_target_currency {
    hidden: no
    type: sum
    label: "@{label_defaults}@{label_field_name}@{label_currency_if_selected}"
    sql: ${discount_amount_target_currency} ;;
    value_format_name: decimal_2
  }

#} end amount measures

#########################################################
# MEASURES: Formatted Amounts
#{
# amounts formatted with Large Number Format and with drill links

  measure: total_transaction_amount_target_currency_formatted {
    hidden: no
    type: sum
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign field_name = 'Total Invoice Amount' -%}{%- assign add_formatted = true -%}@{label_currency_if_selected}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'| append: '||invoice_month|date'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_discount_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_discount_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
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
      {% assign default_filters='is_discounted=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_tax_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_defaults}{%- assign add_formatted = true -%}@{label_field_name}@{label_currency_if_selected}"
    sql: ${total_tax_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
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
