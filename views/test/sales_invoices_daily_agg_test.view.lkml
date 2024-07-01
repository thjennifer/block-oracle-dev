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


#}

 }
