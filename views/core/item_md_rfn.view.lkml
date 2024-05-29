include: "/views/base/item_md.view"

view: +item_md {

  sql_table_name: {% assign p = shared_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
                  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_REPORTING_VISION' %}
                  {% else %}{% assign t = 'CORTEX_ORACLE_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.ItemMD` ;;

  label: "Item MD"
 }
