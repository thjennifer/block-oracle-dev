include: "/views/core/sales_payments_rfn.view"

view: +sales_payments {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesPayments` ;;

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesPayments` ;;

  dimension: is_overdue {
    sql:  {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
             @{default_target_date_test} ${due_raw} < DATE('{{td}}') AND ${is_open}
          {% else %}${TABLE}.IS_OVERDUE
          {% endif%};;
  }

  dimension: days_overdue {
    sql: {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
             @{default_target_date_test}
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

  dimension_group: payment_close {
    timeframes: [raw,date, month, week, quarter, year, yesno]
    sql: NULLIF(${TABLE}.PAYMENT_CLOSE_DATE,PARSE_DATE('%F','4712-12-31'));;
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

dimension: is_transaction_date_same_as_invoice_date {
  hidden: no
  type: yesno
  view_label: "TEST STUFF"
  sql: ${transaction_raw} = ${sales_invoices.invoice_raw} ;;
}

# dimension: test_target_date  {
#   hidden: no
#   view_label: "TEST STUFF"
#   sql: @{default_target_date}'{{td}}' ;;
# }


#}
}
