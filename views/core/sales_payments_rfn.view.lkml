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
#   otc_common_currency_fields_ext
#   sales_payments_common_amount_measures_ext
#
# REFERENCED BY
#   Explore sales_payments
#
# EXTENDED FIELDS
#   target_currency_code, is_incomplete_conversion, alert_note_for_incomplete_currency_conversion,
#   total_amount_adjusted_target_currency, total_amount_applied_target_currency, etc...
#
# NOTES
# - This view includes Payments related to Cash Receipts and Invoices.
#   Use payment_class_code or is_payment_transaction to pick which to include.
# - Cash Receipt ID will be populated when payment_class_code = PMT.
#   Invoice ID will be populated when payment_class_code <> 'PMT'.
# - Fields hidden by default. Update field's 'hidden' property to show/hide.
# - Includes fields which reference CURRENCY_CONVERSION_SDT so this view must be included in the
#   Sales Orders Explore.
#########################################################}

include: "/views/base/sales_payments.view"
include: "/views/core/otc_common_fiscal_gl_dates_ext.view"
include: "/views/core/otc_common_currency_fields_ext.view"
include: "/views/core/sales_payments_common_amount_measures_ext.view"


view: +sales_payments {
  extends: [otc_common_fiscal_gl_dates_ext,otc_common_currency_fields_ext,sales_payments_common_amount_measures_ext]
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
    description: "Invoice number associated with transaction"
  }

  dimension: ledger_id {
    hidden: no
    description: "ID of ledger or set of books"
    value_format_name: id
  }

  dimension: ledger_name {
    hidden: no
    description: "Name of ledger or set of books"
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

  dimension_group: ledger {
    hidden: no
  }

  dimension_group: due {
    hidden: no
  }

  dimension_group: exchange {
    hidden: no
    description: "Date to use for exchange rate calculation. If the exchange date is not populated, the transaction date is used."
  }

  dimension_group: payment_close {
    hidden: no
  }

  dimension_group: creation_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Creation"
    description: "Creation timestamp of record in Oracle source table"
  }

  dimension_group: last_update_ts {
    hidden: no
    timeframes: [raw, date, time]
    label: "Last Update"
    description: "Last update timestamp of record in Oracle source table"
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

  dimension: is_closed {
    hidden: no
    group_label: "Payment Status"
    type: yesno
    sql: ${payment_close_date} IS NOT NULL ;;
  }

#--> if test data is used, re-compute using the target end date of the test dataset.
  dimension: is_open_and_overdue {
    hidden: no
    group_label: "Payment Status"
    description: "Yes if due date < current date and amount due remaining > 0 else No"
    sql:  {%- assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase -%}
          {%- if test_data == 'YES' -%}
             ${due_raw} < DATE(@{default_target_date}) AND ${is_open}
          {%- else -%}${TABLE}.IS_OPEN_AND_OVERDUE
          {%- endif -%};;
  }

#--> if test data is used, re-compute days overdue using the target end date of the test dataset.
  dimension: is_doubtful {
    hidden: no
    group_label: "Payment Status"
    description: "Yes if 'Is Open and Overdue' = Yes and 'Days Overdue' > 90 else No"
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
            ${days_overdue} > 90 AND ${is_open}
         {% else %}${TABLE}.IS_DOUBTFUL
         {% endif%};;
  }

  dimension: was_closed_late {
    hidden: no
    group_label: "Payment Status"
    description: "Yes if payment is closed (amount due remaining = 0) and Due < Payment Close Date else No"
  }

#} end status dimensions

#########################################################
# DIMENSIONS: Days
#{
# Hidden from explore because measures for each are defined.

#--> if test data is used, re-compute using the target end date of the test dataset.
  dimension: days_overdue {
    hidden: yes
    description: "If open and overdue, number of days past due date"
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
             IF(${is_open_and_overdue},DATE_DIFF(DATE(@{default_target_date}), ${due_raw}, DAY),NULL)
         {% else %}${TABLE}.DAYS_OVERDUE
         {% endif%} ;;
  }

  dimension: days_late {
    hidden: yes
    description: "If payment was closed late, number of days after the due date the payment closed"
  }

  dimension: days_to_payment {
    hidden: yes
    description: "For payment class code = INV, the number of days between payment close date and invoice date"
  }


#} end days dimensions

#########################################################
# DIMENSIONS: Currency Conversion
#{
# target_currency_code and is_incomplete_conversion extended from
# otc_common_currency_fields_ext

  dimension: currency_code {
    hidden: no
    group_label: "Currency Conversion"
    label: "Currency (Source)"
    description: "{%- assign v = _view._name | split: '_' -%}Currency of the {{v[1] | remove: 's' | append: '.'}}"
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Currency Conversion"
    description: "Exchange rate between source and target currency for a specific date"
    sql: IF(${currency_code} = ${target_currency_code}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    # label, group_label, description defined in otc_common_currency_fields_ext
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
    description: "Amount adjusted"
    value_format_name: decimal_2
  }

  dimension: amount_applied {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Applied (Source Currency)"
    description: "Amount applied"
    value_format_name: decimal_2
  }

  dimension: amount_credited {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Credited (Source Currency)"
    description: "Amount credited"
    value_format_name: decimal_2
  }

  dimension: amount_discounted {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Discounted (Source Currency)"
    description: "Amount discounted"
    value_format_name: decimal_2
  }

  dimension: amount_due_original {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Due Original (Source Currency)"
    description: "Amount due originally"
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining {
    hidden: yes
    group_label: "Amounts"
    label: "Amount Due Remaining (Source Currency)"
    description: "Amount due remaining"
    value_format_name: decimal_2
  }

  dimension: tax_original {
    hidden: yes
    group_label: "Amounts"
    label: "Tax Amount Original (Source Currency)"
    description: "Original tax amount charged on the transaction"
    value_format_name: decimal_2
  }

  dimension: tax_remaining {
    hidden: yes
    group_label: "Amounts"
    label: "Tax Amount Remaining (Source Currency)"
    description: "Remaining tax amount charged on the transaction"
    value_format_name: decimal_2
  }

  dimension: amount_adjusted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Amount adjusted in target currency"
    sql: ${amount_adjusted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Amount applied in target currency"
    sql: ${amount_applied} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Amount credited in target currency"
    sql: ${amount_credited} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Amount discounted in target currency"
    sql: ${amount_discounted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    sql: ${amount_due_original} * ${currency_conversion_rate}  ;;
    description: "Amount due originally in target currency"
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Amount due remaining in target currency"
    sql: ${amount_due_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Original' -%}@{label_currency_if_selected}"
    description: "Original tax amount charged on the transaction in target currency"
    sql: ${tax_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Tax Amount Remaining' -%}@{label_currency_if_selected}"
    description: "Remaining tax amount charged on the transaction in target currency"
    sql: ${tax_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}{%- assign field_name = 'Past Due Receivables' -%}@{label_currency_if_selected}"
    description: "Amount in target currency still remaining for open and overdue invoice"
    sql: IF(${is_payment_transaction}=FALSE AND ${is_open_and_overdue},${amount_due_remaining_target_currency},0)   ;;
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: yes
    type: number
    group_label: "Amounts"
    label: "@{label_currency_defaults}@{label_currency_field_name}@{label_currency_if_selected}"
    description: "Amount in target currency still remaining for invoice more than 90 days overdue"
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

  measure: closed_transaction_count {
    hidden: no
    type: count
    filters: [is_closed: "Yes"]
    drill_fields: [payment_details*]
  }

  measure: invoice_closed_transaction_count {
    hidden: no
    type: count
    description: "For Invoice payment class code, the number of closed payments"
    filters: [is_closed: "Yes",payment_class_code: "INV"]
    drill_fields: [payment_details*]
  }

  measure: average_days_overdue {
    hidden: no
    type: average
    description: "If open and overdue, average number of days past due date"
    sql: ${days_overdue} ;;
    value_format_name: decimal_1
  }

  measure: average_days_late {
    hidden: no
    type: average
    description: "If payment was closed late, average number of days after the due date the payment closed"
    sql: ${days_late} ;;
    value_format_name: decimal_1
  }

  measure: average_days_to_payment {
    hidden: no
    type: average
    description: "Average number of days between payment close date and invoice date"
    sql: ${days_to_payment} ;;
    filters: [payment_class_code: "INV"]
    value_format_name: decimal_1
  }

#} end non-amount measures

#########################################################
# MEASURES: Amounts in Source Currency
#{

  measure: total_amount_adjusted_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Amount Adjusted in Source Currency"
    description: "Sum of amount adjusted in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_adjusted}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_applied_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Amount Applied in Source Currency"
    description: "Sum of amount applied in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_applied}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_credited_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Amount Credited in Source Currency"
    description: "Sum of amount credited in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_credited}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_discounted_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Amount Discounted in Source Currency"
    description: "Sum of amount discounted in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_discounted}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_due_original_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Amount Due Original in Source Currency"
    description: "Sum of amount due original in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_due_original}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_amount_due_remaining_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Amount Due Remaining in Source Currency"
    description: "Sum of amount due remaining in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${amount_due_remaining}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_tax_original_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Tax Original in Source Currency"
    description: "Sum of tax original in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
    sql: {%- if currency_code._is_selected -%}${tax_original}{%- else -%}NULL{%- endif -%} ;;
    value_format_name: decimal_2
    html: @{html_message_source_currency} ;;
  }

  measure: total_tax_remaining_in_source_currency {
    hidden: no
    type: sum
    group_label: "Amounts in Source Currency"
    label: "Tax Remaining in Source Currency"
    description: "Sum of tax remaining in source currency. Currency (Source) is a required field to avoid summing across multiple currencies. If currency is not included, a warning message is returned."
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
