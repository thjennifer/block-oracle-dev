include: "/views/base/sales_invoices_daily_agg__amounts.view"

view: +sales_invoices_daily_agg__amounts {

  fields_hidden_by_default: yes

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${sales_invoices_daily_agg.key},${target_currency_code},${is_incomplete_conversion}) ;;
  }

  #HIDE ORIGINAL TOTAL_ fields and rename to match sales_invoices_lines to share descriptions and labels

  dimension: currency_target {
    hidden: no
    type: string
    group_label: "Amounts"
    label: "Currency (Target)"
    sql: {% parameter otc_common_parameters_xvw.parameter_target_currency %} ;;
  }

  dimension: is_incomplete_conversion {
    hidden: no
    group_label: "Amounts"
  }

  # dimension: revenue_amount_target_currency {
  #   hidden: no
  #   type: number
  #   group_label: "Amounts"
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Net Revenue Amount ({{currency}}){%else%}Net Revenue Amount (Target Currency){%endif%}"
  #   description: "Amount in target currency recognized as revenue for accounting purposes."
  #   sql:  ;;
  #   value_format_name: decimal_2
  # }

  # dimension: gross_revenue_amount_target_currency {
  #   hidden: no
  #   type: number
  #   group_label: "Amounts"
  #   label: "{% if _field._is_selected %}@{derive_currency_label}Gross Revenue Amount ({{currency}}){%else%}Gross Revenue Amount (Target Currency){%endif%}"
  #   description: "Amount in target currency recognized as revenue for accounting purposes."
  #   sql: ${revenue_amount} * IF(${sales_invoices.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
  #   value_format_name: decimal_2
  # }

  dimension: transaction_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Transaction Amount ({{currency}}){%else%}Transaction Amount (Target Currency){%endif%}"
    description: "Invoice line amount in target currency."
    sql: ${total_transaction};;
    value_format_name: decimal_2
  }

  dimension: tax_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Tax Amount ({{currency}}){%else%}Tax Amount (Target Currency){%endif%}"
    sql: ${total_tax} ;;
    value_format_name: decimal_2
  }

  dimension: discount_amount_target_currency {
    hidden: no
    type: number
    group_label: "Amounts"
    label: "{% if _field._is_selected %}@{derive_currency_label}Discount Amount ({{currency}}){%else%}Discount Amount (Target Currency){%endif%}"
    sql: ${total_discount}  ;;
    value_format_name: decimal_2
  }

  measure: total_transaction_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Net Revenue Amount ({{currency}}){%else%}Total Net Revenue Amount (Target Currency){%endif%}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: decimal_0
  }

   }
