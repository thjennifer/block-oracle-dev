#########################################################{
# PURPOSE
# UNNESTED view of Repeated STRUCT amounts found in sales_orders_daily_agg__lines table.
# Provides amounts by target_currency_code and is_incomplete_conversion
#
# SOURCES
# Refines View sales_orders_daily_agg__lines__amounts (defined in /views/base folder)
# Extends View:
#   otc_common_currency_fields_ext
#   sales_orders_common_amount_measures_ext
#
# REFERENCED BY
# not used but could optionally be added to sales_orders_daily_agg explore
#
# EXTENDED FIELDS
#    target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#    total_sales_amount_target_currency, total_booking_amount_target_currency, and other amounts
#
# NOTES
# - Amounts where target currency matches value of parameter_target_currency are
#   pulled into sales_orders_daily_agg__lines so this view is not used
# - Original fields TOTAL_ORDERED, etc... replaced with dimensions like ordered_amount_target_currency to
#   faciltate extending order amount measures across multiple views.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Full suggestions set to yes so that filter suggestions populate properly for nested fields.
#
#########################################################}

include: "/views/base/sales_orders_daily_agg__lines__amounts.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_orders_common_amount_measures_ext.view"


view: +sales_orders_daily_agg__lines__amounts {

  fields_hidden_by_default: yes
  extends: [otc_common_currency_fields_ext, sales_orders_common_amount_measures_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_orders_daily_agg__lines.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  dimension: target_currency_code {
    # label, description defined in otc_common_currency_fields_ext
    sql: COALESCE(${TABLE}.TARGET_CURRENCY_CODE,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
    full_suggestions: yes
  }

  dimension: is_incomplete_conversion {
    # label, description defined in otc_common_currency_fields_ext
    sql: COALESCE(${TABLE}.IS_INCOMPLETE_CONVERSION,FALSE) ;;
    full_suggestions: yes
  }

  dimension: is_sales_order {
    hidden: yes
    type: yesno
    sql: ${sales_orders_daily_agg__lines.line_category_code} = 'ORDER' ;;
    full_suggestions: yes
  }

#########################################################
# DIMENSIONS: Amounts
#{
# Dimensions hidden from Explore as Measures are shown instead

  dimension: ordered_amount_target_currency {
    hidden: yes
    sql: ${total_ordered} ;;
    value_format_name: decimal_2
  }

  dimension: booking_amount_target_currency {
    hidden: yes
    sql: ${total_booking} ;;
    value_format_name: decimal_2
  }

  dimension: backlog_amount_target_currency {
    hidden: yes
    sql: ${total_backlog} ;;
    value_format_name: decimal_2
  }

  dimension: fulfilled_amount_target_currency {
    hidden: yes
    sql: ${total_fulfilled} ;;
    value_format_name: decimal_2
  }

  dimension: shipped_amount_target_currency {
    hidden: yes
    sql: ${total_shipped} ;;
    value_format_name: decimal_2
  }

  dimension: invoiced_amount_target_currency {
    hidden: yes
    sql: ${total_invoiced} ;;
    value_format_name: decimal_2
  }

#} end amounts as dimensions

#########################################################
# MEASURES: Amounts
#{
# updates to measures extended from sales_orders_common_amount_measures_ext
# and/or new measures

#--> Returns NULL if Category or Item Organization is in query as order counts cannot be summed across categories
  measure: average_ordered_amount_per_order_target_currency {
    hidden: no
    type: number
    #label defined in sales_orders_common_amount_measures_ext
    #description defined in sales_orders_common_amount_measures_ext
    sql: SAFE_DIVIDE(${total_ordered_amount_target_currency},(${sales_orders_daily_agg.non_cancelled_order_count})) ;;
    #value format defined in sales_orders_common_amount_measures_ext
  }

#} end measures

 }
