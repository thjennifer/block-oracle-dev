include: "/views/base/sales_payments_daily_agg__amounts.view"
include: "/views/core/sales_payments_common_amount_measures_ext.view"

view: +sales_payments_daily_agg__amounts {

  extends: [sales_payments_common_amount_measures_ext]

  fields_hidden_by_default: yes

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_payments_daily_agg.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
  }

  dimension: payment_class_code {
    hidden: yes
    type: string
    sql: ${sales_payments_daily_agg.payment_class_code} ;;
  }

  dimension: amount_adjusted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_adjusted}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_applied_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_applied}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_credited_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_credited}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_discounted_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_discounted}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_original}  ;;
    value_format_name: decimal_2
  }

  dimension: amount_due_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_remaining}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_original_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Original (@{label_get_target_currency}){%else%}Tax Amount Original (Target Currency){%endif%}"
    sql: ${total_tax_original}  ;;
    value_format_name: decimal_2
  }

  dimension: tax_remaining_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Tax Amount Remaining (@{label_get_target_currency}){%else%}Tax Amount Remaining (Target Currency){%endif%}"
    sql: ${total_tax_remaining}  ;;
    value_format_name: decimal_2
  }

  dimension: overdue_receivables_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}Past Due Receivables (@{label_get_target_currency}){%else%}Past Due Receivables (Target Currency){%endif%}"
    sql: ${total_overdue_remaining}   ;;
    value_format_name: decimal_2
  }

  dimension: doubtful_receivables_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "@{label_build}"
    sql: ${total_doubtful_remaining}   ;;
    value_format_name: decimal_2
  }





}