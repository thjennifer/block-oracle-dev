view: sales_invoices_common_amount_measures_ext {
  extension: required


  measure: total_transaction_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Transaction Amount ({{currency}}){%else%}Total Transaction Amount (Target Currency){%endif%}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_revenue_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Net Revenue Amount ({{currency}}){%else%}Total Net Revenue Amount (Target Currency){%endif%}"
    sql: ${revenue_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  # measure: total_gross_revenue_amount_target_currency {
  #   hidden: no
  #   type: sum
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Total Gross Revenue Amount ({{currency}}){%else%}Total Gross Revenue Amount (Target Currency){%endif%}"
  #   sql: ${gross_revenue_amount_target_currency} ;;
  #   value_format_name: decimal_0
  # }

  measure: total_tax_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Tax Amount ({{currency}}){%else%}Total Tax Amount (Target Currency){%endif%}"
    sql: ${tax_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: total_discount_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Discount Amount ({{currency}}){%else%}Total Discount Amount (Target Currency){%endif%}"
    sql: ${discount_amount_target_currency} ;;
    value_format_name: decimal_0
  }


}
