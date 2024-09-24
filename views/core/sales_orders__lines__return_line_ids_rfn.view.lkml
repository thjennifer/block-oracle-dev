#########################################################{
# PURPOSE
# UNNESTED view of Repeated INT return_line_ids found in sales_orders__lines table.
# Array of IDs of all return lines that reference the order line.
# A single order line could have multiple return_line_ids
#
# SOURCES
# Refines View sales_orders__lines__return_line_ids (defined in /views/base folder)
#
# REFERENCED BY
# Explore sales_orders
#
#########################################################}

include: "/views/base/sales_orders__lines__return_line_ids.view"

view: +sales_orders__lines__return_line_ids {

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${sales_orders.header_id},${sales_orders__lines.line_id},${return_line_id}) ;;
  }

  dimension: sales_orders__lines__return_line_ids {
    hidden: yes
  }

  dimension: return_line_id {
    type: number
    value_format_name: id
    description: "Return Line ID of the return line that reference this order line"
    sql: COALESCE(sales_orders__lines__return_line_ids,-1) ;;
    full_suggestions: yes
    html: {% if value > 0 %}{{value}}{% else %} {% endif %} ;;
#--> link opens order line details filtered to the line_id that matches the given return_line_id
    link: {
      label: "Order Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_build_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign use_qualified_filter_names = false %}
      {% assign source_to_destination_filters_mapping = 'return_line_id|line_id||parameter_target_currency|target_currency'%}
      @{link_map_otc_target_dash_id_order_details}
      @{link_build_dashboard_url}"
    }
  }

#--> helper measure used to generate link
  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }



}