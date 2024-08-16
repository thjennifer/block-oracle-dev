include: "/views/core/sales_payments_rfn.view"

view: +sales_payments {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesPayments` ;;

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesPayments` ;;

  dimension: is_open_and_overdue {
    sql:  {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
          {% if test_data == 'YES' %}
             ${due_raw} < DATE(@{default_target_date_test}) AND ${is_open}
          {% else %}${TABLE}.IS_OPEN_AND_OVERDUE
          {% endif%};;
  }

  dimension: days_overdue {
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
          {% if test_data == 'YES' %}
              DATE_DIFF(DATE(@{default_target_date_test}), ${due_raw}, DAY)
          {% else %}${TABLE}.DAYS_OVERDUE
          {% endif%} ;;
  }

  dimension: is_doubtful {
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
         ${days_overdue} > 90 AND ${is_open_and_overdue}
         {% else %}${TABLE}.IS_DOUBTFUL
         {% endif%};;
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
# TEST STUFF
#{

  dimension_group: payment_close_with_null {
    view_label: "TEST STUFF"
    type: time
    timeframes: [raw,date, month, week, quarter, year, yesno]
    sql: NULLIF(${TABLE}.PAYMENT_CLOSE_DATE,PARSE_DATE('%F','4712-12-31'));;
  }

  dimension: days_late_using_null_payment_close {
    view_label: "TEST STUFF"
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
         {% if test_data == 'YES' %}
              DATE_DIFF( ${payment_close_with_null_raw}, ${due_raw}, DAY)
          {% else %}${TABLE}.DAYS_LATE
          {% endif%} ;;
  }

  dimension: days_to_payment_using_null_payment_close {
    view_label: "TEST STUFF"
    sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
          {% if test_data == 'YES' %}
              DATE_DIFF( ${payment_close_with_null_raw}, ${transaction_raw}, DAY)
          {% else %}${TABLE}.DAYS_LATE
          {% endif%} ;;
  }


dimension: is_null_business_unit_name {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.BUSINESS_UNIT_NAME IS NULL;;
}

dimension: is_null_bill_to_site_id {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.BILL_TO_SITE_USE_ID IS NULL;;
}

dimension: is_null_bill_to_customer_number {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER IS NULL;;
}

dimension: is_null_bill_to_customer_name {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.BILL_TO_CUSTOMER_NAME IS NULL ;;
}

dimension: is_null_bill_to_customer_country {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY IS NULL;;
}

dimension: is_null_cash_receipt_id {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.CASH_RECEIPT_ID IS NULL;;
}


dimension: is_null_invoice_id {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.INVOICE_ID IS NULL;;
}

dimension: is_null_invoice_number {
  hidden: no
  view_label: "TEST STUFF"
  type: yesno
  sql: ${TABLE}.INVOICE_NUMBER IS NULL;;
}

dimension: invoice_number_2 {
  hidden: no
  view_label: "TEST STUFF"
  type: string
  sql: REGEXP_REPLACE(${TABLE}.INVOICE_NUMBER,'[^0-9]', '');;

}

dimension: invoice_number_length {
  hidden: no
  view_label: "TEST STUFF"
  type: number
  sql: LENGTH(${invoice_number}) ;;
}

dimension: is_late_payment {
  hidden: no
  type: yesno
  view_label: "TEST STUFF"
  sql: ${due_raw} < ${TABLE}.PAYMENT_CLOSE_DATE ;;
}

# dimension: is_transaction_date_same_as_invoice_date {
#   hidden: no
#   type: yesno
#   view_label: "TEST STUFF"
#   sql: ${transaction_raw} = ${sales_invoices.invoice_raw} ;;
# }

  dimension: is_negative_amount_due_remaining {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${amount_due_remaining} < 0 ;;
  }

dimension: test_target_date  {
  type: string
  hidden: no
  view_label: "TEST STUFF"
  sql: {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
           '{{test_data}}';;
  # sql: @{default_target_date_test}'{{td}}' ;;
}

  measure: days_sales_outstanding {
    hidden: no
    type: string
    view_label: "TEST STUFF"
    sql: MAX('COMING SOON') ;;
    html: 🚧 ;;
  }


  measure: dso_vision_365_payments {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2009-10-11') and DATE('2010-10-11') THEN ${amount_due_remaining_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_vision_365_invoices {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2009-10-11') and DATE('2010-10-11') THEN ${amount_due_original_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_vision_365 {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: SAFE_DIVIDE(${dso_vision_365_payments},${dso_vision_365_invoices})*365 ;;
    value_format_name: decimal_1
  }

  measure: dso_365_payments {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2023-03-28') and DATE('2024-03-27') THEN ${amount_due_remaining_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_365_invoices {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2023-03-28') and DATE('2024-03-27') THEN ${amount_due_original_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_365 {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: SAFE_DIVIDE(${dso_365_payments},${dso_365_invoices})*365 ;;
    value_format_name: decimal_1
  }

  measure: dso_30_payments {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2024-02-26') and DATE('2024-03-27') THEN ${amount_due_remaining_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_30_invoices {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2024-02-26') and DATE('2024-03-27') THEN ${amount_due_original_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_30 {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: SAFE_DIVIDE(${dso_30_payments},${dso_30_invoices})*30 ;;
    value_format_name: decimal_1
  }

  measure: dso_90_payments {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2023-12-28') and DATE('2024-03-27') THEN ${amount_due_remaining_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_90_invoices {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: CASE WHEN ${transaction_date} between DATE('2023-12-28') and DATE('2024-03-27') THEN ${amount_due_original_target_currency} ELSE 0 END;;
    filters: [payment_class_code: "-PMT"]
  }

  measure: dso_90 {
    hidden: no
    view_label: "TEST STUFF"
    type: number
    sql: SAFE_DIVIDE(${dso_90_payments},${dso_90_invoices})*90 ;;
    value_format_name: decimal_1
  }
#   total_amount_adjusted_target_currency
#   total_amount_applied_target_currency
#   total_amount_credited_target_currency
#   total_amount_discounted_target_currency
#   total_amount_due_original_target_currency
#   total_amount_due_remaining_target_currency
#   total_tax_original_target_currency
#   total_tax_remaining_target_currency
#   total_receivables_target_currency
#   total_overdue_receivables_target_currency
#   total_doubtful_receivables_target_currency


  measure:  min_doubtful_receivables_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${doubtful_receivables_target_currency} ;;
  }

  measure:  min_tax_remaining_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${tax_remaining_target_currency} ;;
  }

  measure:  min_amount_adjusted_target_currency{
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${amount_adjusted_target_currency} ;;
  }

  measure:  min_amount_applied_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${amount_applied_target_currency} ;;
  }

  measure:  min_amount_credited_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${amount_credited_target_currency} ;;
  }

  measure:  min_amount_discounted_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${amount_discounted_target_currency} ;;
  }

  measure:  min_amount_due_original_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${amount_due_original_target_currency} ;;
  }
  measure:  min_tax_original_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: min
    sql: ${tax_original_target_currency} ;;
  }


#}
}
