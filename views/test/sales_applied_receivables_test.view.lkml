include: "/views/core/sales_applied_receivables_rfn.view"

view: +sales_applied_receivables {
  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesAppliedReceivables` ;;



#########################################################
# TEST STUFF
#{

 dimension_group: ledger {
   timeframes: [raw,date,week,quarter,year,yesno]
 }

#} end test stuff

   }
