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
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Ordered Amount ({{currency}}){%else%}Total Ordered Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of ordered amount in target currency {{currency}}"
    sql: ${ordered_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of sales in target currency {{currency}}"
    sql: ${ordered_amount_target_currency} ;;
    filters: [is_sales_order: "Yes"]
    value_format_name: decimal_0
  }

  measure: total_booking_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Booking Amount ({{currency}}){%else%}Total Booking Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of booking amount in target currency {{currency}}"
    sql: ${booking_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_backlog_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Backlog Amount ({{currency}}){%else%}Total Backlog Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of backlog amount in target currency {{currency}}"
    sql: ${backlog_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_fulfilled_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Fulfilled Amount ({{currency}}){%else%}Total Fulfilled Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of fulfilled amount in target currency {{currency}}"
    sql: ${fulfilled_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_shipped_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Shipped Amount ({{currency}}){%else%}Total Shipped Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of shipped amount in target currency {{currency}}"
    sql: ${shipped_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_invoiced_amount_target_currency {
    hidden: no
    type: sum
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Billed Amount ({{currency}}){%else%}Total Billed Amount (Target Currency){%endif%}"
    description: "@{derive_currency_label}Sum of billed or invoiced amount in target currency {{currency}}"
    sql: ${invoiced_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_ordered_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Ordered Amount ({{currency}}){%else%}Total Ordered Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of ordered amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_ordered_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }


  measure: total_sales_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Sales Amount ({{currency}}){%else%}Total Sales Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of sales in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_sales_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    # link: {
    #   label: "Original Order Line Details"
    #   icon_url: "/favicon.ico"
    #   url: "
    #   @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign qualify_filter_names = false %}
    #   {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}

    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
    #   {% assign default_filters_override = false %}
    #   @{link_generate_dashboard_url}
    #   "
    # }
    # link: {
    #   label: "test link"
    #   url: "{% assign link = link_generator._link %}{{link}}"
    # }
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
    # link: {
    #   label: "Order Line Details"
    #   icon_url: "/favicon.ico"
    #   url: "
    #   @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign qualify_filter_names = false %}
    #   {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}' | append: '||selected_product_dimension_description|product_description'%}
    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}
    #   {% assign default_filters_override = false %}
    #   @{link_generate_dashboard_url}
    #   "
    # }
    # link: {
    #   label: "Test Dash"
    #   icon_url: "/favicon.ico"
    #   url: "
    #   @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign qualify_filter_names = false %}
    #   {% assign filters_mapping = 'category_description|item_category||selected_product_dimension_description|product_description'%}

    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::jt_test' %}
    #   {% assign default_filters_override = false %}
    #   @{link_generate_dashboard_url}
    #   "
    # }
  }

  measure: total_booking_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Booking Amount ({{currency}}){%else%}Total Booking Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of booking amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
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
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Backlog Amount ({{currency}}){%else%}Total Backlog Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of backlog amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
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
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Fulfilled Amount ({{currency}}){%else%}Total Fulfilled Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of fulfilled amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_fulfilled_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_shipped_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Shipped Amount ({{currency}}){%else%}Total Shipped Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of shipped amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_shipped_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  measure: total_invoiced_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Amounts with Large Number Format"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Billed Amount ({{currency}}){%else%}Total Billed Amount (Target Currency) Formatted {%endif%}"
    description: "@{derive_currency_label}Sum of billed or invoiced amount in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${total_invoiced_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
  }

  # measure: total_invoiced_sales_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoiced Amount of Sales Orders ({{currency}}){%else%}Total Invoiced Amount of Sales Orders (Target Currency){%endif%}"
  #   description: "@{derive_currency_label}Sum of invoiced amount of sales orders in target currency {{currency}}"
  #   sql: ${invoiced_amount_target_currency} ;;
  #   filters: [is_sales_order: "Yes"]
  #   value_format_name: decimal_0
  # }

  # measure: total_invoiced_sales_amount_target_currency_formatted {
  #   hidden: no
  #   type: number
  #   group_label: "Amounts with Large Number Format"
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoiced Amount of Sales Orders ({{currency}}){%else%}Total Invoiced Amount of Sales Orders (Target Currency) Formatted {%endif%}"
  #   description: "@{derive_currency_label}Sum of invoiced amount of sales orders in target currency {{currency}} and formatted for large values (e.g., 2.3M or 75.2K)"
  #   sql: ${total_invoiced_amount_target_currency} ;;
  #   value_format_name: format_large_numbers_d1
  # }

  measure: percent_of_total_sales {
    hidden: no
    group_label: "Amounts"
    type: percent_of_total
    sql: ${total_sales_amount_target_currency} ;;
  }

  measure: cumulative_sales_amount_target_currency {
    hidden: no
    type: running_total
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Cumulative Sales Amount ({{currency}}){%else%}Cumulative Sales Amount (Target Currency) {%endif%}"
    sql: ${total_sales_amount_target_currency} ;;
    direction: "column"
    value_format_name: decimal_0
  }

  measure: average_sales_amount_per_order_target_currency {
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Average Sales Amount per Order ({{currency}}){%else%}Average Sales Amount per Order (Target Currency){%endif%}"
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

  measure: alert_note_for_incomplete_currency_conversion {
    hidden: no
    type: max
    description: "Provides a note in html when a source currency could not be converted to target currency. Add this measure to a table or single value visualization to alert users that amounts in target currency may be understated."
    sql: ${is_incomplete_conversion} ;;
    html: {% if value == true %}For timeframe and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }



  }
