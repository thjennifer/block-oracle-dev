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
           {% assign td = '2024-03-28' %} {%else%}
           {% assign td = 'now' | date: '%Y-%m-%d' %}{%endif%}'{{td}}'"
  }

constant: sample_target_date {
  value:  "'2024-03-28'"
}

constant: default_target_date_test {
  value: "{% if _user_attributes['cortex_oracle_ebs_use_test_data'] == 'yes' %}
               {% if otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value == 'demo' %}
                      {% assign td = '2024-03-28' %} {%else%} {% assign td = '2010-10-12' %}
               {% endif %}
          {%else%}{% assign td = now | date: '%Y-%m-%d' %}{%endif%}'{{td}}'"
}

constant: sample_target_date_test {
  value: "{% if otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value == 'demo' %}
          {% assign td = '2024-03-28' %} {%else%} {% assign td = '2010-10-12' %}
          {% endif %}'{{td}}'"
}


#####Need to remove reference to test_or_demo
constant: link_sales_invoices_source_to_target_dashboard_filters {
  value: "sales_invoices.invoice_date|date||sales_invoices.business_unit_name|business_unit||sales_invoices.bill_to_customer_country|customer_country||sales_invoices.bill_to_customer_name|customer_name||sales_invoices__lines.order_source_name|order_source||sales_invoices__lines.category_description|item_category||otc_common_parameters_xvw.parameter_target_currency|target_currency||otc_common_parameters_xvw.parameter_use_demo_or_test_data|test_or_demo"
}

# test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data

constant: link_vis_table {
  value: "{% assign vis_config = '{\"type\":\"looker_grid\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_column {
  value: "{% assign vis_config = '{\"type\":\"looker_column\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_bar {
  value: "{% assign vis_config = '{\"type\":\"looker_bar\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_area {
  value: "{% assign vis_config = '{\"type\":\"looker_area\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_line {
  value: "{% assign vis_config = '{\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_map {
  value: "{% assign vis_config = '{\"type\":\"looker_map\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_pie {
  value: "{% assign vis_config = '{\"type\":\"looker_pie\"}' | url_encode | prepend: '&vis_config=' %}"
}

constant: link_vis_single {
  value: "{% assign vis_config = '{\"type\":\"single_value\"}' | url_encode | prepend: '&vis_config=' %}"
}



constant: link_generate_variable_defaults {
  value: "
  {% comment %} Variables to default if not created {% endcomment %}

  {% comment %} User Customizable Parameters {% endcomment %}
  {% assign drill_fields = '' %}
  {% assign pivots = '' %}
  {% assign subtotals = '' %}
  {% assign sorts = '' %}
  {% assign limit = '500' %}
  {% assign column_limit = '50' %}
  {% assign total = '' %}
  {% assign row_total = '' %}
  {% assign query_timezone = '' %}
  {% assign dynamic_fields = '' %}

  {% comment %} Default Visualizations Parameters {% endcomment %}
  @{link_vis_table}

  {% comment %} Default Behavior Parameters {% endcomment %}
  {% assign default_filters_override = false %}
  {% assign default_filters = '' %}
  {% assign new_page = false %}
  {% assign different_explore = false %}
  {% assign target_model = '' %}
  {% assign target_explore = '' %}

  {% comment %} Variables to be built in code below {% endcomment %}
  {% assign filters_mapping = '' %}
  {% assign target_content_filters = '' %}
  {% assign target_default_content_filters = '' %}
  {% assign link_host = '' %}
  "
}

constant: link_host {
  #Could assign a user_attribute since it won't be used with the generator
  value: "{% assign link_host = 'https://cortexdev.cloud.looker.com' %}"
}

constant: link_extract_context {
  value: "
  {% assign filters_array = '' %}
  {% for parameter in link_query_parameters %}
      {% assign parameter_key = parameter | split:'=' | first %}
      {% assign parameter_value = parameter | split:'=' | last %}
      {% assign parameter_test = parameter_key | slice: 0,2 %}
      {% if parameter_test == 'f[' %}
        {% comment %} Link contains multiple parameters, need to test if filter {% endcomment %}
        {% if parameter_key != parameter_value %}
          {% comment %} Tests if the filter value is is filled in, if not it skips  {% endcomment %}
          {% assign parameter_key_size = parameter_key | size %}
          {% assign slice_start = 2 %}
          {% assign slice_end = parameter_key_size | minus: slice_start | minus: 1 %}
          {% assign parameter_key = parameter_key | slice: slice_start, slice_end %}
          {% assign parameter_clean = parameter_key | append:'|' |append: parameter_value %}
          {% assign filters_array =  filters_array | append: parameter_clean | append: ',' %}
        {% endif %}
    {% elsif parameter_key == 'dynamic_fields' %}
        {% assign dynamic_fields = parameter_value %}
    {% elsif parameter_key == 'query_timezone' %}
        {% assign query_timezone = parameter_value %}
    {% endif %}
  {% endfor %}
  {% assign size = filters_array | size | minus: 1 %}
  {% assign filters_array = filters_array | slice: 0, size %}
  "
}

