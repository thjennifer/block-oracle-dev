view: sales_invoices_common_amount_measures_ext {
  extension: required


  measure: total_transaction_amount_target_currency {
    hidden: no
    type: sum
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoice Amount ({{currency}}){%else%}Total Invoice Amount (Target Currency){%endif%}"
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

  # measure: total_gross_transaction_amount_target_currency {
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


  measure: total_transaction_amount_target_currency_formatted {
    hidden: no
    type: sum
    group_label: "Formatted as Large Numbers"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Invoice Amount ({{currency}}){%else%}Total Invoice Amount (Target Currency){%endif%}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'| append: '||invoice_month|date'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_discount_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Formatted as Large Numbers"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Discount Amount ({{currency}}){%else%}Total Discount Amount (Target Currency){%endif%}"
    sql: ${total_discount_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details' %}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_tax_amount_target_currency_formatted {
    hidden: no
    type: number
    group_label: "Formatted as Large Numbers"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Tax Amount ({{currency}}){%else%}Total Tax Amount (Target Currency){%endif%}"
    sql: ${total_tax_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  # dummy field used for dynamic drill links
  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }


}
