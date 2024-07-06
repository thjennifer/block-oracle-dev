include: "/views/base/currency_rate_md.view"

view: +currency_rate_md {

  label: "Currency Rate MD"

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${conversion_date_key},${from_currency},${to_currency},${conversion_type}) ;;
  }

  dimension: conversion_date_key {
    type: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }

  measure: date_count {
    type: count_distinct
    sql: ${conversion_raw} ;;
  }

  dimension: to_currency {
    # sql: COALESCE(${TABLE}.TO_CURRENCY,{% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
    sql: ${TABLE}.TO_CURRENCY;;

  }

   }
