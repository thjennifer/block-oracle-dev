include: "/views/base/currency_rate_md.view"

view: +currency_rate_md {

  dimension: key {
    type: string
    primary_key: yes
    sql: CONCAT(${conversion_date_key},${from_currency},${to_currency},${conversion_type}) ;;
  }

  dimension: conversion_date_key {
    type: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }

   }
