include: "/views/core/sales_orders__lines_rfn.view"

view: +sales_orders__lines {

  ########### TEST STUFF
  # measure: count_distinct_inventory_item {
  #   hidden: no
  #   view_label: "TEST STUFF"
  #   type: count_distinct
  #   sql: ${inventory_item_id} ;;
  # }

  measure: count_distinct_item_part_number {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${item_part_number} ;;
  }

  measure: average_order_lines_per_order {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: ${count_order_lines} / ${sales_orders.count} ;;
  }

  dimension: is_null_unit_cost {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_cost} is null ;;
  }

  dimension: is_negative_quantity {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${ordered_quantity} < 0 ;;
  }

  dimension: is_negative_amount {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${ordered_amount} < 0 ;;
  }

  dimension: is_null_unit_list_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price} is null ;;
  }

  dimension: is_null_unit_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_selling_price} is null ;;
  }

  dimension: has_fulfilled_quantity_gt_0 {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${fulfilled_quantity} > 0 ;;
  }

  dimension: is_difference_in_unit_list_and_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price}<>${unit_selling_price} ;;
  }

  dimension: is_unit_list_gt_selling_price {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${unit_list_price}>${unit_selling_price} ;;
  }

  # dimension: is_fulfillment_different_than_actual_ship {
  #   hidden: no
  #   type: yesno
  #   view_label: "TEST STUFF"
  #   sql: ${fulfillment_date} <> ${actual_ship_date} ;;
  # }

  dimension: cycle_time_days {
    hidden: no
    view_label: "TEST STUFF"
  }



  dimension: test_item_category_id {
    hidden: no
    sql: (select c.id FROM UNNEST(${item_categories}) AS c where c.category_set_name = 'Purchasing') ;;
    view_label: "TEST STUFF"
  }

  measure: count_inventory_item_id {
    view_label: "TEST STUFF"
    hidden: no
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }
  # (SELECT value.string_value FROM UNNEST(event_params) AS param WHERE param.key='page_location')

  dimension: test_parameter_value {
    view_label: "TEST STUFF"
    hidden: no
    type: string
    sql: {% assign p = parameter_display_product_level._parameter_value %}'{{p}}' ;;
  }

  measure: count_distinct_item_part_number {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${item_part_number},'Unknown') ;;
  }

  dimension: booking2_amount {
    hidden: no
    view_label: "TEST STUFF"
    group_label: "Amounts"
    label: "Booking2 Amount (Source Currency)"
    sql: IF(${is_booking},${ordered_amount},0) ;;
    value_format_name: decimal_2
  }

  dimension: is_diff_booking_amounts {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${booking_amount}<>${booking2_amount} ;;
  }


  dimension: liquid_view_name2 {
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign v = _view._name  %}
          {% if v contains "sales_orders_daily_agg" %}{% assign f = "ITEM_CATEGORY_ID"%}
            {% elsif v contains "item_categories" %}{% assign f = "ID" %}
            {% else %}{% assign f = "subquery" %}

      {%endif%} --vn {{v}}
      '{{f}}';;
  }

  measure: total_ordered_quantity {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${ordered_quantity} ;;
  }

  measure: total_booking_quantity {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${booking_quantity} ;;
  }

  measure: total_backlog_quantity {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${backlog_quantity} ;;
  }

  measure: total_fulfilled_quantity {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${fulfilled_quantity} ;;
  }

  measure: total_shipped_quantity {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${shipped_quantity} ;;
  }

  measure: total_invoiced_quantity {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${invoiced_quantity} ;;
  }




  dimension: test_unit_list_price_target_currency {
    hidden: no
    type: string
    view_label: "TEST STUFF"
    label: "@{label_build}"
    # label: "{% if _field._is_selected %}@{label_derive_field_name}{{field_name}} (@{label_get_target_currency}){%else%}{{field_name}} (Target Currency){%endif%}"
    sql: '1'  ;;


  }
#(% for w in fname_array %}
          #     {% assign field_name = field_name | append: w %}
          # {% endfor %}
          # {{field_name}} ;;

# {% assign parameter_key = parameter | split:'=' | first %}
  measure: test_links {
    type: number
    hidden: no
    view_label: "TEST STUFF"
    sql: max(1);;
    # html: @{link_sales_orders_to_details_dashboard_extra_mapping}{{extra_mapping}};;
    html: {% assign expl = _explore._name %}{{expl}} ;;
    # html: @{link_sales_orders_to_details_dashboard_extra_mapping}
    #   {% assign filters_mapping = '@{link_sales_orders_to_details_dashboard}'%}
    #   {% if append_extra_mapping == true %}
    #     {% assign filters_mapping = filters_mapping | append: extra_mapping %}
    #   {% endif %}{{filters_mapping}}
    #   ;;
  }

  measure: total_sales_visual_drill {
    hidden: no
    type: sum
    value_format_name: usd
    view_label: "TEST STUFF"
    sql: ${ordered_amount_target_currency} ;;
    drill_fields: [total_sales_visual_drill, sales_orders.ordered_month_num, sales_orders.ordered_year]
    link: {
      label: "Show Amount by Month and Year"
      url: "
      {% assign vis_config = '{
      \"stacking\" : \"normal\",
      \"legend_position\" : \"right\",
      \"x_axis_gridlines\" : false,
      \"y_axis_gridlines\" : true,
      \"show_view_names\" : false,
      \"y_axis_combined\" : true,
      \"show_y_axis_labels\" : true,
      \"show_y_axis_ticks\" : true,
      \"y_axis_tick_density\" : \"default\",
      \"show_x_axis_label\" : true,
      \"show_x_axis_ticks\" : true,
      \"show_null_points\" : false,
      \"interpolation\" : \"monotone\",
      \"type\" : \"looker_line\",
      \"colors\": [
      \"#5245ed\",
      \"#ff8f95\",
      \"#1ea8df\",
      \"#353b49\",
      \"#49cec1\",
      \"#b3a0dd\"
      ],
      \"x_axis_label\" : \"Month Number\"
      }' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&sorts=sales_orders.ordered_year+asc,sales_orders.created_month_num+asc&pivots=sales_orders.ordered_year&toggle=dat,pik,vis&limit=500&column_limit=15"
    } # NOTE the &pivots=
  }

  measure: sum_total_cycle_time_days {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${cycle_time_days} ;;
  }


   }
