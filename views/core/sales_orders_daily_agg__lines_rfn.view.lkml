#########################################################{
# PURPOSE
# UNNESTED view of Repeated Struct LINES found in sales_orders_daily_agg
#
# "LINES" are unique values for:
#     Category Set ID
#     Category ID
#     Item Organization ID
#     Line Category Code (ORDER or RETURN)
#
# SOURCES
# Refines base view sales_order_daily_agg__lines
# Extends views:
#   otc_common_item_categories_ext
#   otc_common_currency_fields_ext
#   sales_orders_common_amount_fields_ext
#
# REFERENCED BY
# Explore sales_orders_daily_agg
#
# EXTENDED FIELDS
#    item_description, language_code,
#    category_id, category_description, category_name_code,
#    target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#    total_sales_amount_target_currency, total_booking_amount_target_currency, and other amounts
#
# REPEATED STRUCTS
# Includes repeated structs AMOUNTS (defined in separate views for unnesting):
#     sales_orders_daily_agg__lines__amounts - provides Total Amounts converted to Target Currencies by Item Categories & Item Organization
#
# NOTES
# - Amounts where target_currency matches the value of parameter_target_currency are defined in this view.
# - View appears in Explore as Sales Orders Daily Agg: Item Categories.
# - This table includes both ORDER and RETURN lines. Use line_category_code to pick which to include.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - When the field name is duplicated in header sales_orders_daily_agg, the sql property is restated to use the ${TABLE} reference.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_orders_daily_agg__lines.view"
include: "/views/core/otc_common_item_categories_ext.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_orders_common_amount_fields_ext.view"

view: +sales_orders_daily_agg__lines {
  fields_hidden_by_default: yes
  label: "Sales Orders Daily Agg: Item Categories"
  extends: [otc_common_item_categories_ext, otc_common_currency_fields_ext, sales_orders_common_amount_fields_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg.key},${category_set_id},${category_id},${item_organization_id},${line_category_code}) ;;
  }

  dimension: line_category_code {
    hidden: no
    sql:  COALESCE(${TABLE}.LINE_CATEGORY_CODE,IF(${sales_orders_daily_agg.order_category_code}='MIXED','Unknown',${sales_orders_daily_agg.order_category_code})) ;;
    full_suggestions: yes
  }

  dimension: is_sales_order {
    hidden: yes
    type: yesno
    description: "Indicates Line Category Code equals ORDER"
    sql: ${line_category_code} = 'ORDER' ;;
    full_suggestions: yes
  }

  dimension: item_organization_id {
    hidden: no
    full_suggestions: yes
  }

  dimension: item_organization_name {
    hidden: no
    sql: COALESCE(${TABLE}.ITEM_ORGANIZATION_NAME,CAST(${item_organization_id} AS STRING)) ;;
    full_suggestions: yes
  }


#########################################################
# DIMENSION: Item Categories
#{
# category_id, category_description and category_name_code extended from otc_common_item_categories_ext

  dimension: category_set_id {
    sql:  COALESCE(${TABLE}.ITEM_CATEGORY_SET_ID,-1) ;;
    full_suggestions: yes
  }

  dimension: category_set_name {
    sql: COALESCE(${TABLE}.ITEM_CATEGORY_SET_NAME,"Unknown") ;;
    full_suggestions: yes
  }

#--> category_id used instead so can hide this one and remove as primary key
  dimension: item_category_id {
    hidden: yes
    primary_key: no
  }

#} end item categories

#########################################################
# DIMENSION: Amounts
#{
# Pulls amounts from AMOUNTS Repeated Struct so that a separate view
# does not have to be included in Explore.
#
# Target Currency Code and Is Incomplete Conversion extended from
# otc_common_currency_fields_ext
#
# Only the Amount for the Target Currency Code that matches the value
# in otc_common_parameters_xvw.parameter_target_currency is returned.
#
# Dimensions hidden from Explore as Measures are shown instead.
# Other field properties extended from sales_orders_common_amount_fields_ext

  dimension: ordered_amount_target_currency {
    sql: (select SUM(TOTAL_ORDERED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: booking_amount_target_currency {
    sql: (select SUM(TOTAL_BOOKING) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: backlog_amount_target_currency {
    sql: (select SUM(TOTAL_BACKLOG) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: fulfilled_amount_target_currency {
    sql: (select SUM(TOTAL_FULFILLED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: shipped_amount_target_currency {
    sql: (select SUM(TOTAL_SHIPPED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: invoiced_amount_target_currency {
    sql: (select SUM(TOTAL_INVOICED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code} ) ;;
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amounts
#{

  measure: total_num_order_lines {
    hidden: yes
    type: sum
    label: "Total Order Lines"
    description: "Total number of order lines"
    sql: ${num_order_lines} ;;
  }

  measure: total_num_fulfilled_order_lines {
    hidden: yes
    type: sum
    label: "Total Fulfilled Order Lines"
    description: "Total number of fulfilled order lines"
    sql: ${num_fulfilled_order_lines} ;;
  }

  measure: sum_total_cycle_time_days {
    hidden: yes
    type: sum
    description: "Total cycle time days of non-cancelled order lines"
    sql: ${total_cycle_time_days} ;;
  }

#--> Category to be selected as a dimension in query or returns NULL
  measure: average_cycle_time_days {
    hidden: no
    type: number
    description: "Average number of days from order to fulfillment per order line. Item Category must be in query or computation will return null"
    sql: {%- if category_id._is_selected or category_description._is_selected -%}SAFE_DIVIDE(${sum_total_cycle_time_days},${total_num_fulfilled_order_lines}){%- else -%}SUM(NULL){%- endif -%} ;;
    value_format_name: decimal_2
  }


#} end non-amount measures

#########################################################
# MEASURES: Amounts
#{
# updates to measures extended from sales_orders_common_amount_fields_ext
# and/or new measures

#--> Returns NULL if Category or Item Organization is in query as order counts cannot be summed across categories
  measure: average_ordered_amount_per_order_target_currency {
    hidden: no
    type: number
    #label & description defined in sales_orders_common_amount_fields_ext
    sql: SAFE_DIVIDE(${total_ordered_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_order_count})) ;;
  }

#} end amounts



}