constant: link_match_filters_to_destination {
  value: "
  {% assign filters_mapping = filters_mapping | split: '||' %}
  {% assign filters_array = filters_array | split: ',' %}
  {% assign filters_array_destination = '' %}

  {% for source_filter in filters_array %}
  {% assign source_filter_key = source_filter | split:'|' | first %}
  {% assign source_filter_value = source_filter | split:'|' | last %}

      {% for destination_filter in filters_mapping %}
          {% comment %} This will loop through the value pairs to determine if there is a match to the destination {% endcomment %}
          {% assign destination_filter_key = destination_filter | split:'|' | first %}
          {% assign destination_filter_value = destination_filter | split:'|' | last %}
          {% if source_filter_key == destination_filter_key %}
              {% assign parameter_clean = destination_filter_value | append:'|' | append: source_filter_value %}
              {% assign filters_array_destination =  filters_array_destination | append: parameter_clean | append:',' %}
            {% endif %}
      {% endfor %}
  {% endfor %}
  {% assign size = filters_array_destination | size | minus: 1 | at_least: 0 %}
  {% assign filters_array_destination = filters_array_destination | slice: 0, size %}
  "
}

constant: link_build_filter_string {
  value: "
  {% assign filter_string = '' %}
  {% assign filters_array_destination = filters_array_destination | split: ',' %}
  {% for filter in filters_array_destination %}
  {% assign filter_key = filter | split:'|' | first %}
  {% assign filter_value = filter | split:'|' | last %}

  {% if content == '/explore/' %}
  {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
  {% else %}
  {% assign filter_value = filter_value | encode_url %}
  {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
  {% endif %}

  {% assign filter_string = filter_string | append: filter_compile | append:'&' %}
  {% endfor %}
  {% assign size = filter_string | size | minus: 1 | at_least: 0 %}
  {% assign filter_string = filter_string | slice: 0, size %}
  "
}

constant: link_build_default_filter_string {
  value: "
  {% assign default_filter_string = '' %}
  {% assign default_filters = default_filters | split: ',' %}
  {% for filter in default_filters %}
  {% assign filter_key = filter | split:'=' | first %}
  {% assign filter_value = filter | split:'=' | last %}
  {% if content == '/explore/' %}
  {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
  {% else %}
  {% assign filter_value = filter_value | encode_url %}
  {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
  {% endif %}
  {% assign default_filter_string = default_filter_string | append: filter_compile | append:'&' %}
  {% endfor %}
  {% assign size = default_filter_string | size | minus: 1 | at_least: 0 %}
  {% assign default_filter_string = default_filter_string | slice: 0, size %}
  "
}

constant: link_generate_dashboard_variable {
  value: "
  {% assign content = '/dashboards-next/' %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign target_content_filters = '' %}
  {% assign host = '' %}

  {% if new_page %}
  @{link_host}
  {% endif %}

  @{link_extract_context}
  @{link_match_filters_to_destination}
  @{link_build_filter_string}

  {% if default_filters != '' %}
  @{link_build_default_filter_string}
  {% endif %}

  {% if default_filters_override == true and default_filters != '' %}
  {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
  {% elsif default_filters_override == false and default_filters != '' %}
  {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
  {% else %}
  {% assign target_content_filters = filter_string %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  {% assign dashboard_url = host | append:content | append:target_dashboard | append: '?' | append: target_content_filters %}
  "
}


constant: link_generate_dashboard_url {
  value: "
  {% assign content = '/dashboards/' %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign target_content_filters = '' %}
  {% assign link_host = '' %}

  {% if new_page %}
  @{link_host}
  {% endif %}

  @{link_extract_context}
  @{link_match_filters_to_destination}
  @{link_build_filter_string}

  {% if default_filters != '' %}
  @{link_build_default_filter_string}
  {% endif %}

  {% if default_filters_override == true and default_filters != '' %}
  {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
  {% elsif default_filters_override == false and default_filters != '' %}
  {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
  {% else %}
  {% assign target_content_filters = filter_string %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  {{ link_host | append:content | append:target_dashboard | append: '?' | append: target_content_filters }}
  "
}

constant: link_unselected_button_style {
  value: "
  display: block;
  border-spacing: 0;
  border-collapse: separate;
  border-radius: 6px;
  border: 1px solid #dcdcdc;
  margin-left: 0px;
  margin-bottom: 5px;
  padding: 6px 10px;
  line-height: 1.5;
  user-select: none;
  background-color: #878ca0;
  color: white;
  font-size: 12px;
  font-style: tahoma;
  font-weight: normal;
  text-align: center;
  text-decoration: none;
  letter-spacing: 0px;
  white-space: normal;"
}
