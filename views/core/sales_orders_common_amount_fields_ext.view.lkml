#########################################################{
# PURPOSE
# Provide the same labels/descriptions for AMOUNT measures
# used in:
#    sales_orders__lines
#    sales_orders_daily_agg__lines
#    sales_orders_daily_agg__lines__amounts
#
# To use, extend into the desired view.
#
# Defines label/description for:
#   ordered_amount_target_currency
#   booking_amount_target_currency
#   backlog_amount_target_currency
#   fulfilled_amount_target_currency
#   shipped_amount_target_currency
#   invoiced_amount_target_currency
#   average_ordered_amount_per_order_target_currency
#
# Fully defines these measures including sql: property
# and link where applicable:
#   total_ordered_amount_target_currency
#   total_sales_amount_target_currency
#   total_booking_amount_target_currency
#   total_backlog_amount_target_currency
#   total_fulfilled_amount_target_currency
#   total_shipped_amount_target_currency
#   total_invoiced_amount_target_currency
#   cumulative_sales_amount_target_currency
#   percent_of_total_sales
#
# Adds formatting and/or links to these measures for dashboard display:
#   total_ordered_amount_target_currency_formatted
#   total_sales_amount_target_currency_formatted
#   total_booking_amount_target_currency_formatted
#   total_backlog_amount_target_currency_formatted
#   total_fulfilled_amount_target_currency_formatted
#   total_shipped_amount_target_currency_formatted
#   total_invoiced_amount_target_currency_formatted
#   average_ordered_amount_per_order_target_currency_formatted
#########################################################}


view: sales_orders_common_amount_fields_ext {

  extension: required

#########################################################
# DIMENSIONS: Amounts Labels and Descriptions
#{
# define all but SQL property

  dimension: ordered_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of ordered amounts across orders and lines converted to target currency
    {%- else -%}Monetary amount of ordered items in the target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: booking_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of booking amounts across orders and lines converted to target currency
    {%- else -%}Monetary amount of booking items in the target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: backlog_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of backlog amounts across orders and lines converted to target currency
    {%- else -%}Monetary amount of backlog items in the target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of fulfilled amounts across orders and lines converted to target currency
    {%- else -%}Monetary amount of fulfilled items in the target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of shipped amounts across orders and lines converted to target currency
    {%- else -%}Monetary amount of shipped items in the target currency{%- endif -%}"
    value_format_name: decimal_2
  }

  dimension: invoiced_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Billed Amount' -%}@{label_currency_if_selected}"
    description: "{%- assign v = _view._name | split: '_' -%}
    {%- if v contains 'agg' -%}Sum of invoiced amounts across orders and lines converted to target currency
    {%- else -%}Monetary amount of invoiced items in the target currency{%- endif -%}"
    value_format_name: decimal_2
  }

#} end amount dimension

#########################################################
# MEASURES: Labels & Descriptions
#{

  measure: average_ordered_amount_per_order_target_currency {
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Average Amount per Order' -%}@{label_currency_if_selected}"
    description: "Average amount per order in target currency"
    value_format_name: decimal_2
  }

#} end labels & descriptions

