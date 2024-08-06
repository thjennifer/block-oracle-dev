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

# constant: derive_currency_label {
#   value: "{% assign currency = otc_common_parameters_xvw.parameter_target_currency._parameter_value | remove: \"'\" %}"
# }

constant: label_get_target_currency {
  value: "{% assign currency = otc_common_parameters_xvw.parameter_target_currency._parameter_value | remove: \"'\" %}{{currency}}"
}

constant: label_derive_field_name {
  value: "{% assign fname = _field._name | split: '.' | last | remove: '_target_currency' | remove: '_formatted' %}
          {% assign field_name = '' %}
          {% assign fname_array = fname | split: '_' %}
          {% for word in fname_array %}
          {% assign cap = word | capitalize %}
          {% assign field_name = field_name | append: cap %}
          {% unless forloop.last %}{% assign field_name = field_name | append: ' ' %}{% endunless %}
          {% endfor %}
          "
}

constant: label_derive_field_name_minus_total {
  value: "{% assign fname = _field._name | split: '.' | last | remove: '_target_currency' | remove: '_formatted' | remove: 'total_' %}
          {% assign field_name = '' %}
          {% assign fname_array = fname | split: '_' %}
          {% for word in fname_array %}
          {% assign cap = word | capitalize %}
          {% assign field_name = field_name | append: cap %}
          {% unless forloop.last %}{% assign field_name = field_name | append: ' ' %}{% endunless %}
          {% endfor %}"
}

constant: label_build {
  value: "@{label_derive_field_name}{% if _field._is_selected %}{{field_name}} (@{label_get_target_currency}){%else%}{{field_name}} (Target Currency){%endif%}"
}

constant: label_build_formatted {
  value: "@{label_derive_field_name}{% if _field._is_selected %}{{field_name}} (@{label_get_target_currency}){%else%}{{field_name}} (Target Currency) Formatted {%endif%}"
}

constant: label_build_minus_total {
  value: "@{label_derive_field_name_minus_total}{% if _field._is_selected %}{{field_name}} (@{label_get_target_currency}){%else%}{{field_name}} (Target Currency){%endif%}"
}




constant: symbols_for_yes_no {
  value: "{% if value == true %}✅ {% else %}  {% endif %}"
}

constant: view_label_for_filters {
  value: "🔍 Filters"
}

