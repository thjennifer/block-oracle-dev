#########################################################{
# PURPOSE
# The SalesPaymentsDailyAgg table and its corresponding Looker view sales_payment_daily_agg reflect
# an aggregation of payments by the following dimensions:
#   Transaction Date
#   Business Unit ID
#   Payment Class Code
#   Bill To Site ID
#
# SOURCES
#   Refines base view sales_payments_daily_agg
#   Extends views:
#     otc_common_currency_fields_ext
#     sales_payments_common_amount_fields_ext
#   References sales_payments_daily_agg_test_data_sdt if test data is used
#
# REFERENCED BY
#   Explore sales_payments_daily_agg
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#   total_amount_adjusted_target_currency, total_amount_applied_target_currency, etc...
#
# REPEATED STRUCTS
# Includes repeated structs AMOUNTS (defined in separate views for unnesting):
#     sales_payments_daily_agg__amounts - provides Total Amounts converted to Target Currencies
#
# NOTES
# - This view includes Payments related to Invoices, Cash Receipts, etc...
#   Use payment_class_code (e.g., 'INV' vs. 'PMT') or is_payment_transaction to pick which to include.
# - Amounts where target_currency matches the value of parameter_target_currency are defined in this view.
# - If test data is used, references sales_payments_daily_agg_test_data_sdt instead of table sales_payments_daily_agg.
#   so that doubtful receivables can be re-calculated using the test data target end date. See sql_table_name property.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
#
#########################################################}

include: "/views/base/sales_payments_daily_agg.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_payments_common_amount_fields_ext.view"
include: "/views/core/sales_payments_daily_agg_test_data_sdt.view"


view: +sales_payments_daily_agg {
  extends: [otc_common_currency_fields_ext, sales_payments_common_amount_fields_ext]
  fields_hidden_by_default: yes

  sql_table_name: {%- assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase -%}{%- if test_data == 'YES' -%}${sales_payments_daily_agg_test_data_sdt.SQL_TABLE_NAME}{%- else -%}`@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg`{%- endif -%} ;;

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${transaction_raw},${bill_to_site_use_id},${business_unit_id},${payment_class_code}) ;;
  }

   dimension: payment_class_code {
    hidden: no
  }

  dimension: is_payment_transaction {
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

  dimension_group: transaction {
    hidden: no
  }

  dimension: transaction_month_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Month Number"
    description: "Transaction month as number 1 to 12"
  }

  dimension: transaction_quarter_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Quarter Number"
    description: "Transaction qarter as number 1 to 4"
  }

  dimension: transaction_year_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Year Number"
    description: "Transaction year as integer"
    value_format_name: id
  }

#} end date dimensions


#########################################################
# DIMENSIONS: Amounts
#{
# amounts hidden as measures are shown instead
# other field properties extended from sales_payments_common_amount_fields_ext

  dimension: amount_adjusted_target_currency {
    sql: (select SUM(TOTAL_ADJUSTED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: amount_applied_target_currency {
    sql: (select SUM(TOTAL_APPLIED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: amount_credited_target_currency {
    sql: (select SUM(TOTAL_CREDITED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: amount_discounted_target_currency {
    sql: (select SUM(TOTAL_DISCOUNTED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: amount_due_original_target_currency {
    sql: (select SUM(TOTAL_ORIGINAL) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: amount_due_remaining_target_currency {
    sql: (select SUM(TOTAL_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: tax_original_target_currency {
    sql: (select SUM(TOTAL_TAX_ORIGINAL) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: tax_remaining_target_currency {
    sql: (select SUM(TOTAL_TAX_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: overdue_receivables_target_currency {
    sql: (select SUM(TOTAL_OVERDUE_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

  dimension: doubtful_receivables_target_currency {
    sql: (select SUM(TOTAL_DOUBTFUL_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amounts
#{
  measure: transaction_count {
    hidden: no
    type: sum
    description: "Total number of payments"
    sql: ${num_payments} ;;
    value_format_name: decimal_0
  }

  measure: closed_transaction_count {
    hidden: no
    type: sum
    description: "Total number of closed transactions"
    sql: ${num_closed_payments} ;;
    value_format_name: decimal_0
  }

  measure: invoice_closed_transaction_count {
    hidden: no
    type: sum
    label: "Closed Invoice Payment Count"
    description: "For Invoice payment class code, the number of closed payments"
    sql: ${num_closed_payments} ;;
    filters: [payment_class_code: "INV"]
    value_format_name: decimal_0
  }

  measure: sum_days_to_payment {
    hidden: yes
    type: sum
    sql: ${total_days_to_payment} ;;
    value_format_name: decimal_0
  }

  measure: invoice_total_days_to_payment {
    hidden: yes
    type: sum
    sql: ${total_days_to_payment} ;;
    filters: [payment_class_code: "INV"]
    value_format_name: decimal_0
  }

  measure: average_days_to_payment {
    hidden: no
    type: number
    description: "For Invoice payment class code, the average number of days between payment close date and invoice date"
    sql: SAFE_DIVIDE(${invoice_total_days_to_payment},${invoice_closed_transaction_count}) ;;
    value_format_name: decimal_1
  }

#} end non-amount measures

}