#########################################################
# MEASURES: Amounts
#{

  measure: total_ordered_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of ordered amounts across orders and lines converted to target currency"
    sql: ${ordered_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of ordered amounts across sales orders converted to target currency"
    sql: ${ordered_amount_target_currency} ;;
    filters: [is_sales_order: "Yes"]
    value_format_name: decimal_2
  }

  measure: total_booking_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of booking amounts across orders and lines converted to target currency"
    sql: ${booking_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_backlog_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of backlog amounts across orders and lines converted to target currency"
    sql: ${backlog_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_fulfilled_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of fulfilled amounts across orders and lines converted to target currency"
    sql: ${fulfilled_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_shipped_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of shipped amounts across orders and lines converted to target currency"
    sql: ${shipped_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: total_invoiced_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Total Billed Amount' -%}@{label_currency_if_selected}"
    description: "Sum of billed or invoiced amounts across orders and lines converted to target currency"
    sql: ${invoiced_amount_target_currency} ;;
    value_format_name: decimal_2
  }

  measure: cumulative_sales_amount_target_currency {
    hidden: no
    type: running_total
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Cumulative sum of sales amount in target currency"
    sql: ${total_sales_amount_target_currency} ;;
    direction: "column"
    value_format_name: decimal_2
  }

  measure: percent_of_total_sales {
    hidden: no
    type: percent_of_total
    description: "Column percent of total sales"
    sql: ${total_sales_amount_target_currency} ;;
    direction: "column"
  }


#} end amount measures

#########################################################
# MEASURES: Formatted Amounts
#{
# amounts formatted with Large Number Format and with drill links

  measure: total_ordered_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of ordered amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_ordered_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_sales_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of ordered amounts across sales orders converted to target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_sales_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Show Sales by Month"
      url: "@{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign e = _explore._name | append: '.' %}
      {% assign v = _view._name | append: '.' %}
      {% assign measure = 'total_sales_amount_target_currency' | prepend: v %}
      {% assign m = 'ordered_month' | prepend: e %}
      {% assign drill_fields =  m | append: ',' | append: measure %}
      @{link_vis_line_chart_1_date_1_measure}
      @{link_build_explore_url}
      "
    }
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign append_extra_mapping = false %}
      {% assign expl = _explore._name %}
      {% if expl == 'sales_orders' %}
        @{link_map_otc_sales_orders_to_order_details_extra_mapping}
      {% endif %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      {% if append_extra_mapping == true %}
        {% assign source_to_destination_filters_mapping = source_to_destination_filters_mapping | append: extra_mapping %}
      {% endif %}
      @{link_map_otc_target_dash_id_order_details}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: total_booking_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of booking amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_booking_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_booking=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: total_backlog_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of backlog amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_backlog_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
#-->  returns table of 50 customers sorted in descending order of total backlog amount
    link: {
      label: "Show Top 50 Customers with Highest Backlog"
      url: "@{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign v = _view._name | append: '.' %} {% assign e = _explore._name | append: '.' %}
      {% assign measure = 'total_backlog_amount_target_currency' | prepend: v %}
      {% assign d = 'selected_customer_number, ' | prepend: e %}
      {% assign d = d | append: e | append: 'selected_customer_name' %}
      {% assign drill_fields = d | append: ',' | append: measure %}
      {% assign default_filters = measure | append: '=%3E%200' %}
      {% assign limit = 50 %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }

#-->  returns table of 50 customers sorted in descending order of total backlog amount
    link: {
      label: "Show Top 50 Categories with Highest Backlog"
      url: "@{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign v = _view._name | append: '.' %} {% assign e = _explore._name | append: '.' %}
      {% assign measure = 'total_backlog_amount_target_currency' | prepend: v %}
      {% assign d = 'category_description' | prepend: v %}
      {% assign drill_fields = d | append: ',' | append: measure %}
      {% assign default_filters = measure | append: '=%3E%200' %}
      {% assign limit = 50 %}
      @{link_vis_table}
      @{link_build_explore_url}
      "
    }
#-->  links to Order Line Details dashboard with filter for is_backlog = Yes
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_backlog=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: total_fulfilled_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of fulfilled amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_fulfilled_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_shipped_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Sum of shipped amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_shipped_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_invoiced_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Total Billed Amount' -%}@{label_currency_if_selected}"
    description: "Sum of billed or invoiced amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_invoiced_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: average_ordered_amount_per_order_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}{%- assign field_name = 'Average Amount per Order' -%}@{label_currency_if_selected}"
    description: "Average amount per order in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${average_ordered_amount_per_order_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Show Monthly Average Sales per Order"
      url: "@{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign e = _explore._name | append: '.' %}
      {% assign v = _view._name | append: '.' %}
      {% assign measure = 'average_ordered_amount_per_order_target_currency' | prepend: v %}
      {% assign m = 'ordered_month' | prepend: e %}
      {% assign drill_fields =  m | append: ',' | append: measure %}
      @{link_vis_line_chart_1_date_1_measure}
      @{link_build_explore_url}
      "
    }
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_sales_orders_to_order_details_extra_mapping}
      {% if append_extra_mapping == true %}
        {% assign source_to_destination_filters_mapping = source_to_destination_filters_mapping | append: extra_mapping %}
      {% endif %}
      @{link_map_otc_target_dash_id_order_details}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: cumulative_sales_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts Formatted as Large Numbers"
    label: "@{label_currency_defaults}{%- assign add_formatted = true -%}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Cumulative sum of sales amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${cumulative_sales_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

#} end formatted measures


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