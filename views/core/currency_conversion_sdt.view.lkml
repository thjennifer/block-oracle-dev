######################
# select from CurrencyConversion for given:
#   - Client ID
#   - Exchange Rate Type
#   - Target Currency (from parameter select_target_currency)
#   - Conversion Date Range (from filter partition_date_filter)
######################


view: currency_conversion_sdt {
  derived_table: {
    sql: SELECT
          CONVERSION_DATE,
          FROM_CURRENCY,
          TO_CURRENCY,
          CONVERSION_RATE
        FROM
          --`@{GCP_PROJECT_ID}.@{REPORTING_DATASET}.CurrencyRateMD`
          --`@{GCP_PROJECT_ID}.{% parameter sales_orders.parameter_use_test_or_demo_data %}.CurrencyRateMD`
                  {% assign p = sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data._parameter_value %}
                  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_REPORTING_VISION' %}
                  {% else %}{% assign t = 'CORTEX_ORACLE_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.CurrencyRateMD`
        WHERE
            TO_CURRENCY = {% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}
          {% if _explore._name == 'sales_orders' %}

            --AND {% condition sales_orders.filter_ordered_date %} TIMESTAMP(CONVERSION_DATE) {% endcondition %}
          {% else %}
            AND {% condition filter_date %} TIMESTAMP(CONVERSION_DATE) {% endcondition %}
          {% endif %}


          --AND {% condition filter_date %} TIMESTAMP(CONVERSION_DATE) {% endcondition %}
         ;;
  }

  dimension: key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${conversion_date},${from_currency}) ;;
  }

  dimension: conversion_date {
    type: date
    datatype: date
    sql: ${TABLE}.CONVERSION_DATE ;;
  }

  dimension: from_currency {
    type: string
    label: "Currency (Source)"
    # sql: COALESCE(${TABLE}.FROM_CURRENCY,{% parameter parameter_target_currency %}) ;;
    sql: ${TABLE}.FROM_CURRENCY ;;
  }

  dimension: to_currency {
    type: string
    label: "Currency (Target)"
    sql: COALESCE(${TABLE}.TO_CURRENCY,{% parameter sales_orders_common_parameters_xvw.parameter_target_currency %}) ;;
    # sql: ${TABLE}.TO_CURRENCY ;;
  }

  dimension: conversion_rate {
    type: number
    # sql: COALESCE(${TABLE}.CONVERSION_RATE,1) ;;
    sql: ${TABLE}.CONVERSION_RATE ;;
    value_format_name: decimal_4
  }





  filter: filter_date {
    type: date
  }

  # parameter: parameter_target_currency {
  #   hidden: no
  #   type: string
  #   view_label: "🔍 Filters & 🛠 Tools"
  #   label: "Target Currency"
  #   suggest_explore: currency_rate_md
  #   suggest_dimension: currency_rate_md.to_currency
  #   default_value: "USD"
  #   # full_suggestions: yes
  # }




}