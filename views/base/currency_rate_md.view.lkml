view: currency_rate_md {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.CurrencyRateMD` ;;

  dimension_group: conversion {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }
  dimension: conversion_rate {
    type: number
    sql: ${TABLE}.CONVERSION_RATE ;;
  }
  dimension: conversion_type {
    type: string
    sql: ${TABLE}.CONVERSION_TYPE ;;
  }
  dimension: from_currency {
    type: string
    sql: ${TABLE}.FROM_CURRENCY ;;
  }
  dimension: to_currency {
    type: string
    sql: ${TABLE}.TO_CURRENCY ;;
  }
  measure: count {
    type: count
  }
}
