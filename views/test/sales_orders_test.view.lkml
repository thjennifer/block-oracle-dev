include: "/views/core/sales_orders_rfn.view"

view: +sales_orders {

  # sql_table_name: `@{GCP_PROJECT_ID}.{% parameter otc_common_parameters_xvw.parameter_use_demo_or_test_data %}.SalesOrders` ;;

  sql_table_name: {% assign p = otc_common_parameters_xvw.parameter_use_demo_or_test_data._parameter_value %}
  {% if p == "test" %}{%assign t = 'CORTEX_ORACLE_EBS_REPORTING_VISION' %}
  {% else %}{% assign t = 'CORTEX_ORACLE_EBS_REPORTING' %}{% endif %}`@{GCP_PROJECT_ID}.{{t}}.SalesOrders` ;;

#########################################################
# TEST STUFF
# TO BE REMOVED
#{

  # dimension: num_lines {
  #   hidden: no
  #   view_label: "TEST STUFF"
  # }


  # dimension: is_partial_fulfillment {
  #   hidden: no
  #   type: yesno
  #   view_label: "TEST STUFF"
  #   sql: ${num_lines_fulfilled_by_promise_date} > 1 AND ${num_lines} <> ${num_lines_fulfilled_by_promise_date} ;;
  # }

  dimension: num_lines_fulfilled_by_promise_date {
    hidden: no
    view_label: "TEST STUFF"
  }




  # dimension: ordered_amount_target_currency {
  #   hidden: yes
  #   type: number
  #   group_label: "Currency Conversion"
  #   sql: ${ordered_amount} * IF(${sales_orders.currency_code} = {% parameter otc_common_parameters_xvw.parameter_target_currency %}, 1, ${currency_conversion_sdt.conversion_rate})  ;;
  #   value_format_name: decimal_2
  # }

  measure: date_count {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${ordered_raw} ;;
  }

  measure: count_country {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql: ${ship_to_customer_country} ;;
  }

  parameter: sold_ship_bill {
    hidden: no
    type: unquoted
    view_label: "TEST STUFF"
    allowed_value: {label: "Bill To" value: "bi" }
    allowed_value: {label: "Sold To" value: "so" }
    allowed_value: {label: "Ship To" value: "sh" }
    default_value: "so"
  }

  dimension: customer_number_is_null {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign c = sold_ship_bill._parameter_value %}
         CASE WHEN --{{c}}
          {% if c == "bi"%}${bill_to_customer_number}
          {% elsif c == "so" %}${sold_to_customer_number}
          {% else %}${ship_to_customer_number}
          {% endif %} is null
          THEN 'yes' else 'no' end;;
  }


  dimension: customer_name_is_null {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign c = sold_ship_bill._parameter_value %}
         CASE WHEN --{{c}}
          {% if c == "bi"%}${bill_to_customer_name}
          {% elsif c == "so" %}${sold_to_customer_name}
          {% else %}${ship_to_customer_name}
          {% endif %} is null
          THEN 'yes' else 'no' end;;
  }

  dimension: customer_country_is_null {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    sql: {% assign c = sold_ship_bill._parameter_value %}
         CASE WHEN --{{c}}
          {% if c == "bi"%}${bill_to_customer_country}
          {% elsif c == "so" %}${sold_to_customer_country}
          {% else %}${ship_to_customer_country}
          {% endif %} is null
          THEN 'yes' else 'no' end;;
  }

  measure: distinct_customer_count {
    hidden: no
    view_label: "TEST STUFF"
    type: count_distinct
    sql:  {% assign c = sold_ship_bill._parameter_value %}
          {% if c == "bi"%}${bill_to_site_use_id}
          {% elsif c == "so" %}${sold_to_site_use_id}
          {% else %}${ship_to_site_use_id}
          {% endif %}
      ;;
  }

  dimension: is_pre_2021_order {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: EXTRACT(YEAR FROM ${ordered_raw}) < 2021;;
  }

  dimension: test_ordered_month {
    hidden: no
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDERED_MONTH ;;
  }

  dimension: test_ordered_quarter {
    hidden: no
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDERED_QUARTER ;;
  }

  dimension: test_ordered_year {
    hidden: no
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDERED_YEAR ;;
  }

  dimension: test_null_business_unit_name {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.BUSINESS_UNIT_NAME IS NULL ;;
  }

  dimension: test_null_fiscal_period_num {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.FISCAL_PERIOD_NUM IS NULL ;;
  }

  dimension: test_null_ledger_id {
    hidden: no
    view_label: "TEST STUFF"
    type: yesno
    sql: ${TABLE}.LEDGER_ID IS NULL ;;
  }

  measure: sum_total_ordered_amount_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${total_ordered_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  measure: sum_total_sales_amount_target_currency {
    hidden: no
    view_label: "TEST STUFF"
    type: sum
    sql: ${total_sales_amount_target_currency} ;;
    value_format_name: decimal_0
  }

  dimension: test_prod_level {
    hidden: no
    view_label: "TEST STUFF"
    type: string

    # sql: {% assign extra_mapping = ''%}
    #     {% if sales_orders__lines.parameter_display_product_level._in_query %}
    #       {% assign append_extra_mapping = true %}
    #       {% assign pl = sales_orders__lines.parameter_display_product_level._parameter_value %}
    #         {% if pl == 'Category' %}
    #           {% assign target_filter = 'item_category'%}
    #         {% elsif pl == 'Item' %} {% assign target_filter = 'item_description'%}
    #         {% endif%}
    #       {% assign extra_mapping = '||selected_product_dimension_description|' | append: target_filter %}
    #       {% else %}{% assign append_extra_mapping = false %}
    #     {% endif %}
    #     {% if append_extra_mapping == true %}'{{extra_mapping}}'
    #     {% else %} ''
    #     {% endif %}
    # ;;
    sql:  @{link_map_sales_orders_to_order_details_extra_mapping}
      {% assign filters_mapping = '@{link_map_sales_orders_to_order_details}'%}
      {% if append_extra_mapping == true %}
        {% assign filters_mapping = filters_mapping | append: extra_mapping %}
       {% endif %}'{{filters_mapping}}' ;;
  }


  measure: test_sales_count {
    hidden: no
    type: number
    view_label: "TEST STUFF"
    sql: ${sales_order_count} ;;
    drill_fields: [test_sales_count, ordered_month_num, ordered_year]
    # link: {
    #   label: "Show line"
    #   url: "{% assign measure = 'sales_orders.test_sales_count' %}
    #   {% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#66FF00\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}

    #   {{ link }}&vis_config={{ vis_config | encode_uri }}&sorts=sales_orders.ordered_year+asc,sales_orders.ordered_month_num+asc&toggle=dat,pik,vis&limit=500&column_limit=15"
    # }
    link: {
      label: "Show as stacked line"
      url: "
      {% assign vis_config = '{
      \"stacking\" : \"normal\",
      \"legend_position\" : \"right\",
      \"x_axis_gridlines\" : false,
      \"y_axis_gridlines\" : true,
      \"show_view_names\" : false,
      \"y_axis_combined\" : true,
      \"show_y_axis_labels\" : true,
      \"show_y_axis_ticks\" : true,
      \"y_axis_tick_density\" : \"default\",
      \"show_x_axis_label\" : true,
      \"show_x_axis_ticks\" : true,
      \"show_null_points\" : false,
      \"interpolation\" : \"monotone\",
      \"type\" : \"looker_line\",
      \"colors\": [
      \"#66FF00\",
      \"#ff8f95\",
      \"#1ea8df\",
      \"#353b49\",
      \"#49cec1\",
      \"#b3a0dd\"
      ],
      \"x_axis_label\" : \"Month Number\"
      }' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&sorts=sales_orders.ordered_year+asc,sales_orders.ordered_month_num+asc&pivots=sales_orders.ordered_year&toggle=dat,pik,vis&limit=500&column_limit=15"
    } # NOTE the &pivots=
  }

  # measure: test2_sales_count {
  #   hidden: no
  #   type: number
  #   view_label: "TEST STUFF"
  #   sql: ${sales_order_count} ;;
  #   drill_fields: [test2_sales_count, ordered_month]
  #   link: {
  #     label: "Show line"
  #     url: "{% assign measure = 'sales_orders.test2_sales_count' %}
  #     {% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#66FF00\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}

  #     {{ link }}&vis_config={{ vis_config | encode_uri }}&sorts=sales_orders.ordered_month+asc&toggle=dat,pik,vis&limit=500&column_limit=15"
  #   }
  # }

  measure: test3_sales_count {
    hidden: no
    type: number
    view_label: "TEST STUFF"
    sql: ${sales_order_count} ;;
    link: {
      label: "Show Sales Orders by Month (Common)"
      # url: "{{dummy_drill_monthly_orders._link}}"
      url: "@{link_action_set_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign v = _view._name | append: '.' %}
      {% assign measure = 'test3_sales_count' | prepend: v %}
      {% assign m = 'ordered_month' | prepend: v %}
      {% assign drill_fields =  m | append: ',' | append: measure %}
      @{link_vis_line_chart_1_date_1_measure}
      @{link_action_generate_explore_url}
      "
    }
  }



  dimension: test_explore_link_parts {
    type: string
    hidden: no
    view_label: "TEST STUFF"
    label: "Test Explore Link Parts"
    sql:  '' ;;
    html:

    <div>
              <!-- initialize variables used in following steps-->
                @{link_action_set_variable_defaults}

      <!-- capture the full url of the dashboard including filters -->
      {% assign link = link_generator._link %}.
      <br> {{link}}
      {% assign drill_fields = 'sales_orders.ordered_month,sales_orders.sales_order_count'%}
      {% assign measure = sales_orders.sales_order_count %}

      <!-- start target link_vis_line_chart_1_date_1_measure -->
      {% assign vis_config = '{\"point_style\":\"circle\",\"series_colors\":{\"' | append: measure | append: '\":\"#CE642D\"},\"type\":\"looker_line\"}' | url_encode | prepend: '&vis_config=' %}

      <br> vis_config: {{vis_config}}

      <!-- start generate_explore_url -->
      {% assign content = '/explore/' %}
      {% assign link_path =  link | split: '?' | first %}
      {% assign link_path =  link_path | split: '/'  %}
      {% assign link_query = link | split: '?' | last %}
      {% assign link_query_parameters = link_query | split: '&' %}
      {% assign drill_fields = drill_fields | prepend:'fields='%}

      <br> link_query: {{link_query}} <br>
      <br> drill_fields: {{drill_fields}} <br>

      {% if use_different_explore == false %}
      {% assign target_model = link_path[1] %}
      {% assign target_explore = link_path[2] %}
      {% endif %}
      <br> target_model: {{target_model}} <br>
      <br> target_explore: {{target_explore}} <br>

      <!-- start link_action_extract_context -->
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

      <br> filters_array: {{filters_array}} <br>

      {% if use_different_explore %}
      @{link_action_match_filters_to_destination}
      {% else %}
      {% assign filters_array_destination = filters_array %}
      {% endif %}

      <br> filters_array_destination: {{filters_array_destination}} <br>

      <!-- start build_filter_string -->
      {% assign filter_string = '' %}
      {% assign filters_array_destination = filters_array_destination | split: ',' %}
      {% for filter in filters_array_destination %}
      <br> filter: {{filter}} <br>

      {% if filter contains 'EMPTY' %}
      {% else %}
      {% if filter != blank %}

      {% assign filter_key = filter | split:'|' | first %}
      {% assign filter_value = filter | split:'|' | last %}
      <br> filter_key: {{filter_key}} <br>
      <br> filter_value: {{filter_value}} <br>

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

      <br> filters_string: {{filter_string}} <br>

      {% if default_filters != '' %}
      @{link_action_build_default_filter_string}
      {% endif %}

      {% if use_override_for_default_filters == true and default_filters != '' %}
      {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string | prepend:'&' %}
      {% elsif use_override_for_default_filters == false and default_filters != '' %}
      {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string | prepend:'&' %}
      {% else %}
      {% assign target_content_filters = filter_string | prepend:'&' %}
      {% endif %}

      {% comment %} Builds final link to be presented in frontend {% endcomment %}
      @{link_action_build_explore}

      <br> explore_link: {{explore_link}} <br>


      </div>

      ;;
  }

#} end test stuff
}