#########################################################{
# PURPOSE
# The SalesOrdersDailyAgg table and its corresponding Looker view sales_orders_daily_agg reflect
# an aggregation of orders by the following dimensions:
#   Ordered Date
#   Business Unit ID
#   Order Source ID
#   Order Category Code
#   Sold To Site ID
#   Ship To Site ID
#   Bill To Site ID
#
# SOURCES
# Refines base view sales_orders_daily_agg
# Extends view sales_orders_common_dimensions_ext
# Extends view sales_orders_common_count_measures_ext
#
# REFERENCED BY
# Explore sales_orders_daily_agg
#
# EXTENDED FIELDS
# Extends common dimensions:
#    parameter_customer_type, selected_customer_number, selected_customer_name,
#    selected_customer_country plus bill_to_customer_*, ship_to_customer_*,
#    and sold_to_customer_* dimensions
#
# Extends common count and percent of sales orders measures:
#    e.g., cancelled_sales_order_percent, fulfilled_sales_order_percent, etc...
#
# REPEATED STRUCTS
# Includes repeated structs LINES (defined in separate views for unnesting):
#     sales_orders_daily_agg__lines - provides Cycle Days and Order Line Counts by Item Categories, Item Organization
#
# CAVEATS
# - Aggregates by Order Category Code (ORDER, RETURN, MIXED) so should filter on this dimension to exclude returns.
# - Order Counts in this view cannot be aggregated across or filtered by categories and are defined to return warning message
#   if categories are included in the query. If you need order counts by category (or filtered by category)
#   use the sales_orders view and Explore.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
#########################################################}

include: "/views/base/sales_orders_daily_agg.view"
include: "/views/core/sales_orders_common_dimensions_ext.view"
include: "/views/core/sales_orders_common_count_measures_ext.view"

view: +sales_orders_daily_agg {

  fields_hidden_by_default: yes
  extends: [sales_orders_common_dimensions_ext,sales_orders_common_count_measures_ext]

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${ordered_date_key},${business_unit_id},${order_source_id},${order_category_code}
                ,${sold_to_site_use_id},${bill_to_site_use_id},${ship_to_site_use_id}) ;;
  }

  dimension: ordered_date_key {
    type: date
    hidden: yes
    sql: ${TABLE}.ORDERED_DATE ;;
    convert_tz: no
  }

#########################################################
# DIMENSIONS: Dates
#{

  dimension_group: ordered {
    hidden: no
    }

  dimension: ordered_month_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Month Number"
    description: "Ordered month as number 1 to 12"
  }

  dimension: ordered_quarter_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Quarter Number"
    description: "Ordered quarter as number 1 to 4"
  }

  dimension: ordered_year_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Year Number"
    description: "Ordered year as integer"
    value_format_name: id
  }

  dimension: order_category_code {
    hidden: no
    sql: UPPER(${TABLE}.ORDER_CATEGORY_CODE);;
  }

#} end dates

#########################################################
# DIMENSIONS: Business Unit and Order Source
#{

  dimension: business_unit_id {hidden: no}

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CAST(${business_unit_id} as STRING)) ;;
  }

  dimension: order_source_id {
    hidden: no
    sql: COALESCE(${TABLE}.ORDER_SOURCE_ID,-1);;
  }

  dimension: order_source_name {
    hidden: no
    sql: COALESCE(${TABLE}.ORDER_SOURCE_NAME,"Unknown") ;;
  }

#} end business unit and order source

#########################################################
# DIMENSIONS: Customer
#{
# selected_customer_name, _country and _type extended from sales_orders_common_dimensions_ext

  dimension: bill_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_country {
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: sold_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.SOLD_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: sold_to_customer_country {
    sql: COALESCE(${TABLE}.SOLD_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

  dimension: ship_to_customer_name {
    hidden: no
    sql: COALESCE(${TABLE}.SHIP_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: ship_to_customer_country {
    sql: COALESCE(${TABLE}.SHIP_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end customer

#########################################################
# MEASURES: Counts
#{

  measure: order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders}{%endif%} ;;
  }

  measure: sales_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }

  measure: return_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders}{%endif%} ;;
    filters: [order_category_code: "RETURN"]
  }

  measure: blocked_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_blocked_orders}{%endif%};;
  }

  measure: cancelled_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_cancelled_orders}{%endif%};;
  }

  measure: fillable_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_fillable_orders}{%endif%} ;;
  }

  measure: fulfilled_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_fulfilled_orders}{%endif%} ;;
  }

  measure: fulfilled_by_request_date_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_fulfilled_by_request_date}{%endif%} ;;
  }

  measure: fulfilled_by_promise_date_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_fulfilled_by_promise_date}{%endif%} ;;
  }

  measure: has_backorder_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_backordered_orders}{%endif%};;
  }

#--> filter to sales orders as not relevant to returns
  measure: has_return_sales_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_with_returns}{%endif%};;
    filters: [order_category_code: "-RETURN"]
  }

  measure: no_holds_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_with_no_holds}{%endif%} ;;
  }

  measure: non_cancelled_order_count {
    hidden: no
    type: number
    #label & description defined in sales_orders_common_count_measures_ext
    sql: ${order_count} - ${cancelled_order_count};;
  }

  measure: open_order_count {
    hidden: no
    type: sum
    #label & description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_open_orders}{%endif%} ;;
  }

#} end count measures



 }