constant: view_label_for_dashboard_navigation {
  value: "🛠 Dashboard Navigation"
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


constant: get_category_set_test {
  value: "{% assign d = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
          {% if d == 'test' %}{% assign category_set = 'Purchasing' %}{%elsif d == 'demo' %}
          {% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}
          {% else %} {% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}
          {% endif %}"
}

constant: get_category_set {
  value: "{% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}"
}

constant: category_set {
  value: "{% assign category_set = _user_attributes['cortex_oracle_ebs_category_set_name'] %}{{category_set}}"
}

constant: default_target_date {
  value:  "{% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
           {% if test_data == 'YES' %}
           {% assign td = '2024-03-28' %} {%else%}
           {% assign td = 'now' | date: '%Y-%m-%d' %}{%endif%}'{{td}}'"
  }

constant: sample_target_date {
  value:  "'2024-03-28'"
}

constant: default_target_date_test {
  value: "{% assign test_data = _user_attributes['cortex_oracle_ebs_use_test_data'] | upcase %}
          {% if test_data == 'YES' %}
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

constant: link_sales_invoices_daily_agg_source_to_target_dashboard_filters {
  value: "sales_invoices_daily_agg.invoice_date|date||sales_invoices_daily_agg.business_unit_name|business_unit||sales_invoices_daily_agg.bill_to_customer_country|customer_country||sales_invoices_daily_agg.bill_to_customer_name|customer_name||sales_invoices_daily_agg.order_source_name|order_source||sales_invoices_daily_agg.category_description|item_category||otc_common_parameters_xvw.parameter_target_currency|target_currency||otc_common_parameters_xvw.parameter_use_demo_or_test_data|test_or_demo"
}

constant: link_sales_invoices_to_target_dashboard {
  value: "invoice_date|date||business_unit_name|business_unit||bill_to_customer_country|customer_country||bill_to_customer_name|customer_name||order_source_name|order_source||category_description|item_category||parameter_target_currency|target_currency"
}

constant: link_sales_orders_to_details_dashboard {
  value: "ordered_date|date||business_unit_name|business_unit||parameter_customer_type|customer_type||selected_customer_country|customer_country||selected_customer_name|customer_name||order_source_name|order_source||category_description|item_category||parameter_target_currency|target_currency||parameter_language|item_language||open_closed_cancelled|order_status"
}

constant: link_invoices_to_orders_details_dashboard {
  value: "parameter_target_currency|target_currency||parameter_language|item_language||order_header_number|order_number"
}

constant: link_sales_orders_to_details_dashboard_extra_mapping {
  value: "{% assign extra_mapping = ''%}
         {% if sales_orders__lines.selected_product_dimension_description._in_query %}
          {% assign append_extra_mapping = true %}
          {% assign pl = sales_orders__lines.parameter_display_product_level._parameter_value %}
            {% if pl == 'Category' %}
               {% assign target_filter = 'item_category'%}
            {% elsif pl == 'Item' %} {% assign target_filter = 'item_description'%}
            {% endif%}
          {% assign extra_mapping = '||selected_product_dimension_description|' | append: target_filter %}
          {% else %}{% assign append_extra_mapping = false %}
         {% endif %}"
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
#CE642D\
constant: link_line_chart_1_date_1_measure {
  #Required
  #measure
  value: "{% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#468faf\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}"
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
  {% assign qualify_filter_name = true %}

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
  {% assign size = filters_array | size | minus: 1 | at_least: 0 %}
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
    {% if qualify_filter_names == false %} {% assign source_filter_key = source_filter_key | split:'.' | last %}{% endif %}
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
  {% if filter contains 'EMPTY' %}{%else%}
    {% if filter != blank %}
      {% assign filter_key = filter | split:'|' | first %}
      {% assign filter_value = filter | split:'|' | last %}
      {% if content == '/explore/' %}
        {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
      {% else %}
        {% assign filter_value = filter_value | encode_url %}
        {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
      {% endif %}
      {% assign filter_string = filter_string | append: filter_compile | append:'&' %}
    {% endif %}
  {% endif %}
  {% endfor %}
  {% assign size = filter_string | size | minus: 1 %}
  {% if size > 0 %}
    {% assign filter_string = filter_string | slice: 0, size %}
  {% else %}
    {% assign filter_string = '' %}
  {% endif %}
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
  {% assign size = default_filter_string | size | minus: 1 %}
  {% if size > 0 %}
  {% assign default_filter_string = default_filter_string | slice: 0, size %}
  {% endif %}
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


constant: link_generate_dashboard_variable {
  value: "
  {% assign content = '/dashboards/' %}
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



constant: link_build_explore {
  value: "
  {% assign explore_link = '' %}
  {% if link_host != '' %}
    {% assign explore_link = explore_link | append: host %}
  {% endif %}
  {% if content != '' %}
    {% assign explore_link = explore_link | append: content %}
  {% endif %}
  {% if target_model != '' %}
    {% assign explore_link = explore_link | append: target_model | append: '/' %}
  {% endif %}
  {% if target_explore != '' %}
    {% assign explore_link = explore_link | append: target_explore | append: '?'  %}
  {% endif %}
  {% if drill_fields != '' %}
    {% assign explore_link = explore_link | append: drill_fields %}
  {% endif %}
  {% if target_content_filters != '' %}
    {% assign explore_link = explore_link | append: target_content_filters %}
  {% endif %}
  {% if vis_config != '' %}
    {% assign explore_link = explore_link | append: vis_config %}
  {% endif %}
  {% if pivots != '' %}
    {% assign pivots = '&pivots=' |append: pivots %}
    {% assign explore_link = explore_link | append: pivots %}
  {% endif %}

  {% if subtotals != '' %}
    {% assign subtotals = '&subtotals=' |append: subtotals %}
    {% assign explore_link = explore_link | append: subtotals %}
  {% endif %}

  {% if sorts != '' %}
    {% assign sorts = '&sorts=' |append: sorts %}
    {% assign explore_link = explore_link | append: sorts %}
  {% endif %}

  {% if limit != '' %}
    {% assign limit = '&limit=' |append: limit %}
    {% assign explore_link = explore_link | append: limit %}
  {% endif %}

  {% if column_limit != '' %}
    {% assign column_limit = '&column_limit=' |append: column_limit %}
    {% assign explore_link = explore_link | append: column_limit %}
  {% endif %}

  {% if total != '' %}
    {% assign total = '&assign=' |append: total %}
    {% assign explore_link = explore_link | append: total %}
  {% endif %}

  {% if row_total != '' %}
    {% assign row_total = '&row_total=' |append: row_total %}
    {% assign explore_link = explore_link | append: row_total %}
  {% endif %}

  {% if query_timezone != '' %}
    {% assign query_timezone = '&query_timezone=' |append: query_timezone %}
    {% assign explore_link = explore_link | append: query_timezone %}
  {% endif %}

  {% if dynamic_fields != '' %}
    {% assign dynamic_fields = '&dynamic_fields=' |append: dynamic_fields %}
    {% assign explore_link = explore_link | append: dynamic_fields %}
  {% endif %}
  "
}

constant: link_generate_explore_url {
  value: "
  {% assign content = '/explore/' %}
  {% assign link_path =  link | split: '?' | first %}
  {% assign link_path =  link_path | split: '/'  %}
  {% assign link_query = link | split: '?' | last %}
  {% assign link_query_parameters = link_query | split: '&' %}
  {% assign drill_fields = drill_fields | prepend:'fields='%}

  {% if different_explore == false %}
    {% assign target_model = link_path[1] %}
    {% assign target_explore = link_path[2] %}
  {% endif %}

  {% if new_page %}
  @{link_host}
  {% endif %}

  @{link_extract_context}

  {% if different_explore %}
    @{link_match_filters_to_destination}
  {% else %}
    {% assign filters_array_destination = filters_array %}
  {% endif %}

  @{link_build_filter_string}

  {% if default_filters != '' %}
    @{link_build_default_filter_string}
  {% endif %}

  {% if default_filters_override == true and default_filters != '' %}
    {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string | prepend:'&' %}
  {% elsif default_filters_override == false and default_filters != '' %}
   {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string | prepend:'&' %}
  {% else %}
    {% assign target_content_filters = filter_string | prepend:'&' %}
  {% endif %}

  {% comment %} Builds final link to be presented in frontend {% endcomment %}
  @{link_build_explore}
  {{explore_link}}
  "
}

constant: link_build_mappings_from_dash_bindings {
  value: "{% assign model_name = _model._name %}
    {% if qualify_filter_names == true %}{% assign view_name = _view._name | append: '.' %}{%else%}{% assign view_name = '' %}{%endif%}
    {% assign nav_items = dash_bindings._value | split: '||' %}
    {% assign dash_map = map_filter_numbers_to_dashboard_filter_names._value | split: '||' %}
    {% assign filters_mapping = ''%}
      {% for nav_item in nav_items %}
        {% assign nav_parts = nav_item | split: '|' %}
         {% assign dash_label = nav_parts[1] %}

        {% assign target_dashboard = nav_parts[0] %}
        {% assign check_target_type = target_dashboard | plus: 0 %}

            {% if check_target_type == 0 %}
              {% if target_dashboard contains '::' %}{% else %}
                {% assign target_dashboard = model_name | append: '::' | append: target_dashboard %}
              {% endif %}
            {% endif %}

          {% assign dash_filter_set = nav_parts[2] | split: ',' %}
          {% for dash_filter in dash_filter_set %}
              {% for map_item in dash_map %}
                  {% assign map_item_key = map_item | split:'|' | first %}
                  {% if dash_filter == map_item_key %}
                    {% assign map_item_value = map_item | split:'|' | last %}
                    {% assign filter_name = view_name | append: 'filter' | append: dash_filter | append: '|' | append: map_item_value | append: '||' %}
                    {% assign filters_mapping = filters_mapping | append: filter_name  %}
                  {% endif %}
              {% endfor %}
          {% endfor %}"
}


constant: link_generate_dashboard_nav_style {
  value: "{% assign nav_style = parameter_navigation_style._parameter_value %}
  {% case nav_style %}
    {% when 'buttons' %}
      {% assign core_style = 'border-collapse: separate; border-radius: 6px; border: 2px solid #dcdcdc; margin-left: 5px; margin-bottom: 5px; padding: 6px 10px; line-height: 1.5; user-select: none; font-size: 12px; font-style: tahoma; text-align: center; text-decoration: none; letter-spacing: 0px; white-space: normal; float: left;' %}
      {% assign page_style = core_style | append: 'background-color: #ffffff; color: #000000; font-weight: normal;' %}
      {% assign focus_page_style = core_style | append: 'background-color: #dbe8fb; color: #000000; font-weight: medium;' %}
      {% assign div_style = 'text-align: center; display: inline-block; height: 40px;' %}
      {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 40px;' %}

    {% when 'tabs' %}
      {% assign core_style = 'font-color: #4285F4; padding: 5px 10px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px;'%}
      {% assign page_style = core_style | append: 'border-width: 1px; border-color: #D3D3D3;' %}
      {% assign focus_page_style = core_style | append: 'border-width: 3px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;' %}
      {% assign div_style = 'border-bottom: solid 2px #808080; padding: 4px 10px 0px 10px; height: 38px;' %}
      {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 38px;' %}

    {% when 'plain' %}
      {% assign page_style = 'color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;' %}
      {% assign focus_page_style = page_style | append: 'font-weight:bold;font-size: 12px;' %}
      {% assign div_style = 'float: left;' %}
      {% assign span_style = 'font-size: 10px; display: table; margin:0 auto;' %}
  {% endcase %}"
}

# test version
constant: link_derive_dashboard_nav_style {
  value: "{% assign nav_style = navigation_style._parameter_value %}
          {% case nav_style %}
              {% when 'buttons' %}
                  {% assign shared_style = 'display: block; border-spacing: 0; border-collapse: separate; border-radius: 6px; border: 1px solid #dcdcdc; margin-left: 0px; margin-bottom: 5px; padding: 6px 10px; line-height: 3; user-select: none; font-size: 14px; font-style: tahoma; text-align: center; text-decoration: none; letter-spacing: 1px; white-space: normal; float: left;' %}
                  {% assign non_focus_page_style = shared_style | append: 'background-color: #ffffff; color: #000000; font-weight: normal;' %}
                  {% assign focus_page_style = shared_style | append: 'background-color: #dbe8fb; color: #000000; font-weight: bold;' %}
                  {% assign div_style = 'text-align: center; display: inline-block; height: 40px;' %}
                  {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 40px;' %}

              {% when 'tabs' %}
                {% assign shared_style = 'font-color: #4285F4; padding: 0px 0px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px; letter-spacing: 0px'%}
                {% assign non_focus_page_style = shared_style | append: 'border-width: 1px; border-color: #D3D3D3;' %}
                {% assign focus_page_style = shared_style | append: 'border-width: 2px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;' %}
                {% assign div_style = 'vertical-align: bottom; border-bottom: solid 2px #808080; padding: 6px 10px 8px 12px; height: 39px;' %}
                {% assign span_style = 'font-size: 16px; padding: 6px 10px 0 10px; height: 39px;' %}


            {% when 'small' %}
              {% assign non_focus_page_style = 'color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;' %}
              {% assign focus_page_style = non_focus_page_style | append: 'font-weight:bold;font-size: 12px;' %}
              {% assign div_style = 'float: left;' %}
              {% assign span_style = 'font-size: 10px; display: table; margin:0 auto;' %}
            {% endcase %}"
}

constant: link_selected_button_style {
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
  user-select: none
  font-size: 12px;
  font-style: tahoma;
  text-align: center;
  text-decoration: none;
  letter-spacing: 0px;
  white-space: normal;
  float: left;
  background-color: #dbe8fb;
  color: #000000;
  font-weight: medium;"
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
  font-size: 12px;
  font-style: tahoma;
  text-align: center;
  text-decoration: none;
  letter-spacing: 0px;
  white-space: normal;
  float: left;
  background-color: #ffffff;
  color: #000000;
  font-weight: normal;"
}
