######################
# select from CurrencyConversion for given:
#   - Client ID
#   - Exchange Rate Type
#   - Target Currency (from parameter select_target_currency)
#   - Conversion Date Range (from filter partition_date_filter)
######################


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

  dimension: conversion_rate2 {
    type: number
    sql: ${TABLE}.CONVERSION_RATE ;;
    value_format_name: decimal_4
  }





}
