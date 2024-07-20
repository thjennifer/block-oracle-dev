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
    sql: COALESCE(sales_orders__lines__return_line_ids,-1) ;;
    html: {% if value > 0 %}{{value}}{% else %} {% endif %} ;;

    link: {
      label: "Open Order Line Details Dashboard"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = 'return_line_id|line_id||parameter_target_currency|target_currency'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_order_line_item_details' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}"
    }
  }

  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }



}
