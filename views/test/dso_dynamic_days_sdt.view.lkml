view: dso_dynamic_days_sdt {

  derived_table: {
    sql: {% assign d = parameter_dso_number_of_days._parameter_value %}
    SELECT
    {{d}} AS DSO_DAYS,
    DATE(DATE_SUB(DATE(@{default_target_date}) - 1, INTERVAL {{d}} DAY)) AS DSO_START_DATE,
    DATE(@{default_target_date} - 1) AS DSO_END_DATE
    ;;
  }


  parameter: parameter_dso_number_of_days {
    type: number
    view_label: "@{view_label_for_filters}"
    label: "Number of Days to use for DSO Calculation"
    allowed_value: {value: "30"}
    allowed_value: {value: "90"}
    allowed_value: {value: "365"}
    default_value: "365"
  }

  dimension: dso_days {
    type: number
    group_label: "DSO Attributes"
    label: "DSO Days"
    primary_key: yes
    sql: ${TABLE}.DSO_DAYS ;;
  }

  dimension: dso_days_string {
    hidden: yes
    group_label: "DSO Attributes"
    type: string
    sql: CAST(${dso_days} as STRING) ;;
    order_by_field: dso_days
  }

  dimension: dso_start_date {
    type: date
    group_label: "DSO Attributes"
    label: "DSO Start Date"
    sql: ${TABLE}.DSO_START_DATE ;;
    convert_tz: no
  }

  dimension: dso_end_date {
    type: date
    group_label: "DSO Attributes"
    label: "DSO End Date"
    sql: ${TABLE}.DSO_END_DATE ;;
    convert_tz: no
  }

  measure: dso_period_receivables {
    hidden: yes
    type: sum
    label: "DSO Period Total Receivables (Target Currency)"
    sql: ${sales_payments_daily_agg.amount_due_remaining_target_currency};;
    filters: [dso_dynamic_days_sdt.dso_days: ">0",sales_payments_daily_agg.payment_class_code: "-PMT"]
  }

  measure: dso_period_amount_original {
    hidden: yes
    type: sum
    label: "DSO Period Total Amount Original (Target Currency)"
    sql: ${sales_payments_daily_agg.amount_due_original_target_currency};;
    filters: [dso_dynamic_days_sdt.dso_days: ">0",sales_payments_daily_agg.payment_class_code: "-PMT"]
  }

  measure: days_sales_outstanding {
    hidden: no
    type: number
    label: "@{label_build}"
    sql: SAFE_DIVIDE(${dso_period_receivables},${dso_period_amount_original}) * ANY_VALUE(${dso_dynamic_days_sdt.dso_days}) ;;
    value_format_name: decimal_1
    drill_fields: [dso_details*]
  }

  set: dso_details {
    fields: [sales_payments_daily_agg.bill_to_customer_name,sales_payments_daily_agg.bill_to_customer_country,days_sales_outstanding]
  }

   }
