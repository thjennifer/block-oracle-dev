#########################################################{
# PURPOSE
# Provide the same labels/descriptions and/or definitions
# for measures used in both sales_orders and sales_orders_daily_agg
#
# To use, extend into the desired view.
#
# Defines label/descriptions for:
#   order_count
#   sales_order_count
#   return_order_count
#   blocked_order_count
#   cancelled_order_count
#   fillable_order_count
#   fulfilled_order_count
#   fulfilled_by_request_date_order_count
#   fulfilled_by_promise_date_order_count
#   has_backorder_order_count
#   has_return_sales_order_count
#   no_holds_order_count
#   non_cancelled_order_count
#   open_order_count
#
# Fully defines these measures including sql: property:
#   cancelled_order_percent
#   fulfilled_order_percent
#   fulfilled_order_percent_formatted
#   fulfilled_by_request_date_order_percent
#   fulfilled_by_request_date_order_percent_formatted
#.  has_backorder_order_percent
#   has_return_sales_order_percent
#   no_holds_order_percent
#########################################################}

view: sales_orders_common_count_measures_ext {
  extension: required

#########################################################
# MEASURES: Add Labels/Descriptions to Counts
#{

  measure: order_count {
    description: "Count of all orders regardless of category"
  }

  measure: sales_order_count {
    description: "Count of orders with category code not equal to RETURN"
  }

  measure: return_order_count {
    description: "Count of orders with category code of RETURN"
  }

  measure: blocked_order_count {
    description: "Number of orders that are blocked (backordered or held)"
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_blocked=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: cancelled_order_count {
    description: "Number of orders completely cancelled (all lines cancelled)"
  }

  measure: fillable_order_count {
    description: "Number of orders that can be met with the available inventory (none of items are backordered)"
  }

  measure: fulfilled_order_count {
    label: "In-Full Order Count"
    description: "Number of orders that are fulfilled completely (inventory is reserved and ready to be shipped for all order lines)"
  }

  measure: fulfilled_by_request_date_order_count {
    label: "On-Time & In-Full Order Count"
    description: "Number of orders that are fulfilled on-time (all lines fulfilled by requested delivery date)"
  }

  measure: fulfilled_by_promise_date_order_count {
    label: "Fulfilled by Promise Date Order Count"
    description: "Number of orders that are fulfilled on-time (all lines fulfilled by promised delivery date)"
  }

  measure: has_backorder_order_count {
    description: "Number of orders with at least one item backordered"
  }

  measure: has_return_sales_order_count {
    label: "Has a Return Sales Order Count"
    description: "Number of sales orders with at least one item returned (regardless of when returned)"
  }

  measure: no_holds_order_count {
    label: "One Touch Order Count"
    description: "Count of orders without any holds"
  }

  measure: non_cancelled_order_count {
    label: "Non-Cancelled Order Count"
    description: "Number of orders that have not been cancelled. Used in calculation of Average Amount per Order because cancelled orders do not have any sales amounts associated with them"
  }

  measure: open_order_count {
    description: "Number of orders that are open"
  }

#} end labels/descriptions

#########################################################
# MEASURES: Percent of Orders measures
#{

  measure: cancelled_order_percent {
    hidden: no
    type: number
    label: "Cancelled Percent"
    description: "The percentage of orders that have been cancelled (all lines cancelled)"
    sql: SAFE_DIVIDE(${cancelled_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: fulfilled_order_percent {
    hidden: no
    type: number
    label: "In-Full Percent"
    description: "The percentage of orders that are fulfilled completely (inventory is reserved and ready to be shipped for all order lines)"
    sql: SAFE_DIVIDE(${fulfilled_order_count},${order_count}) ;;
    value_format_name: percent_1
#--> link to order line details dashboards with filter for is_fulfilled = Yes
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_fulfilled=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: fulfilled_by_request_date_order_percent {
    hidden: no
    type: number
    label: "On-Time & In-Full Percent"
    description: "The percentage of orders that are on-time (all lines fulfilled by requested delivery date)"
    sql: SAFE_DIVIDE(${fulfilled_by_request_date_order_count},${order_count}) ;;
    value_format_name: percent_1
#--> link to order line details dashboards with filter for is_fulfilled_by_request_date = Yes
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_fulfilled_by_request_date=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: has_backorder_order_percent {
    hidden: no
    type: number
    label: "Has Backorder Percent"
    description: "The percentage of orders with at least one item backordered"
    sql: SAFE_DIVIDE(${has_backorder_order_count},${order_count}) ;;
    value_format_name: percent_1
#--> link to order line details dashboards with filter for is_backordered = Yes
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_backordered=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: has_return_sales_order_percent {
    hidden: no
    type: number
    label: "Has a Return Percent"
    description: "The percentage of sales orders with at least one item returned"
    sql: SAFE_DIVIDE(${has_return_sales_order_count},${sales_order_count}) ;;
    value_format_name: percent_1
#--> link to order line details dashboards with filter for has_return = Yes
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}'%}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='has_return=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

  measure: no_holds_order_percent {
    hidden: no
    type: number
    label: "One Touch Percent"
    description: "The percentage of orders that never had a hold during processing"
    sql: SAFE_DIVIDE(${no_holds_order_count},${order_count}) ;;
    value_format_name: percent_1
  }

  measure: percent_of_sales_orders {
    hidden: no
    type: percent_of_total
    description: "Column Percent of Sales Orders"
    direction: "column"
    sql: ${sales_order_count} ;;
  }

  measure: percent_of_orders {
    hidden: no
    type: percent_of_total
    description: "Column Percent of Orders"
    direction: "column"
    sql: ${order_count} ;;
  }

 #} end percent of orders measures

#########################################################
# MEASURES: Formatted
#{
# measures formatted for display on dashboard (e.g., format_large_numbers_d1)

  measure: sales_order_count_formatted {
    hidden: no
    type: number
    group_label: "Counts Formatted as Large Numbers"
    description: "Count of orders with category code not equal to RETURN formatted for large values (e.g., 2.3M or 75.2K)"
    sql: ${sales_order_count} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Show Sales Orders by Month"
      url: "@{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign v = _view._name | append: '.' %}
      {% assign measure = 'sales_order_count' | prepend: v %}
      {% assign m = 'ordered_month' | prepend: v %}
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
      @{link_map_otc_target_dash_id_order_details}
      @{link_build_dashboard_url}
      "
    }
  }

#--> Converts Percent to 0 - 100 scale to support shared tooltips on dashboard
#--> hidden from Explore
  measure: fulfilled_order_percent_formatted {
    hidden: yes
    type: number
    label: "In-Full Percent"
    description: "The percentage of orders that are fulfilled completely (inventory is reserved and ready to be shipped for all order lines)"
    sql: ${fulfilled_order_percent} * 100 ;;
    value_format_name: decimal_1
    html: {{rendered_value}}% ;;
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}' | append: '||ordered_month|date' %}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_fulfilled=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
  }

#--> Converts Percent to 0 - 100 scale to support shared tooltips on dashboard
#--> hidden from Explore
  measure: fulfilled_by_request_date_order_percent_formatted {
    hidden: yes
    type: number
    label: "On-Time & In-Full Percent"
    description: "The percentage of sales orders that are on-time (all lines fulfilled by requested delivery date)"
    sql: ${fulfilled_by_request_date_order_percent} * 100 ;;
    value_format_name: decimal_1
    html: {{rendered_value}}% ;;
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = '@{link_map_otc_sales_orders_to_order_details}' | append: '||ordered_month|date' %}
      @{link_map_otc_target_dash_id_order_details}
      {% assign default_filters='is_fulfilled_by_request_date=Yes'%}
      {% assign use_default_filters_to_override = true %}
      @{link_build_dashboard_url}
      "
    }
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
