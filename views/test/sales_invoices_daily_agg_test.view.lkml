include: "/views/core/sales_invoices_daily_agg_rfn.view"
include: "/views/test/otc_common_item_categories_ext_test.view"
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
        @{link_build_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign use_qualified_filter_names = false %}
        {% assign source_to_destination_filters_mapping = '@{link_map_sales_invoices_to_invoice_details}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

        {% assign use_default_filters_to_override = false %}
        @{link_build_dashboard_url}
        "
      }
}

#}
}