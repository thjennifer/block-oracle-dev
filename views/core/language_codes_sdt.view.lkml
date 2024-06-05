view: language_codes_sdt {
  derived_table: {
    sql:  {% assign p = otc_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
                  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
                  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}

          SELECT
            DISTINCT d.language as language_code
          FROM
          `@{GCP_PROJECT_ID}.{{t}}.ItemMD`,
          UNNEST(ITEM_DESCRIPTIONS) AS d ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

}