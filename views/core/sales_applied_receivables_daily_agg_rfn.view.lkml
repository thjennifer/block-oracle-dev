#########################################################{
# PURPOSE
# The SalesAppliedReceivablesDailyAgg table and its corresponding Looker view
# sales_applied_receivables_daily_agg reflect an aggregation of payments by the following dimensions:
#   Deven Date
#   Business Unit ID
#   Application Type
#   Bill To Site ID
#
# SOURCES
#   Refines base view sales_applied_receivables_daily_agg
#   Extends views:
#     otc_common_currency_fields_ext
#     sales_applied_receivables_common_amount_measures_ext
#
# REFERENCED BY
#   Explore sales_applied_receivables_daily_agg
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#   total_amount_applied_target_currency, total_amount_received_target_currency, etc...
#
# REPEATED STRUCTS
# Includes repeated structs AMOUNTS (defined in separate views for unnesting):
#     sales_applied_receivables_daily_agg__amounts - provides Total Amounts converted to Target Currencies
#
# NOTES
# - Amounts where target_currency matches the value of parameter_target_currency are defined in this view.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
#
#########################################################}

include: "/views/base/sales_applied_receivables_daily_agg.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_applied_receivables_common_amount_measures_ext.view"

view: +sales_applied_receivables_daily_agg {
  fields_hidden_by_default: yes
  extends: [otc_common_currency_fields_ext, sales_applied_receivables_common_amount_measures_ext]

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${event_raw},${bill_to_site_use_id},${business_unit_id},${application_type}) ;;
  }

  dimension: application_type {
    hidden: no
  }

  dimension: business_unit_id {
    hidden: no
    value_format_name: id
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

#########################################################
# DIMENSIONS: Customer
#{

  dimension: bill_to_site_use_id {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_number {
    hidden: no
    group_label: "Bill to Customer"
    value_format_name: id
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end customer dimensions

#########################################################
# DIMENSIONS: Dates
#{
# Fiscal Dates extended from otc_common_fiscal_gl_dates_ext and grouped under Ledger Date

  dimension_group: event {
    hidden: no
  }

  dimension: event_month_num {
    hidden: no
    group_label: "Event Date"
    group_item_label: "Month Number"
    description: "Event Month as Number 1 to 12"
  }

  dimension: event_quarter_num {
    hidden: no
    group_label: "Event Date"
    group_item_label: "Quarter Number"
    description: "Event Quarter as Number 1 to 4"
  }

  dimension: event_year_num {
    hidden: no
    group_label: "Event Date"
    group_item_label: "Year Number"
    description: "Event Year as Integer"
    value_format_name: id
  }

#} end date dimensions


#########################################################
# DIMENSIONS: Amounts
#{
# amounts hidden as measures are shown instead

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: (select SUM(TOTAL_APPLIED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: cash_receipt_amount_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: (select SUM(TOTAL_RECEIVED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }



#} end amount dimensions

   }
