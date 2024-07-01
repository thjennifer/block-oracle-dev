# # Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: sales_applied_receivables_daily_agg {
#   hidden: yes
#     join: sales_applied_receivables_daily_agg__amounts {
#       view_label: "Sales Applied Receivables Daily Agg: Amounts"
#       sql: LEFT JOIN UNNEST(${sales_applied_receivables_daily_agg.amounts}) as sales_applied_receivables_daily_agg__amounts ;;
#       relationship: one_to_many
#     }
# }
view: sales_applied_receivables_daily_agg {
  sql_table_name: `@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesAppliedReceivablesDailyAgg` ;;

  dimension: amounts {
    hidden: yes
    sql: ${TABLE}.AMOUNTS ;;
  }
  dimension: application_type {
    type: string
    sql: ${TABLE}.APPLICATION_TYPE ;;
  }
  dimension: bill_to_customer_country {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_COUNTRY ;;
  }
  dimension: bill_to_customer_name {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NAME ;;
  }
  dimension: bill_to_customer_number {
    type: string
    sql: ${TABLE}.BILL_TO_CUSTOMER_NUMBER ;;
  }
  dimension: bill_to_site_use_id {
    type: number
    sql: ${TABLE}.BILL_TO_SITE_USE_ID ;;
  }
  dimension: business_unit_id {
    type: number
    sql: ${TABLE}.BUSINESS_UNIT_ID ;;
  }
  dimension: business_unit_name {
    type: string
    sql: ${TABLE}.BUSINESS_UNIT_NAME ;;
  }
  dimension_group: event {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.EVENT_DATE ;;
  }
  dimension: event_month_num {
    type: number
    sql: ${TABLE}.EVENT_MONTH_NUM ;;
  }
  dimension: event_quarter_num {
    type: number
    sql: ${TABLE}.EVENT_QUARTER_NUM ;;
  }
  dimension: event_year_num {
    type: number
    sql: ${TABLE}.EVENT_YEAR_NUM ;;
  }
  measure: count {
    type: count
    drill_fields: [business_unit_name, bill_to_customer_name]
  }
}

# view: sales_applied_receivables_daily_agg__amounts {

#   dimension: is_incomplete_conversion {
#     type: yesno
#     sql: IS_INCOMPLETE_CONVERSION ;;
#   }
#   dimension: sales_applied_receivables_daily_agg__amounts {
#     type: string
#     hidden: yes
#     sql: sales_applied_receivables_daily_agg__amounts ;;
#   }
#   dimension: target_currency_code {
#     type: string
#     sql: TARGET_CURRENCY_CODE ;;
#   }
#   dimension: total_applied {
#     type: number
#     sql: TOTAL_APPLIED ;;
#   }
#   dimension: total_received {
#     type: number
#     sql: TOTAL_RECEIVED ;;
#   }
# }
