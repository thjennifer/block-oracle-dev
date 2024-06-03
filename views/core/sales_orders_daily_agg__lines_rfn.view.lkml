  # set full suggestions to yes so that filter suggestions populate properly for nested fields
  # value of yes means Looker queries the nest field as part of the full explore rather than a standalone table

include: "/views/base/sales_orders_daily_agg__lines.view"
include: "/views/core/sales_orders__lines_common_fields_ext.view"

view: +sales_orders_daily_agg__lines {
  fields_hidden_by_default: yes
  label: "Sales Orders Daily Agg: Item Categories"
  extends: [sales_orders__lines_common_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg.key},${item_category_set_id},${item_category_id},${item_organization_id}) ;;
  }

  dimension: item_category_set_id {
    sql:  COALESCE(${TABLE}.ITEM_CATEGORY_SET_ID,-1) ;;
    full_suggestions: yes
  }

  dimension: item_category_set_name {
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_SET_NAME,"Unknown") ;;
    full_suggestions: yes
    }

  dimension: item_category_id {
    hidden: no
    primary_key: no
    label: "Item Category ID"
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_ID,-1) ;;
    full_suggestions: yes
  }

  dimension: item_category_name {
    hidden: no
    label: "Item Category Name Group"
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_NAME,"Unknown") ;;
    full_suggestions: yes
  }

  dimension: item_category_description {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_DESCRIPTION,COALESCE(CAST(NULLIF(${item_category_id},-1) AS STRING),"Unknown")) ;;
    full_suggestions: yes
  }

  dimension: item_organization_id {
    hidden:no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_ID,-1) ;;
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(NULLIF(${item_organization_id},-1) AS STRING)) ;;
    full_suggestions: yes
  }

  dimension: ordered_amount_target_currency {
    type: number
    sql: (select TOTAL_ORDERED FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = {% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: is_incomplete_conversion {
    type: yesno
    sql: (select IS_INCOMPLETE_CONVERSION FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = {% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  measure: total_num_order_lines {
    hidden: yes
    type: sum
    label: "Total Order Lines"
    description: "Total number of non-cancelled order lines."
    sql: ${num_order_lines} ;;
  }

  measure: total_num_fulfilled_order_lines {
    hidden: yes
    type: sum
    label: "Total Fulfilled Order Lines"
    description: "Total number of fulfilled order lines."
    sql: ${num_fulfilled_order_lines} ;;
  }

  measure: sum_total_cycle_time_days {
    hidden: yes
    type: sum
    description: "Total cycle time days of non-cancelled order lines."
    sql: ${total_cycle_time_days} ;;
  }

  measure: average_cycle_time_days {
    hidden: no
    type: number
    description: "Average number of days from order to fulfillment per order line. Item Category must be in query or compution will return null."
    sql: {% if item_category_id._is_selected or item_category_description._is_selected%}SAFE_DIVIDE(${sum_total_cycle_time_days},${total_num_fulfilled_order_lines}){%else%}sum(null){%endif%} ;;
    value_format_name: decimal_2
  }

  measure: total_sales_amount_target_currency {
    hidden: no
    type: sum
    #label defined in sales_orders__lines_common_fields_ext
    #description defined in sales_orders__lines_common_fields_ext
    sql: ${ordered_amount_target_currency} ;;
    #value format defined in sales_orders__lines_common_fields_ext
  }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders__lines_common_fields_ext
    #description defined in sales_orders__lines_common_fields_ext
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_order_count})) ;;
    #value format defined in sales_orders__lines_common_fields_ext
  }


 }
