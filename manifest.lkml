constant: CONNECTION_NAME {
  value: "cortex-oracle-dev"
  export: override_required
}

constant: GCP_PROJECT_ID {
  value: "kittycorn-dev-incorta"
  export: override_required
}

constant: REPORTING_DATASET {
  value: "CORTEX_ORACLE_EBS_REPORTING"
  export: override_required
}

# constant: CONNECTION_NAME {

#   value: "qa-thjennifer1"
#   export: override_required
# }

# constant: GCP_PROJECT_ID {

#   value: "thjennifer1"
#   export: override_required
# }

# Constant derive_currency_label
# captures and formats selected Target Currency for use in 'labels' property
# example use:
#   measure: sum_ordered_amount {
#     type: sum
#     label: "@{derive_currency_label}Total Sales ({{currency}})"
#     sql: ${ordered_amount_target_currency} ;;
#     }

constant: derive_currency_label {
  value: "{% assign currency = otc_common_parameters_xvw.parameter_target_currency._parameter_value | remove: \"'\" %}"
}




constant: image_dashboard_navigation {
  value: ""
  # value: "https://marketplace-api.looker.com/block-icons/cortex_icon.png"
}

constant: view_label_for_filters {
  value: "🔍 Filters & 🛠 Tools"
}

# Constant is_agg_category_in_query
# provides first part of liquid IF statement to check if any of these category fields from
# sales_orders_agg__lines are in the query (either selected dimension or filter):
#     category_id, category_description, category_name,
#     item_organization_id, item_orgranization_name
#
# when used, must complete the rest of the statement (what to return when true and false
# For example:
#   measure: order_count {
#     type: sum
#     sql: @{is_agg_category_selected}NULL {%else} ${num_orders} {% endif %} ;;
#.  }

constant: is_agg_category_in_query {
  value: "{% if sales_orders_daily_agg__lines.category_id._in_query or
                sales_orders_daily_agg__lines.category_description._in_query or
                sales_orders_daily_agg__lines.category_name._in_query or
                sales_orders_daily_agg__lines.item_organization_id._in_query or
                sales_orders_daily_agg__lines.item_organization_name._in_query
                %}"
}


constant: get_category_set {
  value: "{% assign d = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
          {% if d == 'test' %}{% assign category_set = 'Purchasing' %}{%elsif d == 'demo' %}
          {% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}
          {% else %} {% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}
          {% endif %}"
}

constant: default_target_date {
  value:  "{% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
           {% assign td = '2024-04-01' %} {%else%}
           {% assign td = now | date: '%Y-%m-%d' %}{%endif%}"
  }

constant: default_target_date_test {
  value: "{% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
               {% if otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value == 'demo' %}
                      {% assign td = '2024-04-01' %} {%else%} {% assign td = '2010-10-12' %}
               {% endif %}
          {%else%}{% assign td = now | date: '%Y-%m-%d' %}{%endif%}"
}
