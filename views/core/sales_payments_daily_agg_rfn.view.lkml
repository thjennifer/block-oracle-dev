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
#   Extends view sales_payments_common_amount_measures_ext
#   References sales_payments_daily_agg_test_data_pdt if test data is used
#
# REFERENCED BY
#   Explore sales_payments_daily_agg
#
# EXTENDED FIELDS
#   total_amount_adjusted_target_currency, total_amount_applied_target_currency, etc...
#
# REPEATED STRUCTS
# Includes repeated structs AMOUNTS (defined in separate views for unnesting):
#     sales_payments_daily_agg__amounts - provides Total Amounts converted to Target Currencies
#
# CAVEATS
# - This view includes Payments related to Invoices, Cash Receipts, etc...
#   Use payment_class_code (e.g., 'INV' vs. 'PMT') or is_payment_transaction to pick which to include.
# - Amounts where target_currency matches value of parameter_target_currency are defined in this view.
# - If test data is used, references sales_payments_daily_agg_test_data_pdt instead of table sales_payments_daily_agg.
#   so that doubtful receivables can be re-calculated using the test data target end date. See sql_table_name property.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
#
#########################################################}

include: "/views/base/sales_payments_daily_agg.view"
include: "/views/core/sales_payments_common_amount_measures_ext.view"
include: "/views/core/sales_payments_daily_agg_test_data_pdt.view"



view: +sales_payments_daily_agg {
  extends: [sales_payments_common_amount_measures_ext]
  fields_hidden_by_default: yes

  sql_table_name: {%- assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase -%}{%- if test_data == 'YES' -%}${sales_payments_daily_agg_test_data_pdt.SQL_TABLE_NAME}{%- else -%}`@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg`{%- endif -%} ;;

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${transaction_raw},${bill_to_site_use_id},${business_unit_id},${payment_class_code}) ;;
  }

   dimension: payment_class_code {
    hidden: no
    description: "Class of payment including: INV - Invoice, CM - Credit Memo, DM - Debit Memo, DEP - Deposit, GUAR - Guarantee, BR - Bills Receivable, CB - Chargeback, PMT - cash receipts,"
  }

  dimension: is_payment_transaction {
    hidden: no
    description: "Yes if Payment Class Code = 'PMT' else No."
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
    description: "Transaction Month as Number 1 to 12"
  }

  dimension: transaction_quarter_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Quarter Number"
    description: "Transaction Quarter as Number 1 to 4"
  }

  dimension: transaction_year_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Year Number"
    description: "Transaction Year as Integer"
    value_format_name: id
  }

#} end date dimensions

#########################################################
# DIMENSIONS: Currency Conversion
#{
  dimension: target_currency_code {
    hidden: no
    type: string
    group_label: "Currency Conversion"
    label: "Currency (Target)"
    description:  "The target currency code represents the currency into which the order's source currency is converted."
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Currency Conversion"
    description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
    sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
  }

#} end currency conversion dimensions

#########################################################
# DIMENSIONS: Amounts
#{
# amounts hidden as measures are shown instead

  dimension: amount_adjusted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_ADJUSTED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_APPLIED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_CREDITED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_DISCOUNTED) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_ORIGINAL) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Original (@{label_get_target_currency}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_TAX_ORIGINAL) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Remaining (@{label_get_target_currency}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_TAX_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Past Due Receivables (@{label_get_target_currency}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_OVERDUE_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: (select SUM(TOTAL_DOUBTFUL_REMAINING) FROM ${TABLE}.AMOUNTS WHERE TARGET_CURRENCY_CODE = ${target_currency_code}) ;;
    value_format_name: decimal_2
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amounts
#{
  measure: transaction_count {
    hidden: no
    type: sum
    sql: ${num_payments} ;;
    value_format_name: decimal_0
  }

  measure: closed_transaction_count {
    hidden: no
    type: sum
    sql: ${num_closed_payments} ;;
    value_format_name: decimal_0
  }

  measure: invoice_closed_transaction_count {
    hidden: no
    type: sum
    description: "For Invoice payment class code, the number of closed payments."
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
    description: "For Invoice payment class code, the average umber of days between payment close date and invoice date."
    sql: SAFE_DIVIDE(${invoice_total_days_to_payment},${invoice_closed_transaction_count}) ;;
    value_format_name: decimal_1
  }

#} end non-amount measures

}
