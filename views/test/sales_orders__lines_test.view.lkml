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

  # measure: total2_fulfilled_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Total2 Fulfilled Amount ({{currency}}){%else%}Total2 Fulfilled Amount (Target Currency){%endif%}"
  #   sql: ${ordered_amount_target_currency} ;;
  #   filters: [sales_orders__lines.is_fulfilled: "Yes", line_category_code: "-RETURN"]
  #   value_format_name: decimal_0
  # }

  # measure: total2_shipped_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Total2 Shipped Amount ({{currency}}){%else%}Total2 Shipped Amount (Target Currency){%endif%}"
  #   sql: ${shipped_amount_target_currency} ;;
  #   filters: [line_category_code: "-RETURN"]
  #   value_format_name: decimal_0
  # }

   }
