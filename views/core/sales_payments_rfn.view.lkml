#########################################################{
# PURPOSE
# The SalesPayments table and its corresponding View sales_payments
# captures information about payment transactions including applicable
# invoice.
#
# SOURCES
# Refines View sales_payments
# Extends Views:
#   otc_common_fiscal_gl_dates_ext
#   sales_payments_common_amounts_measures_ext
#
# REFERENCED BY
# Explore sales_payments
#
# EXTENDED FIELDS
# Extends common dimensions:
#
# REPEATED STRUCTS
# - Also includes Repeated Struct for AMOUNTS. See view sales_invoices__amounts for
#   dimensions and measures.
#
# NOTES
# - This view includes Payments related to Cash Receipts and Invoices.
#   Use payment_class_code to pick which to include. Cash Receipt ID will be populated
#   when payment_class_code = PMT. Invoice ID will be populated when payment_class_code <> 'PMT'.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Includes fields which reference CURRENCY_CONVERSION_SDT so this view must be included in the
#   Sales Orders Explore.
#########################################################}

include: "/views/base/sales_payments.view"
include: "/views/core/otc_common_fiscal_gl_dates_ext.view"
include: "/views/core/sales_payments_common_amount_measures_ext.view"

view: +sales_payments {
  extends: [otc_common_fiscal_gl_dates_ext,sales_payments_common_amount_measures_ext]
  fields_hidden_by_default: yes

  dimension: payment_schedule_id {
    primary_key: yes
    value_format_name: id
  }

  dimension: business_unit_id {
    hidden: no
    value_format_name: id
  }

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: payment_class_code {
    hidden: no
    description: "Class of payment including: INV - Invoice, CM - Credit Memo, DM - Debit Memo, DEP - Deposit, GUAR - Guarantee, BR - Bills Receivable, CB - Chargeback, PMT - cash receipts,"
  }

  dimension: is_payment_transaction {
    hidden: no
    description: "Yes if Payment Class Code = 'PMT' else No."
  }

  dimension: cash_receipt_id {
    hidden: no
    label: "Receipt ID"
    description: "Cash Receipt ID associated with transaction. Note, value will only be populated when payment class code = 'PMT'."
    value_format_name: id
  }

  dimension: invoice_id {
    hidden: no
    description: "Invoice ID associated with transaction. Note, value will be null when payment class code = 'PMT'."
    value_format_name: id
  }

  dimension: invoice_number {
    hidden: no
    description: "Invoice number associated with transaction."
  }

  dimension: ledger_id {
    hidden: no
    description: "ID of ledger or set of books."
    value_format_name: id
  }

  dimension: ledger_name {
    hidden: no
    description: "Name of ledger or set of books."
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
    group_item_label: "Month Num"
    description: "Transaction Month as Number 1 to 12"
  }

  dimension: transaction_quarter_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Quarter Num"
    description: "Transaction Quarter as Number 1 to 4"
  }

  dimension: transaction_year_num {
    hidden: no
    group_label: "Transaction Date"
    group_item_label: "Year Num"
    description: "Transaction Year as Integer"
    value_format_name: id
  }

  dimension_group: ledger {
    hidden: no
  }

  dimension_group: due {
    hidden: no
  }

  dimension_group: exchange {
    hidden: no
    description: "Date to use for exchange rate calculation. If exchange date is not populated, transaction date is used."
  }

  dimension_group: payment_close {
    hidden: no
  }

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    description: "Creation timestamp of record in Oracle source table."
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    description: "Last update timestamp of record in Oracle source table."
  }

#} end dates

#########################################################
# DIMENSIONS: Status
#{

  dimension: is_open {
    hidden: yes
    type: yesno
    sql: ${amount_due_remaining} > 0 ;;
  }

#--> if test data is used, re-compute using the target end date of the test dataset.
  dimension: is_open_and_overdue {
    hidden: no
    description: "Yes if due date < current date and amount due remaining > 0 else No."
    sql:  {%- assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase -%}
          {%- if test_data == 'YES' -%}
             ${due_raw} < DATE(@{default_target_date}) AND ${is_open}
          {%- else -%}${TABLE}.IS_OPEN_AND_OVERDUE
          {%- endif -%};;
  }

#--> if test data is used, re-compute days overdue using the target end date of the test dataset.
  dimension: is_doubtful {
    hidden: no
    description: "Yes if 'Is Open and Overdue' = Yes and 'Days Overdue' > 90 else No."
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
            ${days_overdue} > 90 AND ${is_open}
         {% else %}${TABLE}.IS_DOUBTFUL
         {% endif%};;
  }

  dimension: was_closed_late {
    hidden: no
    description: "Yes if payment is closed (amount due remaining = 0) and Due < Payment Close Date else No."
  }

#} end status dimensions


#########################################################
# DIMENSIONS: Days
#{

#--> if test data is used, re-compute using the target end date of the test dataset.
  dimension: days_overdue {
    hidden: no
    description: "If open and overdue, number of days past due date."
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
             DATE_DIFF(DATE(@{default_target_date}), ${due_raw}, DAY)
         {% else %}${TABLE}.DAYS_OVERDUE
         {% endif%} ;;
  }

  dimension: days_late {
    hidden: no
    description: "If payment was closed late, number of days after the due date the payment closed."
  }

  dimension: days_to_payment {
    hidden: no
    description: "Number of days between payment close date and invoice date."
  }


