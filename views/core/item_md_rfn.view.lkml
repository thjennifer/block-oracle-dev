include: "/views/base/item_md.view"

view: +item_md {

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
                  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
                  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.ItemMD` ;;

  label: "Item MD"

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${inventory_item_id},${organization_id}) ;;
  }



 }