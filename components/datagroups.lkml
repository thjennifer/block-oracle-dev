datagroup: cortex_default_datagroup {
  max_cache_age: "1 hour"
}

datagroup: one_time {
  # pdt will be create when initially called but not updated again
  sql_trigger: SELECT 1 ;;
  description: "Triggered only one time"
}

datagroup: monthly_on_day_1 {
  sql_trigger: SELECT extract(month FROM current_date) ;;
  description: "Triggers on first day of the month"
}

datagroup: once_a_day_at_5 {
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*5)/(60*60*24)) ;;
  description: "Tirggered daily at 5:00am"
}

datagroup: sales_payments_daily_agg_change {
  sql_trigger: SELECT MAX(transaction_date) FROM `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg` ;;
  description: "Triggers when max(transaction_date) in SalesPaymentsDailyAgg changes"
}