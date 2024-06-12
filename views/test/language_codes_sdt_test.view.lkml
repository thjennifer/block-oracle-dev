include: "/views/core/language_codes_sdt.view"

view: +language_codes_sdt {

  derived_table: {
    sql:
      SELECT
      DISTINCT d.language as language_code
      FROM

    {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
    {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
    {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.ItemMD` ,
      UNNEST(ITEM_DESCRIPTIONS) AS d ;;
  }

   }
