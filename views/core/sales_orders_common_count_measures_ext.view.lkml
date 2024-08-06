#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions
# for measures used in both sales_orders and sales_orders_daily_agg
#
# To use extend into desired view.
#
# Defines label/descriptions for:
#   order_count
#   sales_order_count
#   return_order_count
#   blocked_sales_order_count
#   cancelled_sales_order_count
#   fillable_sales_order_count
#   fulfilled_sales_order_count
#   fulfilled_by_request_date_sales_order_count
#   fulfilled_by_promise_date_sales_order_count
#   has_backorder_sales_order_count
#   has_return_sales_order_count
#   no_holds_sales_order_count
#   non_cancelled_sales_order_count
#   open_sales_order_count
#
# Fully defines these measures including sql: property:
#   cancelled_sales_order_percent
#   fulfilled_sales_order_percent
#   fulfilled_sales_order_percent_formatted
#   fulfilled_by_request_date_sales_order_percent
#   fulfilled_by_request_date_sales_order_percent_formatted
#.  has_backorder_sales_order_percent
#   has_return_sales_order_percent
#   no_holds_sales_order_percent
#########################################################}

view: sales_orders_common_count_measures_ext {
  extension: required

#########################################################
# Labels/Descriptions for count measures
#{

  measure: order_count {
    # label: "Orders"
    description: "Count of all orders regardless of category."
  }

  measure: sales_order_count {
    # label: "Sales Orders"
    description: "Count of orders with category code not equal to RETURN."
    # link: {
    #   label: "Order Line Details"
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
  }

  measure: return_order_count {
    # label: "Return Order "
    description: "Count of orders with category code of RETURN."
  }

  measure: blocked_sales_order_count {
    # label: "Blocked Orders"
    description: "Number of sales orders that are blocked (backordered or held)."
  }

  measure: cancelled_sales_order_count {
    # label: "Cancelled Orders"
    description: "Number of sales orders completely cancelled (all lines cancelled)."
  }

  measure: fillable_sales_order_count {
    # label: "Fillable Orders"
    description: "Number of sales orders that can be met with the available inventory (none of items are backordered)."
  }

  measure: fulfilled_sales_order_count {
    label: "In-Full Sales Order Count"
    description: "Number of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
  }

  measure: fulfilled_by_request_date_sales_order_count {
    label: "On-Time & In-Full Sales Order Count"
    description: "Number of sales orders that are fulfilled on-time (all lines fulfilled by requested delivery date)."
  }

  measure: fulfilled_by_promise_date_sales_order_count {
    label: "Fulfilled by Promise Date Sales Order Count"
    description: "Number of sales orders that are fulfilled on-time (all lines fulfilled by promised delivery date)."
  }

  measure: has_backorder_sales_order_count {
    # label: "Has Backorder Orders"
    description: "Number of sales orders with at least one item backordered."
  }

  measure: has_return_sales_order_count {
    label: "Has a Return Sales Order Count"
    description: "Number of sales orders with at least one item returned (regardless of when returned)."
  }

  measure: no_holds_sales_order_count {
    label: "One Touch Sales Order Count"
    description: "Count of sales orders without any holds."
  }

  measure: non_cancelled_sales_order_count {
    label: "Non-Cancelled Sales Order Count"
    description: "Number of sales orders that have not been cancelled. Used in calculation of Average Sales per Order because cancelled orders do not have any sales amounts associated with them."
  }

  measure: open_sales_order_count {
    # label: "Open Sales Order Count"
    description: "Number of sales orders that are open."
  }

#} end labels/descriptions

#########################################################
# Percent of sales orders measures
#
#{
  measure: cancelled_sales_order_percent {
    hidden: no
    type: number
    label: "Cancelled Percent"
    description: "The percentage of sales orders that have been cancelled (all lines cancelled)."
    sql: SAFE_DIVIDE(${cancelled_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
  }


  measure: fulfilled_sales_order_percent {
    hidden: no
    type: number
    label: "In-Full Percent"
    description: "The percentage of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
    sql: SAFE_DIVIDE(${fulfilled_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
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
      {% assign default_filters='is_fulfilled=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

#--> Converts Percent to 0 - 100 scale to support shared tooltips on dasbhoard
#--> hidden from Explore
  measure: fulfilled_sales_order_percent_formatted {
    hidden: yes
    type: number
    label: "In-Full Percent"
    description: "The percentage of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
    sql: ${fulfilled_sales_order_percent} * 100 ;;
    value_format_name: decimal_1
    html: {{rendered_value}}% ;;
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
      {% assign default_filters='is_fulfilled=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: fulfilled_by_request_date_sales_order_percent {
    hidden: no
    type: number
    label: "On-Time & In-Full Percent"
    description: "The percentage of sales orders that are on-time (all lines fulfilled by requested delivery date)."
    sql: SAFE_DIVIDE(${fulfilled_by_request_date_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
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
      {% assign default_filters='is_fulfilled_by_request_date=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

#--> Converts Percent to 0 - 100 scale to support shared tooltips on dasbhoard
#--> hidden from Explore
  measure: fulfilled_by_request_date_sales_order_percent_formatted {
    hidden: yes
    type: number
    label: "On-Time & In-Full Percent"
    description: "The percentage of sales orders that are on-time (all lines fulfilled by requested delivery date)."
    sql: ${fulfilled_by_request_date_sales_order_percent} * 100 ;;
    value_format_name: decimal_1
    html: {{rendered_value}}% ;;
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
      {% assign default_filters='is_fulfilled_by_request_date=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }


  measure: has_backorder_sales_order_percent {
    hidden: no
    type: number
    label: "Has Backorder Percent"
    description: "The percentage of sales orders with at least one item backordered."
    sql: SAFE_DIVIDE(${has_backorder_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
  }

  measure: has_return_sales_order_percent {
    hidden: no
    type: number
    label: "Has a Return Percent"
    description: "The percentage of sales orders with at least one item returned."
    sql: SAFE_DIVIDE(${has_return_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
  }

  measure: no_holds_sales_order_percent {
    hidden: no
    type: number
    label: "One Touch Percent"
    description: "The percentage of sales orders that never had a hold during processing."
    sql: SAFE_DIVIDE(${no_holds_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
  }

 #} end percent of sales orders measures

#########################################################
# Counts measures formatted as large_numbers_d1
#
#{

  measure: sales_order_count_formatted {
    hidden: no
    type: number
    group_label: "Counts Formatted as Large Numbers"
    sql: ${sales_order_count} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Show Sales Orders by Month (Common)"
      # url: "{{dummy_drill_monthly_orders._link}}"
      url: "@{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign v = _view._name | append: '.' %}
      {% assign measure = 'sales_order_count' | prepend: v %}
      {% assign m = 'ordered_month' | prepend: v %}
      {% assign drill_fields =  m | append: ',' | append: measure %}
      @{link_line_chart_1_date_1_measure}
      @{link_generate_explore_url}
      "
    }
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
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

#########################################################
# Helper measures
# used to support links and drills; hidden from explore
#
#{

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }

#} end helper measures



   }
