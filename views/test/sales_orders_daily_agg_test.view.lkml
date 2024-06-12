include: "/views/core/sales_orders_daily_agg_rfn.view"

view: +sales_orders_daily_agg {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesOrdersDailyAgg` ;;
  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesOrdersDailyAgg` ;;

#########################################################
# TEST STUFF
#{

  dimension: is_diff_ship_to_and_bill_to {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${ship_to_customer_number}<>${bill_to_customer_number} ;;
  }

  # dimension: is_field_selected {
  #   hidden: no
  #   view_label: "TEST STUFF"
  #   sql: {% assign field_list = 'item_category_id,category_description' | split: ',' %}
  #       {% assign r = 'false' %}
  #       {% for field in field_list %}
  #         {% assign field_in_query = 'sales_orders_daily_agg__lines.' | append: field | append: '._in_query' %}
  #         {% if field_in_query == true %}

  #         {% assign r = 'true' %}
  #         {% break %}
  #         {% endif %}

  #         {% endfor %}
  #         {{r}}
  #       ;;
  # }

  # {% if field_in_query %}
  # {% if sales_orders_daily_agg__lines.item_category_id._in_query %}
#   {% assign potential_grouping_dims = 'field_name_1,field_name_2,field_name_3’ | split: ',' %}

# {% assign grouping_dims = ‘’ %}

# {% for dim in potential_grouping_dims %}

#     {% assign assigned_dim_in_query = 'view_name_1.' | append: dim | append: '._in_query' %}

#     {% if assigned_dim_in_query  %}

#         {% assign grouping_dims = grouping_dims | append: dim | append: ',' %}

#     {% endif %}

# {% endfor %}

#} end test stuff


 }
