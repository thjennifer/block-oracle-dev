  # set full suggestions to yes so that filter suggestions populate properly for nested fields
  # value of yes means Looker queries the nest field as part of the full explore rather than a standalone table

include: "/views/base/sales_orders_daily_agg__lines.view"
include: "/views/core/sales_orders_common_amount_measures_ext.view"
include: "/views/core/otc_unnest_item_categories_common_fields_ext.view"

view: +sales_orders_daily_agg__lines {
  fields_hidden_by_default: no
  label: "Sales Orders Daily Agg: Item Categories"
  extends: [sales_orders_common_amount_measures_ext,otc_unnest_item_categories_common_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg.key},${category_set_id},${category_id},${item_organization_id},${line_category_code}) ;;
  }

  dimension: category_set_id {
    sql:  COALESCE(${TABLE}.ITEM_CATEGORY_SET_ID,-1) ;;
    full_suggestions: yes
  }

  dimension: category_set_name {
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_SET_NAME,"Unknown") ;;
    full_suggestions: yes
    }

  dimension: item_category_id {
    hidden: yes
    primary_key: no
  }

  dimension: line_category_code {
    hidden: no
    sql:  COALESCE(${TABLE}.LINE_CATEGORY_CODE,IF(${sales_orders_daily_agg.order_category_code}='MIXED','Unknown',${sales_orders_daily_agg.order_category_code})) ;;
  }

  dimension: is_sales_order {
    hidden: no
    type: yesno
    description: "Line Category Code equals Order (and is not a return)"
    sql: ${line_category_code} = 'ORDER' ;;
    full_suggestions: yes
  }

  # dimension: category_id {
  #   hidden: no
  #   sql: COALESCE(${TABLE}.ITEM_CATEGORY_ID,-1) ;;
  #   full_suggestions: yes
  # }

  # dimension: category_name_code {
  #   hidden: no
  #   sql: COALESCE(${TABLE}.ITEM_CATEGORY_NAME,"Unknown") ;;
  #   full_suggestions: yes
  # }

  # dimension: category_description {
  #   hidden: no
  #   sql: COALESCE(${TABLE}.category_description,COALESCE(CAST(NULLIF(${item_category_id},-1) AS STRING),"Unknown")) ;;
  #   full_suggestions: yes
  # }

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
    hidden: no
    type: number
    sql: (select SUM(TOTAL_ORDERED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: invoiced_amount_target_currency {
    hidden: no
    type: number
    sql: (select SUM(TOTAL_INVOICED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: is_incomplete_conversion {
    type: yesno
    sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
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
    sql: {% if item_category_id._is_selected or category_description._is_selected%}SAFE_DIVIDE(${sum_total_cycle_time_days},${total_num_fulfilled_order_lines}){%else%}sum(null){%endif%} ;;
    value_format_name: decimal_2
  }

  # measure: total_sales_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   #label defined in sales_orders__lines_common_fields_ext
  #   #description defined in sales_orders__lines_common_fields_ext
  #   sql: ${ordered_amount_target_currency} ;;
  #   # filters: [line_category_code: "-RETURN"]
  #   #value format defined in sales_orders__lines_common_fields_ext
  # }

  measure: average_sales_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders_common_amount_measures_ext
    #description defined in sales_orders_common_amount_measures_ext
    sql: SAFE_DIVIDE(${total_sales_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_sales_order_count})) ;;
    #value format defined in sales_orders_common_amount_measures_ext
  }

  # measure: total_invoiced_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   #label defined in sales_orders__lines_common_fields_ext
  #   #description defined in sales_orders__lines_common_fields_ext
  #   sql: ${invoiced_amount_target_currency} ;;
  #   # filters: [line_category_code: "-RETURN"]
  #   #value format defined in sales_orders__lines_common_fields_ext
  # }

 }
