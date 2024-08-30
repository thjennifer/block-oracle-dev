view: currency_rate_md {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.CurrencyRateMD` ;;

  dimension_group: conversion {
    type: time
    description: "Date that the conversion is calculated from"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }
  dimension: conversion_rate {
    type: number
    description: "Currency conversion rate"
    sql: ${TABLE}.CONVERSION_RATE ;;
  }
  dimension: conversion_type {
    type: string
    description: "Currency conversion type"
    sql: ${TABLE}.CONVERSION_TYPE ;;
  }
  dimension: from_currency {
    type: string
    description: "Source currency type"
    sql: ${TABLE}.FROM_CURRENCY ;;
  }
  dimension: to_currency {
    type: string
    description: "Target currency type"
    sql: ${TABLE}.TO_CURRENCY ;;
  }
  measure: count {
    type: count
  }
}
