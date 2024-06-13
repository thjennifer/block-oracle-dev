include: "/views/base/sales_payments.view"

view: +sales_payments {

  # sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
  # {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  # {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesPayments` ;;




  dimension: payment_schedule_id {
    primary_key: yes
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
    # sql:  REGEXP_EXTRACT(${TABLE}.INVOICE_NUMBER,"([0-9]+)" );;
    }

  dimension: is_payment_transaction {
    description: "Yes if Payment Class Code = 'PMT' else No."
  }

   dimension: is_overdue {
    sql:  {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
             @{default_target_date}
             ( ${due_raw} < DATE('{{td}}') AND ${is_open} )
             OR ${due_raw} < ${payment_raw}
          {% else %}${TABLE}.IS_OVERDUE
          {% endif%};;
  }

  dimension: days_overdue {
    sql: {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
             @{default_target_date}
              DATE_DIFF( DATE('{{td}}'), ${due_raw}, DAY)
          {% else %}${TABLE}.DAYS_OVERDUE
          {% endif%} ;;
  }

  dimension: is_doubtful {
    sql: {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
         ${days_overdue} > 90 AND ${is_open}
         {% else %}${TABLE}.IS_DOUBTFUL
         {% endif%};;
  }

  dimension: is_open {
    type: yesno
    sql: ${amount_due_remaining} > 0 ;;
  }

  dimension: aging_bucket {
    type: string
    sql: CASE WHEN ${days_overdue} <= 0 THEN "CURRENT"
              WHEN ${days_overdue} <= 30 THEN "30 Past Due"
              WHEN ${days_overdue} <= 60 THEN "60 Past Due"
              WHEN ${days_overdue} <= 90 THEN "90 Past Due"
              WHEN ${days_overdue} <= 120 THEN "120 Past Due"
          ELSE "121+ Past Due"
          END;;
    order_by_field: aging_bucket_number
  }

  dimension: aging_bucket_number {
    hidden:yes
    type: number
    sql: CASE WHEN ${days_overdue} <= 0 THEN 1
              WHEN ${days_overdue} <= 30 THEN 2
              WHEN ${days_overdue} <= 60 THEN 3
              WHEN ${days_overdue} <= 90 THEN 4
              WHEN ${days_overdue} <= 120 THEN 5
          ELSE 6
          END;;
  }

  # -- TODO: fix this logic to account for payments that were made.
  # DATE_DIFF(CURRENT_DATE, Payments.DUE_DATE, DAY) AS DAYS_OVERDUE,
  # DATE_DIFF(Payments.PAYMENT_DATE, Invoices.INVOICE_DATE, DAY) AS DAYS_TO_PAYMENT,
  # (
  #   (Payments.DUE_DATE < CURRENT_DATE AND Payments.AMOUNT_DUE_REMAINING > 0)
  #   OR Payments.DUE_DATE < Payments.PAYMENT_DATE) AS IS_OVERDUE, -- noqa: LT02
  # (
  #   (DATE_DIFF(CURRENT_DATE, Payments.DUE_DATE, DAY) > 90)
  #   AND Payments.AMOUNT_DUE_REMAINING > 0) AS IS_DOUBTFUL


#########################################################
# Business Unit / Order Source / Customer Dimensions
#{

  dimension: business_unit_id {hidden: no}

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: bill_to_site_use_id {
    group_label: "Bill to Customer"
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    # sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,CONCAT("Bill to Customer Number: ",CAST(${bill_to_customer_number} AS STRING))) ;;
  }

  dimension: bill_to_customer_number {
    group_label: "Bill to Customer"
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end business unit / order source / customer dimensions




#########################################################
# Dates
#{
  dimension_group: payment {}

  dimension_group: ledger {}

  dimension: fiscal_gl_month {
    group_label: "Ledger Date"
    label: "Fiscal GL Month Number"
    description: "Fiscal GL month of the ledger date as an integer."
  }

  dimension: fiscal_gl_quarter {
    group_label: "Ledger Date"
    label: "Fiscal GL Quarter Number"
    description: "Fiscal GL Quarter of the ledger date as an integer."
  }

  dimension: fiscal_gl_quarter {
    group_label: "Ledger Date"
    label: "Fiscal GL Quarter Number"
    description: "Fiscal GL Quarter of the ledger date as an integer."
  }

  dimension: fiscal_gl_year {
    group_label: "Ledger Date"
    label: "Fiscal GL Year Number"
    description: "Fiscal GL Year of ledger date as an integer."
  }

  dimension: fiscal_gl_year_month {
    group_label: "Ledger Date"
    label: "Fiscal GL YYYY-MM"
    description: "Fiscal GL Year-Month formatted as YYYY-MM string."
    sql: CONCAT(CAST(${fiscal_gl_year} AS STRING),"-",LPAD(CAST(${fiscal_gl_month} AS STRING),2,'0'));;
  }

  dimension: fiscal_period_name {
    group_label: "Ledger Date"
    description: "Name of fiscal period. For example 'Jan-2024'."
  }

  dimension: fiscal_period_set_name {
    group_label: "Ledger Date"
  }

  dimension: fiscal_period_type {
    group_label: "Ledger Date"
  }

  dimension_group: discount {}

  dimension_group: due {}

  dimension_group: creation {
    hidden: no
    timeframes: [raw, date, time]
    description: "Creation date of record in Oracle source table."
  }

  dimension_group: last_update {
    hidden: no
    timeframes: [raw, date, time]
    description: "Last update date of record in Oracle source table."
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
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
    sql: ${amount_adjusted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: ${amount_applied} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Credited ({{currency}}){%else%}Amount Credited (Target Currency){%endif%}"
    sql: ${amount_credited} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Discounted ({{currency}}){%else%}Amount Discounted (Target Currency){%endif%}"
    sql: ${amount_discounted} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Original ({{currency}}){%else%}Amount Due Original (Target Currency){%endif%}"
    sql: ${amount_due_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Remaining ({{currency}}){%else%}Amount Due Remaining (Target Currency){%endif%}"
    sql: ${amount_due_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Original ({{currency}}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Remaining ({{currency}}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining} * ${currency_conversion_rate}  ;;
    value_format_name: decimal_2
  }

#} end amount dimensions


  measure: count {hidden:yes}

  measure: payment_count {
    hidden: no
    type: count
    drill_fields: [payments_details*]
  }


  measure: total_amount_adjusted_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
    sql: ${amount_adjusted_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

#####REVIEW need to confirm the payment_class_code filters needed if any
  measure: total_amount_applied_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: ${amount_applied_target_currency}  ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

  measure: total_amount_credited_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Credited ({{currency}}){%else%}Amount Credited (Target Currency){%endif%}"
    sql: ${amount_credited_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

#####REVIEW need to confirm the payment_class_code filters needed if any
  measure: total_amount_discounted_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Discounted ({{currency}}){%else%}Amount Discounted (Target Currency){%endif%}"
    sql: ${amount_discounted_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

  measure: total_amount_due_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Original ({{currency}}){%else%}Amount Due Original (Target Currency){%endif%}"
    sql: ${amount_due_original_target_currency} ;;
    # filters: [payment_class_code: "INV,CM"]
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Receivables ({{currency}}){%else%}Total Receivables (Target Currency){%endif%}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

  measure: total_tax_original_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Original ({{currency}}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${tax_original_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

  measure: total_tax_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Remaining ({{currency}}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${tax_remaining_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No"]
  }

  measure: total_overdue_receivables_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Past Due Receivables ({{currency}}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No" , is_overdue: "Yes"]
  }

  measure: total_doubtful_receivables_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Doubtful Receivables ({{currency}}){%else%}Doubtful Receivables (Target Currency){%endif%}"
    sql: ${amount_due_remaining_target_currency} ;;
    value_format_name: decimal_2
    filters: [is_payment_transaction: "No" , is_doubtful: "Yes"]
  }

  measure: percent_of_total_receivables {
    type: percent_of_total
    sql: ${total_amount_due_remaining_target_currency} ;;
  }


set: payments_details {
  fields: [payment_schedule_id,invoice_number,bill_to_customer_name,payment_date,due_date,total_amount_due_original_target_currency,total_amount_due_remaining_target_currency]
}





   }
