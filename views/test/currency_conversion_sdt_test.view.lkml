include: "/views/core/currency_conversion_sdt.view"

view: +currency_conversion_sdt {

  derived_table: {
    sql: SELECT
          CONVERSION_DATE,
          FROM_CURRENCY,
          TO_CURRENCY,
          CONVERSION_RATE
        FROM
          {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
          {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
          {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.CurrencyRateMD`

        WHERE
            TO_CURRENCY = {% parameter otc_common_parameters_xvw.parameter_target_currency %}
         ;;
  }

   }
