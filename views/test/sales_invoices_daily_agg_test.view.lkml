include: "/views/core/sales_invoices_daily_agg_rfn.view"
view:
  +sales_invoices_daily_agg {

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesInvoicesDailyAgg` ;;
#########################################################
# TEST STUFF
#
#{
    measure: total2_transaction_amount_target_currency_formatted {
      hidden: no
      type: sum
      view_label: "TEST STUFF"
      group_label: "Formatted as Large Numbers"
      sql: ${transaction_amount_target_currency} ;;
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
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

        {% assign default_filters_override = false %}
        @{link_generate_dashboard_url}
        "
      }
}

#}
}
