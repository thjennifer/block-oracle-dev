view: dso_dynamic_days_sdt {

  derived_table: {
    sql: {% assign d = parameter_dso_number_of_days._parameter_value %}
    SELECT
    {{d}} AS DSO_DAYS,
    DATE_SUB(DATE(@{default_target_date}) - 1, INTERVAL {{d}} DAY) AS DSO_START_DATE,
    @{default_target_date} - 1 AS DSO_END_DATE
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
  }

  dimension: dso_end_date {
    type: date
    group_label: "DSO Attributes"
    label: "DSO End Date"
    sql: ${TABLE}.DSO_END_DATE ;;
  }

  measure: days_sales_outstanding {
    type: number
    label: "{% if _field._is_selected %}@{derive_currency_label}Days Sales Outstanding ({{currency}}){%else%}Days Sales Outstanding (Target Currency){%endif%}"
    # sql: SAFE_DIVIDE(${sales_payments.total_amount_due_remaining_target_currency},${sales_payments.total_amount_due_original_target_currency}) * ANY_VALUE(${dso_days}) ;;
    sql: SAFE_DIVIDE(${sales_payments.total_receivables_target_currency},${sales_payments.total_amount_original_target_currency}) * ANY_VALUE(${dso_days}) ;;
    value_format_name: decimal_1
    # required_fields: [sales_payments.target_currency_code]
    drill_fields: [dso_details*]
  }

  set: dso_details{
    fields: [sales_payments.bill_to_customer_name,sales_payments.bill_to_customer_country,days_sales_outstanding]
  }

   }
