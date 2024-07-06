include: "/views/core/dso_02_dso_invoices_sdt.view"
include: "/views/core/dso_03_dso_payments_sdt.view"
view: dso_payments_and_invoices_pdt {

  label: "DSO Payments and Invoices Summary"

  derived_table: {
  datagroup_trigger: once_a_day_at_5

  sql:  SELECT
          COALESCE(dso_invoices.DSO_DAYS, dso_payments.DSO_DAYS) AS DSO_DAYS,
          COALESCE(dso_invoices.DSO_START_DATE, dso_payments.DSO_START_DATE) AS DSO_START_DATE,
          COALESCE(dso_invoices.DSO_END_DATE, dso_payments.DSO_END_DATE) AS DSO_END_DATE,
          COALESCE(dso_invoices.BILL_TO_SITE_USE_ID, dso_payments.BILL_TO_SITE_USE_ID) AS BILL_TO_SITE_USE_ID,
          COALESCE(dso_invoices.BILL_TO_CUSTOMER_NUMBER, dso_payments.BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
          COALESCE(dso_invoices.BILL_TO_CUSTOMER_NAME, dso_payments.BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
          COALESCE(dso_invoices.BILL_TO_CUSTOMER_COUNTRY, dso_payments.BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
          COALESCE(dso_invoices.BUSINESS_UNIT_ID, dso_payments.BUSINESS_UNIT_ID) AS BUSINESS_UNIT_ID,
          COALESCE(dso_invoices.BUSINESS_UNIT_NAME, dso_payments.BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
          COALESCE(dso_invoices.TARGET_CURRENCY_CODE, dso_payments.TARGET_CURRENCY_CODE) AS TARGET_CURRENCY_CODE,
          IFNULL(dso_invoices.TOTAL_REVENUE,0) AS TOTAL_REVENUE,
          IFNULL(dso_payments.TOTAL_REMAINING,0) AS TOTAL_REMAINING,
          COALESCE(dso_invoices.IS_INCOMPLETE_CONVERSION, dso_payments.IS_INCOMPLETE_CONVERSION) AS IS_INCOMPLETE_CONVERSION
        FROM
          ${dso_invoices_sdt.SQL_TABLE_NAME} AS dso_invoices
        FULL OUTER JOIN
          ${dso_payments_sdt.SQL_TABLE_NAME} AS dso_payments
        USING
          (DSO_DAYS,
            BILL_TO_SITE_USE_ID,
            BUSINESS_UNIT_ID,
            TARGET_CURRENCY_CODE)
    ;;

}

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${dso_days},${bill_to_site_use_id},${business_unit_id},${target_currency_code} ) ;;
  }

  dimension: dso_days {
    type: number
    label: "DSO Days"
    sql: ${TABLE}.DSO_DAYS ;;
  }

  dimension: dso_days_string {
    hidden: yes
    type: string
    sql: CAST(${dso_days} AS STRING) ;;
  }

  dimension: dso_start_date {
    type: date
    datatype: date
    label: "DSO Start Date"
    sql: ${TABLE}.DSO_START_DATE ;;
  }

  dimension: dso_end_date {
    type: date
    datatype: date
    label: "DSO End Date"
    sql: ${TABLE}.DSO_END_DATE ;;
  }

  dimension: bill_to_site_use_id {
    type: number
    sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
  }

  dimension: bill_to_customer_number {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
  }

  dimension: bill_to_customer_name {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
  }

  dimension: bill_to_customer_country {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
  }

  dimension: business_unit_id {
    type: number
    sql: ${TABLE}.BUSINESS_UNIT_ID ;;
  }

  dimension: business_unit_name {
    type: string
    sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
  }

  dimension: target_currency_code {
    type: string
    sql: ${TABLE}.TARGET_CURRENCY_CODE ;;
  }

  dimension: total_revenue {
    hidden: yes
    type: number
    sql: ${TABLE}.TOTAL_REVENUE ;;
  }

  dimension: total_remaining {
    hidden: yes
    type: number
    sql: ${TABLE}.TOTAL_REMAINING ;;
  }

  dimension: is_incomplete_conversion {
    type: yesno
    sql: ${TABLE}.IS_INCOMPLETE_CONVERSION ;;
  }

  # measure: total_revenue_amount_target_currency {
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Invoice Revenue Amount ({{currency}}){%else%}Invoice Revenue Amount (Target Currency){%endif%}"
  #   sql: ${total_revenue} ;;
  # }

  measure: total_revenue_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoice Revenue ({{currency}}){%else%}Total Invoice Revenue (Target Currency){%endif%}"
    sql: ${total_revenue} ;;
    # value_format_name: format_large_numbers_d1
    value_format_name: decimal_0
  }

  measure: total_amount_due_remaining_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Remaining ({{currency}}){%else%}Amount Due Remaining (Target Currency){%endif%}"
    sql: ${total_remaining} ;;
    # value_format_name: format_large_numbers_d1
    value_format_name: decimal_0
  }

  # measure: days_sales_outstanding {
  #   type: number
  #   label: "{% if _field._is_selected %}@{derive_currency_label}DSO Value ({{currency}}){%else%}DSO Value (Target Currency){%endif%}"
  #   sql: SAFE_DIVIDE(${total_amount_due_remaining_target_currency},${total_revenue_amount_target_currency}) * ANY_VALUE(${dso_days}) ;;
  #   value_format_name: decimal_1
  #   required_fields: [dso_days,target_currency_code]
  # }

  measure: days_sales_outstanding {
    type: number
    label: "{% if _field._is_selected %}@{derive_currency_label}DSO Value ({{currency}}){%else%}DSO Value (Target Currency){%endif%}"
    sql: SAFE_DIVIDE(${total_amount_due_remaining_target_currency},${total_revenue_amount_target_currency}) * ANY_VALUE(${dso_days}) ;;
    value_format_name: decimal_1
    required_fields: [dso_days,target_currency_code]
    drill_fields: [dso_details*]
  }

  set: dso_details{
    fields: [bill_to_customer_name,bill_to_customer_country,days_sales_outstanding]
  }



}
