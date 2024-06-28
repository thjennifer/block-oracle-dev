include: "/views/base/sales_payments_daily_agg.view"
include: "/views/core/otc_fiscal_gl_dates_ext.view"
include: "/views/core/sales_payments_common_fields_ext.view"
include: "/views/core/sales_payments_daily_agg_sample_pdt.view"


view: +sales_payments_daily_agg {

  extends: [otc_fiscal_gl_dates_ext,sales_payments_common_fields_ext]

  sql_table_name: {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}${sales_payments_daily_agg_sample_pdt.SQL_TABLE_NAME}{%else%}`@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.SalesPaymentsDailyAgg`{%endif%} ;;

  dimension: key {
    hidden: no
    primary_key: yes
    sql: CONCAT(${transaction_raw},${bill_to_site_use_id},${business_unit_id},${payment_class_code}) ;;
  }


#########################################################
# Payment Class / Business Unit / Customer Dimensions
#{

  dimension: payment_class_code {
    hidden: no
  }
  dimension: business_unit_id {hidden: no}

  dimension: business_unit_name {
    hidden: no
    sql: COALESCE(${TABLE}.BUSINESS_UNIT_NAME,CONCAT("Business Unit ID: ", CAST(${business_unit_id} as STRING))) ;;
  }

  dimension: bill_to_site_use_id {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_SITE_USE_ID,-1) ;;
  }

  dimension: bill_to_customer_name {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_NAME,"Unknown") ;;
  }

  dimension: bill_to_customer_number {
    group_label: "Bill to Customer"
  }

  dimension: bill_to_customer_country {
    hidden: no
    group_label: "Bill to Customer"
    sql: COALESCE(${TABLE}.BILL_TO_CUSTOMER_COUNTRY,"Unknown") ;;
  }

#} end payment_class_code / business unit / customer dimensions

#########################################################
# Amounts in Target Currency as dimensions
#{

  dimension: currency_target {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
    type: yesno
    group_label: "Amounts"
    sql: (select MAX(IS_INCOMPLETE_CONVERSION) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
  }

  dimension: amount_adjusted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_ADJUSTED) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %}) ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_APPLIED) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Credited ({{currency}}){%else%}Amount Credited (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_CREDITED) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})   ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Discounted ({{currency}}){%else%}Amount Discounted (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_DISCOUNTED) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Original ({{currency}}){%else%}Amount Due Original (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_ORIGINAL) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Amount Due Remaining ({{currency}}){%else%}Amount Due Remaining (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_REMAINING) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Original ({{currency}}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_TAX_ORIGINAL) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})   ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount Remaining ({{currency}}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_TAX_REMAINING) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})   ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Past Due Receivables ({{currency}}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_OVERDUE_REMAINING) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})   ;;
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Doubtful Receivables ({{currency}}){%else%}Doubtful Receivables (Target Currency){%endif%}"
    sql: (select SUM(TOTAL_DOUBTFUL_REMAINING) FROM sales_payments_daily_agg.amounts WHERE TARGET_CURRENCY_CODE = {% parameter otc_common_parameters_xvw.parameter_target_currency %})   ;;
    value_format_name: decimal_2
  }

#} end amount dimensions

  # measure: total_amount_adjusted_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Amount Adjusted ({{currency}}){%else%}Amount Adjusted (Target Currency){%endif%}"
  #   sql: ${amount_adjusted_target_currency} ;;
  #   value_format_name: decimal_2
  #   # filters: [is_payment_transaction: "No"]
  # }

  # measure: total_amount_applied_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Amount Applied ({{currency}}){%else%}Amount Applied (Target Currency){%endif%}"
  #   sql: ${amount_applied_target_currency} * if(${payment_class_code} = 'CM',-1,1) ;;
  #   value_format_name: decimal_2
  #   # filters: [is_payment_transaction: "No"]
  # }


}
