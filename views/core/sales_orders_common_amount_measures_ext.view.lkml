#########################################################{
# PURPOSE
# Provide the same labels/descriptions for AMOUNT measures
# used in:
#    sales_orders__lines
#    sales_orders_daily_agg__lines
#    sales_orders_daily_agg__lines__amounts
#
# To use, extend into desired view.
#
# Defines label/descriptions for:
#   average_sales_amount_per_order_target_currency
#
# Fully defines these measures including sql: property:
#   total_ordered_amount_target_currency
#   total_sales_amount_target_currency
#   total_invoiced_amount_target_currency
#   total_invoiced_sales_amount_target_currency
#   total_ordered_amount_target_currency_formatted
#   total_sales_amount_target_currency_formatted
#   total_invoiced_amount_target_currency_formatted
#   total_invoiced_sales_amount_target_currency_formatted
#   alert_is_incomplete_conversion
#########################################################}


view: sales_orders_common_amount_measures_ext {

  extension: required


  measure: total_ordered_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    description: "Sum of ordered amount in target currency."
    sql: ${ordered_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    description: "Sum of sales in target currency."
    sql: ${ordered_amount_target_currency} ;;
    filters: [is_sales_order: "Yes"]
    value_format_name: decimal_0
  }

  measure: total_booking_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    description: "Sum of booking amount in target currency."
    sql: ${booking_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_backlog_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    description: "Sum of backlog amount in target currency."
    sql: ${backlog_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_fulfilled_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    description: "Sum of fulfilled amount in target currency."
    sql: ${fulfilled_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_shipped_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "@{label_build}"
    description: "Sum of shipped amount in target currency."
    sql: ${shipped_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_invoiced_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Total Billed Amount (@{label_get_target_currency}){%else%}Total Billed Amount (Target Currency){%endif%}"
    description: "Sum of billed or invoiced amount in target currency."
    sql: ${invoiced_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_ordered_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    description: "Sum of ordered amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_ordered_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }


  measure: total_sales_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    description: "Sum of sales in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_sales_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign append_extra_mapping = false %}
      {% assign expl = _explore._name %}
      {% if expl == 'sales_orders' %}
        @{link_sales_orders_to_details_dashboard_extra_mapping}
      {% endif %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}
      {% if append_extra_mapping == true %}
        {% assign filters_mapping = filters_mapping | append: extra_mapping %}
      {% endif %}
      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_booking_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    description: "Sum of booking amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_booking_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters='is_booking=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_backlog_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    description: "Sum of backlog amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_backlog_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters='is_backlog=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_fulfilled_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    description: "Sum of fulfilled amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_fulfilled_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_shipped_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "@{label_build_formatted}"
    description: "Sum of shipped amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_shipped_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_invoiced_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}Total Billed Amount (@{label_get_target_currency}){%else%}Total Billed Amount (Target Currency) Formatted {%endif%}"
    description: "Sum of billed or invoiced amount in target currency and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_invoiced_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: percent_of_total_sales {
    hidden: no
    type: percent_of_total
    description: "Column percent of total sales."
    sql: ${total_sales_amount_target_currency} ;;
    direction: "column"
  }

  measure: cumulative_sales_amount_target_currency {
    hidden: no
    type: running_total
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_sales_amount_target_currency} ;;
    direction: "column"
    value_format_name: decimal_0
  }

  measure: average_sales_amount_per_order_target_currency {
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Average Sales Amount per Order (@{label_get_target_currency}){%else%}Average Sales Amount per Order (Target Currency){%endif%}"
    value_format_name: decimal_0
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      @{link_sales_orders_to_details_dashboard_extra_mapping}
      {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}
      {% if append_extra_mapping == true %}
      {% assign filters_mapping = filters_mapping | append: extra_mapping %}
      {% endif %}
      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }



  }
