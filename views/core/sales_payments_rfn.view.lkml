include: "/views/base/sales_payments.view"
include: "/views/core/otc_common_fiscal_gl_dates_ext.view"
include: "/views/core/sales_payments_common_fields_ext.view"

view: +sales_payments {

  extends: [otc_common_fiscal_gl_dates_ext,sales_payments_common_fields_ext]


  dimension: payment_schedule_id {
    primary_key: yes
    value_format_name: id
  }

  dimension: cash_receipt_id {
    hidden: no
    label: "Receipt ID"
    description: "Cash Receipt ID associated with transaction. Note, value will only be populated when payment class code = 'PMT'."
    value_format_name: id
  }

  dimension: invoice_id {
    hidden: no
    value_format_name: id
    description: "Invoice ID associated with transaction. Note, value will be null when payment class code = 'PMT'."
  }

  dimension: invoice_number {
    hidden: no
    description: "Invoice number associated with transaction."
  }

  dimension: is_payment_transaction {
    description: "Yes if Payment Class Code = 'PMT' else No."
  }

  dimension: is_open_and_overdue {
     sql:  {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
           {% if test_data == 'YES' %}
               ${due_raw} < DATE(@{default_target_date}) AND ${is_open}
           {% else %}${TABLE}.IS_OPEN_AND_OVERDUE
           {% endif%};;
  }

  dimension: was_closed_late {
  }

  dimension: is_doubtful {
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
            ${days_overdue} > 90 AND ${is_open}
         {% else %}${TABLE}.IS_DOUBTFUL
         {% endif%};;
  }

  dimension: is_open {
    hidden: yes
    type: yesno
    sql: ${amount_due_remaining} > 0 ;;
  }

  dimension: days_overdue {
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
             DATE_DIFF(DATE(@{default_target_date}), ${due_raw}, DAY)
         {% else %}${TABLE}.DAYS_OVERDUE
         {% endif%} ;;
  }

  dimension: days_late {}

  dimension: days_to_payment {}


#########################################################
# Payment Class / Business Unit / Customer Dimensions
#{
  dimension: payment_class_code {hidden: no}
  dimension: business_unit_id {hidden: no}

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: bill_to_site_use_id {
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_SITE_USE_ID,-1) ;;
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_number {
    group_label: "Bill to Customer"
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end payment class / business unit / customer dimensions




#########################################################
# Dates
# Fiscal Dates extended from otc_common_fiscal_gl_dates_ext and grouped under Ledger Date
#{
  dimension_group: transaction {}

  dimension_group: invoice {
    hidden: yes
    type: time
    timeframes: [raw,date]
    sql: IF(${payment_class_code}<>'PMT',${TABLE}.TRANSACTION_DATE,NULL);;
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

  dimension_group: ledger {}

  dimension_group: due {}

  dimension_group: exchange {
    description: "Date to use for exchange rate calculation."
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
# Amounts as dimensions including Currency Conversions
#{

  dimension: amount_adjusted {
    hidden: no
    group_label: "Amounts"
    label: "Amount Adjusted (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_applied {
    hidden: no
    group_label: "Amounts"
    label: "Amount Applied (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_credited {
    hidden: no
    group_label: "Amounts"
    label: "Amount Credited (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_discounted {
    hidden: no
    group_label: "Amounts"
    label: "Amount Discounted (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_due_original {
    hidden: no
    group_label: "Amounts"
    label: "Amount Due Original (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining {
    hidden: no
    group_label: "Amounts"
    label: "Amount Due Remaining (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: tax_original {
    hidden: no
    group_label: "Amounts"
    label: "Tax Amount Original (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: tax_remaining {
    hidden: no
    group_label: "Amounts"
    label: "Tax Amount Remaining (Source Currency)"
    value_format_name: decimal_2
  }

  dimension: currency_code {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Source)"
    description: "Currency of the payment transaction."
  }

  dimension: currency_target {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: currency_conversion_rate {
    hidden: no
    group_label: "Amounts"
    sql: IF(${currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate}) ;;
    value_format_name: decimal_4
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Amounts"
    sql: ${currency_code} <> {% parameter otc_common_parameters_xvw.parameter_target_currency %} AND ${currency_conversion_sdt.from_currency} is NULL ;;
  }

  dimension: amount_adjusted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_adjusted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_applied} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_credited} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_discounted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_due_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${amount_due_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Original (@{label_get_target_currency}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Remaining (@{label_get_target_currency}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: no
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


  measure: count {hidden:yes}

  measure: transaction_count {
    hidden: no
    type: count
    drill_fields: [payment_details*]
  }

  measure: total_receivables_target_currency {
    # fully defined in sales_payments_common_fields
    drill_fields: [invoice_payment_details*]
  }

  measure: total_overdue_receivables_target_currency {
    # fully defined in sales_payments_common_fields
    drill_fields: [overdue_details*]
  }

  measure: total_doubtful_receivables_target_currency {
    # fully defined in sales_payments_common_fields
    drill_fields: [overdue_details*]
  }



set: payment_details {
    fields:   [
      bill_to_customer_name,
      invoice_number,
      invoice_date,
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
            invoice_date,
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
      invoice_date,
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





   }