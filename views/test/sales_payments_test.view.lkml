include: "/views/core/sales_payments_rfn.view"

view: +sales_payments {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesPayments` ;;

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesPayments` ;;

  dimension: is_overdue {
    sql:  {% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
             @{default_target_date} ${TABLE}.DUE_DATE < DATE('{{td}}') AND ${amount_due_remaining} > 0
          {% else %}${TABLE}.IS_OVERDUE
          {% endif%};;
  }

 }

# (  (Payments.DUE_DATE < CURRENT_DATE AND Payments.AMOUNT_DUE_REMAINING > 0)
#     OR Payments.DUE_DATE < Payments.PAYMENT_DATE
# )
