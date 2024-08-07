#########################################################{
# PURPOSE
# The SalesOrderDailyAgg table and its corresponding Looker view sales_order_daily_agg reflect
# an aggregation of orders by the following dimensions:
#   Ordered Date
#   Business Unit ID
#   Order Source ID
#   Sold To Site ID
#   Ship To Site ID
#   Bill To Site ID
#
# Provides various Orders Counts like Sales Orders, Open Orders, Blocked Orders, etc...
# Includes NESTED Structs (eeach defined in sepaprate views and joined in Explore):
#     sales_orders_daily_agg__lines - provides Cycle Days and Order Line Counts by Item Categories, Item Organization
#     sales_orders_daily_agg__lines__amounts - provides Total Amounts cconverted to Target Currencies by Item Categories & Item Organication
#
# SOURCES
# Refines base view sales_order_daily_agg
# Extends view sales_orders_common_dimensions_ext which provides labels for:
#     business unit
#     order source
#     sold to/ship to/bill to customers
#
# REFERENCED BY
# Explore sales_order_daily_agg
#
# KEY MEASURES
#
# CAVEATS
# Order Counts in this view cannot be aggregated across categories and are defined to return 0 if categories are included.
# If you need order counts by category (or filtered by category) use the sales_orders view and Explore
#
# HOW TO USE
# Fields are hidden by default so to expose a field in Explore set hidden property to no
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

  dimension_group: ordered {
    hidden: no
    }

  dimension: ordered_month_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Month Num"
    description: "Ordered Month as Number 1 to 12"
  }

  dimension: ordered_quarter_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Quarter Num"
    description: "Ordered Quarter as Number 1 to 4"
  }

  dimension: ordered_year_num {
    hidden: no
    group_label: "Ordered Date"
    group_item_label: "Year Num"
    description: "Ordered Year as Integer"
    value_format_name: id
  }

  dimension: order_category_code {
    hidden: no
    sql: UPPER(${TABLE}.ORDER_CATEGORY_CODE);;
  }


#########################################################
# Business Unit and Order Source Dimensions
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
    sql: COALESCE(${TABLE}.ORDER_SOURCE_NAME,COALESCE(CAST(NULLIF(${order_source_id},-1) AS STRING),"Unknown")) ;;
  }

  dimension: bill_to_customer_name {
    # hidden: no
    # group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CAST(${bill_to_customer_number} AS STRING)) ;;
  }
#} end business unit and order source dimensions

#########################################################
# Measures
#{

  measure: count {
    hidden: yes
    label: "Row Count"}

  measure: order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders}{%endif%} ;;
  }

  measure: sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }

  measure: return_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders}{%endif%} ;;
    filters: [order_category_code: "RETURN"]
  }

  measure: has_backorder_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_backordered_orders}{%endif%};;
    filters: [order_category_code: "-RETURN"]
  }

  measure: blocked_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_blocked_orders}{%endif%};;
    filters: [order_category_code: "-RETURN"]
  }

  measure: cancelled_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_cancelled_orders}{%endif%};;
    filters: [order_category_code: "-RETURN"]
  }

  measure: fillable_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_fillable_orders}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }


  measure: fulfilled_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_fulfilled_orders}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }

  measure: fulfilled_by_request_date_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_fulfilled_by_request_date}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }

  measure: fulfilled_by_promise_date_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_fulfilled_by_promise_date}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }

  measure: has_return_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_with_returns}{%endif%};;
    filters: [order_category_code: "-RETURN"]
  }

  measure: no_holds_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_orders_with_no_holds}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }

  measure: non_cancelled_sales_order_count {
    hidden: no
    type: number
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: ${sales_order_count} - ${cancelled_sales_order_count};;
  }

  measure: open_sales_order_count {
    hidden: no
    type: sum
    #label defined in sales_orders_common_count_measures_ext
    #description defined in sales_orders_common_count_measures_ext
    sql: @{is_agg_category_in_query}NULL{%else%}${num_open_orders}{%endif%} ;;
    filters: [order_category_code: "-RETURN"]
  }




#} end measures


 }