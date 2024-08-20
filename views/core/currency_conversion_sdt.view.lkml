#########################################################{
# PURPOSE
# SQL Derived Table (SDT) which selects a subset of CurrencyConversion
# where TO_CURRENCY matches the value in parameter_target_currency.
#
# Must be joined to an Explore that includes the view:
#   otc_common_parameters_xvw
#
# SOURCE
#   `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.CurrencyRateMD`
#
# REFERENCED BY
#   Explores & Views:
#     sales_orders
#     sales_invoices
#     sales_payments
#     sales_applied_receivables
#
#########################################################}

view: currency_conversion_sdt {
  derived_table: {
    sql: SELECT
          CONVERSION_DATE,
          FROM_CURRENCY,
          TO_CURRENCY,
          CONVERSION_RATE
        FROM
          `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.CurrencyRateMD`
        WHERE
            TO_CURRENCY = {% parameter otc_common_parameters_xvw.parameter_target_currency %}
         ;;
  }

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${conversion_date},${from_currency}) ;;
  }

  dimension: conversion_date {
    type: date
    datatype: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }

  dimension: from_currency {
    type: string
    label: "Currency (Source)"
    sql: ${TABLE}.FROM_CURRENCY ;;
  }

  dimension: to_currency {
    type: string
    label: "Currency (Target)"
    sql: ${TABLE}.TO_CURRENCY ;;
  }

  dimension: conversion_rate {
    type: number
    sql: ${TABLE}.CONVERSION_RATE ;;
    value_format_name: decimal_4
  }


}