#} end days dimensions


#########################################################
# DIMENSIONS: Currency Conversion
#{

  dimension: currency_code {
    hidden: no
    type: string
    group_label: "Currency Conversion"
    label: "Currency (Source)"
    description: "Currency of the payment transaction."
  }

  dimension: target_currency_code {
    hidden: no
    type: string
    group_label: "Currency Conversion"
    label: "Currency (Target)"
    description: "The currency into which the order's source currency is converted."
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Currency Conversion"
    description: "Exchange rate between source and target currency for a specific date."
    sql: IF(${currency_code} = ${target_currency_code}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Currency Conversion"
    description: "Yes, if any source currencies could not be converted into target currency for a given date. If yes, should confirm CurrencyRateMD table is complete and not missing any dates or currencies."
    sql: ${currency_code} <> ${target_currency_code} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

#} end currency conversion dimensions


#########################################################
# DIMENSIONS: Amounts
#{
# hidden from explore because measures for each are defined.

  dimension: amount_adjusted {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Adjusted (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_applied {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Applied (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_credited {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Credited (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_discounted {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Discounted (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_due_original {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Due Original (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Due Remaining (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: tax_original {
    hidden: yes
    group_label: "Amounts"
    label: "Tax Amount Original (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: tax_remaining {
    hidden: yes
    group_label: "Amounts"
    label: "Tax Amount Remaining (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_adjusted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_adjusted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_applied} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_credited} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_discounted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_due_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_due_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Original (@{label_get_target_currency}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Remaining (@{label_get_target_currency}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Past Due Receivables (@{label_get_target_currency}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: IF(${is_payment_transaction}=FALSE AND ${is_open_and_overdue},${amount_due_remaining_target_currency},0)   ;;
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: IF(${is_payment_transaction}=FALSE AND ${is_doubtful},${amount_due_remaining_target_currency},0)   ;;
    value_format_name: decimal_2
  }

#} end amount dimensions

#########################################################
# MEASURES: Non-Amounts
#{

  measure: transaction_count {
    hidden: no
    type: count
    drill_fields: [payment_details*]
  }

#} end non-amount measures

#########################################################
# MEASURES: Amounts in Source Currency
#{

  measure: total_amount_adjusted_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Amount Adjusted in Source Currency"
    description: "Sum of amount adjusted in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_adjusted}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_applied_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Amount Applied in Source Currency"
    description: "Sum of amount applied in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_applied}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_credited_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Amount Credited in Source Currency"
    description: "Sum of amount credited in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_credited}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_discounted_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Amount Discounted in Source Currency"
    description: "Sum of amount discounted in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_discounted}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_due_original_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Amount Due Original in Source Currency"
    description: "Sum of amount due original in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_due_original}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_due_remaining_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Amount Due Remaining in Source Currency"
    description: "Sum of amount due remaining in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_due_remaining}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_tax_original_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Tax Original in Source Currency"
    description: "Sum of tax original in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${tax_original}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_tax_remaining_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Total Tax Remaining in Source Currency"
    description: "Sum of tax remaining in source currency. Currency (Source) is required field to avoid summing across multiple currencies. If currency not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${tax_remaining}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

#} end amounts in source currency

#########################################################
# MEASURES: Amounts in Target Currency
#{
# updates to measures extended from sales_payments_common_amount_measures_ext
# and/or new measures


  measure: total_receivables_target_currency {
    drill_fields: [invoice_payment_details*]
  }

  measure: total_overdue_receivables_target_currency {
    drill_fields: [overdue_details*]
  }

  measure: total_doubtful_receivables_target_currency {
    drill_fields: [overdue_details*]
  }

#} end amounts in target currency


#########################################################
# SETS
#{

set: payment_details {
    fields:   [
      bill_to_customer_name,
      invoice_number,
      sales_invoices.invoice_date,
      payment_schedule_id,
      payment_class_code,
      transaction_date,
      due_date,
      payment_close_date,
      is_open_and_overdue,
      days_overdue,
      total_amount_due_original_target_currency,
      total_amount_due_remaining_target_currency,
      total_amount_applied_target_currency
    ]
  }

set: invoice_payment_details {
  fields:   [
            bill_to_customer_name,
            invoice_number,
            sales_invoices.invoice_date,
            payment_schedule_id,
            payment_class_code,
            due_date,
            payment_close_date,
            is_open_and_overdue,
            days_overdue,
            total_amount_due_original_target_currency,
            total_amount_due_remaining_target_currency,
            total_amount_applied_target_currency
            ]
}

set: overdue_details {
    fields:   [
      bill_to_customer_name,
      invoice_number,
      sales_invoices.invoice_date,
      payment_schedule_id,
      payment_class_code,
      due_date,
      is_open_and_overdue,
      days_overdue,
      total_amount_due_original_target_currency,
      total_receivables_target_currency,
      total_amount_applied_target_currency,
      ]
  }

#} end sets



   }
