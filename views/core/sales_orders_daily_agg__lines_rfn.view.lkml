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
# Extends view otc_common_item_categories_ext
# Extends view sales_orders_common_amount_measures_ext
#
# REFERENCED BY
# Explore sales_orders_daily_agg
#
# EXTENDED FIELDS
#    item_description, language_code,
#    category_id, category_description, category_name_code
#    total_sales_amount_target_currency, total_booking_amount_target_currency, and other amounts
#
# REPEATED STRUCTS
# Includes repeated structs AMOUNTS (defined in separate views for unnesting):
#     sales_orders_daily_agg__lines__amounts - provides Total Amounts converted to Target Currencies by Item Categories & Item Organication
# NOTE: Select fields from AMOUNTS have been defined here so the separate view does not have to be included in the Explore.
#
# CAVEATS
# - View appears in Explore as Sales Orders Daily Agg: Item Categories.
# - This table includes both ORDER and RETURN lines. Use line_category_code to pick which to include.
# - All of the OTC dashboards focus on ORDERS and exclude RETURNS from dashboards.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - When field name is duplicated in header (like is_open), the sql property is restated to use the ${TABLE} reference.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}


include: "/views/base/sales_orders_daily_agg__lines.view"
include: "/views/core/otc_common_item_categories_ext.view"
include: "/views/core/sales_orders_common_amount_measures_ext.view"


view: +sales_orders_daily_agg__lines {
  fields_hidden_by_default: yes
  label: "Sales Orders Daily Agg: Item Categories"
  extends: [otc_common_item_categories_ext,sales_orders_common_amount_measures_ext]

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
    hidden: yes
    type: yesno
    description: "Line Category Code equals Order (and is not a return)"
    sql: ${line_category_code} = 'ORDER' ;;
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

#########################################################
# DIMENSION: Amounts
#{
# Pulls amounts from AMOUNTS Repeated Struct so that a separate view
# does not have to be included in Explore.
#
# Only the Amount for the Target Currency Code that matches the value
# in otc_common_parameters_xvw.parameter_target_currency is returned.
#
# Dimensions hidden from Explore as Measures are shown instead

  dimension: target_currency_code {
    hidden: no
    type: string
    # group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: ordered_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    sql: (select SUM(TOTAL_ORDERED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: booking_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    sql: (select SUM(TOTAL_BOOKING) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: backlog_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    sql: (select SUM(TOTAL_BACKLOG) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    sql: (select SUM(TOTAL_FULFILLED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    sql: (select SUM(TOTAL_SHIPPED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: invoiced_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    sql: (select SUM(TOTAL_INVOICED) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE = ${target_currency_code} ) ;;
    value_format_name: decimal_2
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    # group_label: "Amounts"
    sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM sales_orders_daily_agg__lines.amounts WHERE TARGET_CURRENCY_CODE =  ${target_currency_code}) ;;
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amounts
#{

  measure: total_num_order_lines {
    hidden: yes
    type: sum
    label: "Total Order Lines"
    description: "Total number of order lines."
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



#} end non-amount measures

#########################################################
# MEASURES: Amounts
#{
  measure: total_backlog_amount_target_currency_formatted {
    link: {
      label: "Show Customers with Highest Backlog"
      url: "{{dummy_backlog_by_customer._link}}"
      # url: "@{link_generate_variable_defaults}
      # {% assign link = link_generator._link %}
      # {% assign drill_fields = 'sales_orders_daily_agg.selected_customer_number,sales_orders_daily_agg.selected_customer_name,sales_orders_dialy_agg__lines.total_backlog_amount_target_currency'%}
      # {% assign measure = 'sales_orders_dialy_agg__lines.total_backlog_amount_target_currency' %}
      # @{link_generate_explore_url}
      # "
    }
    link: {
      label: "Show Categories with Highest Backlog"
      url: "{{dummy_backlog_by_category._link}}"
      }
  }

  measure: average_ordered_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders_common_amount_measures_ext
    #description defined in sales_orders_common_amount_measures_ext
    sql: SAFE_DIVIDE(${total_ordered_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_order_count})) ;;
    #value format defined in sales_orders_common_amount_measures_ext
  }

#} end amounts

#########################################################
# MEASURES: Misc
#{
  measure: alert_note_for_incomplete_currency_conversion {
    hidden: no
    type: max
    description: "Provides a note in html when a source currency could not be converted to target currency. Add this measure to a table or single value visualization to alert users that amounts in target currency may be understated."
    sql: ${is_incomplete_conversion} ;;
    html: {% if value == true %}For timeframe and target currency selected, some source currencies could not be converted to the target currency. Reported amounts may be understated. Please confirm Currency Conversion table is up-to-date.{% else %}{%endif%} ;;
  }
#} end misc

#########################################################
# MEASURES: Helper
#{
# used to support links and drills; hidden from explore

  measure: dummy_backlog_by_customer {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [backlog_by_customer*]
  }

  measure: dummy_backlog_by_category {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [backlog_by_category*]
  }

#} end helper measures

#########################################################
# SETS

  set: backlog_by_customer {
    fields: [sales_orders_daily_agg.selected_customer_number, sales_orders_daily_agg.selected_customer_name, total_backlog_amount_target_currency]
  }

  set: backlog_by_category {
    fields: [category_description, total_backlog_amount_target_currency]
  }
#} end sets

}
