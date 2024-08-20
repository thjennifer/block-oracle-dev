#########################################################{
# PURPOSE
# Currency exchange rates by date, from_currency, and to_currency
# where TO_CURRENCY matches the value in parameter_target_currency.
#
# Must be joined to an Explore that includes the view:
#   otc_common_parameters_xvw
#
# SOURCE
#   Refines view currency_rate_md.view
#
# REFERENCED BY
#   Hidden Explore currency_rate_md used for filter suggestions
#
#########################################################}

include: "/views/base/currency_rate_md.view"

view: +currency_rate_md {

  label: "Currency Rate MD"

  dimension: key {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${conversion_date_key},${from_currency},${to_currency},${conversion_type}) ;;
  }

  dimension: conversion_date_key {
    hidden: yes
    type: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }

  dimension: to_currency {
    sql: ${TABLE}.TO_CURRENCY;;
  }

  measure: count {
    label: "Row Count"
  }

  measure: date_count {
    type: count_distinct
    sql: ${conversion_raw} ;;
  }



   }
