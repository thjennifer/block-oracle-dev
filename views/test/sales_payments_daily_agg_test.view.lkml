include: "/views/core/sales_payments_daily_agg_rfn.view"
include: "/views/test/sales_payments_daily_agg_test_data_pdt_test.view"

view: sales_payments_daily_agg_test {

  # sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  # {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  # {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesPaymentsDailyAgg` ;;

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}
  {% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
  {% if test_data == 'YES' %}${sales_payments_daily_agg_test_data_pdt.SQL_TABLE_NAME}
  {%else%}`@{GCP_PROJECT_ID}.{{t}}.SalesPaymentsDailyAgg`{%endif%} ;;


  measure: days_sales_outstanding {
    hidden: no
    type: string
    sql: MAX('COMING SOON') ;;
    html: "🚧" ;;
  }

   }