include: "/views/core/otc_dashboard_navigation_sales_ext.view"

view: +otc_dashboard_navigation_sales_ext {

  label: "TEST Dashboard Navigation"

  parameter: navigation_style {
    allowed_value: {label: "Buttons" value: "buttons"}
  }

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: 'otc2_order_status_test|Order Status|1,2,3,4,5,6,7,8||otc2_sales_performance_test|Sales Performance|1,2,3,4,5,6,7,8,9||otc2_order_fulfillment_test|Order Fulfillment|1,2,3,4,5,6,7,8,9' ;;
    # sql: 'otc_billing_test|Billing & Invoicing||otc_accounts_receivable_test|Accounts Receivable Overview||otc_billing_invoice_details_test|Invoice Details' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|date||filter2|business_unit||filter3|customer_type||filter4|customer_country||filter5|customer_name||filter6|target_currency||filter7|order_source||filter8|item_category||filter9|item_language||filter10|test_or_demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  dimension: map_filter_numbers_to_dashboard_filter_names {
    # for each filter that needs to be passed between dashboards assign a generic filter number 1 to N
    # this can be a broad list of filters that may or may not appear on dashboard
    # specific set of filters used in a dashboard will be specified in dash bindings
    hidden: yes
    type: string
    sql: '1|date||2|business_unit||3|customer_type||4|customer_country||5|customer_name||6|target_currency||7|order_source||8|item_category||9|item_language' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  filter: filter10 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "test_or_demo"
  }

  dimension: new_navigation_links {
    type: string
    hidden: no
    label: "Dashboard Navigation Links"
    description: "Add to Single Value Visualization. Defined HTML styling will be shown."
    # required_fields: [item_delimiter,value_delimiter]
    sql:  '' ;;
    html:
     @{link_derive_dashboard_nav_style}
    <div style="{{ div_style }}">
    <span style = "{{ span_style }}">
    <!-- initialize variables -->
    @{link_generate_variable_defaults}

      {% assign link = link_generator._link %}
      {% assign counter = 1 %}



      @{link_build_mappings_from_dash_bindings}



      @{link_generate_dashboard_variable}

      {% assign focus_page = navigation_focus_page._parameter_value | times: 1 %}

      {% if navigation_focus_page._in_query and counter == focus_page %}
        <span style="{{ focus_page_style }}">{{ dash_label }}</span>
        {% elsif _explore._dashboard_url == dashboard_url %}
        <span style="{{ focus_page_style }}">{{ dash_label }}</span>
        {% else %}
        <a style="{{ non_focus_page_style }}" href="{{ dashboard_url }}">{{ dash_label }}</a>
      {% endif %}
      <!-- increment counter by 1 -->
      {% assign counter = counter | plus: 1 %}
      {% endfor %}
      </span>
      </div>;;

  }




# <a href="{{dashboard_url}}"
#       {% if focus_page == counter %}
#       style="@{link_selected_button_style}">{{dash_label}}</a>
#       {% else %}
#       style="@{link_unselected_button_style}">{{dash_label}}</a>
#       {%endif%}


  dimension: new_navigation_links_this_works {
    type: string
    hidden: no
    label: "Dashboard Navigation Links"
    description: "Add to Single Value Visualization. Defined HTML styling will be shown."
    # required_fields: [item_delimiter,value_delimiter]
    sql:  '' ;;
    html:
    <div>
    <!-- initialize variables -->
    @{link_generate_variable_defaults}

    {% assign link = link_generator._link %}
    {% assign counter = 1 %}

    {% assign nav_style = navigation_style._parameter_value %}

    {% assign model_name = _model._name %}
    {% assign view_name = _view._name %}
    {% assign nav_items = dash_bindings._value | split: '||' %}
    {% assign dash_map = map_filter_numbers_to_dashboard_filter_names._value | split: '||' %}
      {% for nav_item in nav_items %}
        {% assign nav_parts = nav_item | split: '|' %}
         {% assign dash_label = nav_parts[1] %}
  <!-- derive target_dashboard ID -->
        {% assign target_dashboard = nav_parts[0] %}
        <!-- check if target_dashboard is numeric for UDD ids or string for LookML dashboards -->
        {% assign check_target_type = target_dashboard | plus: 0 %}
        <!-- if LookML Dashboard then append model name if not provided -->
        <!-- if check_target_type equals 0 then string else numeric-->
            {% if check_target_type == 0 %}
            <!-- if target_dashboard contains '::' then model_name is already provided-->
              {% if target_dashboard contains '::' %}{% else %}
                {% assign target_dashboard = model_name | append: '::' | append: target_dashboard %}
              {% endif %}
            {% endif %}


      <!-- derive target filters_mapping -->
          {% assign dash_filter_set = nav_parts[2] | split: ',' %}
          {% for dash_filter in dash_filter_set %}
              {% for map_item in dash_map %}
                  {% assign map_item_key = map_item | split:'|' | first %}
                  {% if dash_filter == map_item_key %}
                    {% assign map_item_value = map_item | split:'|' | last %}
                    {% assign filter_full_name = view_name | append: '.filter' | append: dash_filter | append: '|' | append: map_item_value %}
                    {% assign filters_mapping = filters_mapping | append: filter_full_name | append: '||' %}
                  {% endif %}

      {% endfor %}
      {% endfor %}



      @{link_generate_dashboard_variable}

      {% assign focus_page = navigation_focus_page._parameter_value | times: 1 %}

      <a href="{{dashboard_url}}"
        {% if focus_page == counter %}
          style="@{link_selected_button_style}">{{dash_label}}</a>
        {% else %}
        style="@{link_unselected_button_style}">{{dash_label}}</a>
        {%endif%}

       <!-- increment counter by 1 -->
      {% assign counter = counter | plus: 1 %}
      {% endfor %}
      </div>;;

  }

  # <a href="{{dashboard_url}}"
  #       {% if focus_page == counter %}
  #         style="@{link_selected_button_style}">{{dash_label}}</a>
  #       {% else %}
  #       style="@{link_unselected_button_style}">{{dash_label}}</a>
  #       {%endif%}

  dimension: new_navigation_links_step_by_step {
    type: string
    hidden: no
    label: "Dashboard Navigation Links"
    description: "Add to Single Value Visualization. Defined HTML styling will be shown."
    # required_fields: [item_delimiter,value_delimiter]
    sql:  '' ;;
    html:
    <div>
    <!-- initialize variables -->
    @{link_generate_variable_defaults}

    {% assign link = link_generator._link %}
    {% assign counter = 1 %}
    {% assign nav_style = navigation_style._parameter_value %}
    {% assign focus_page = navigation_focus_page._parameter_value | times: 1 %}
    {% assign model_name = _model._name %}
    {% assign view_name = _view._name %}
    {% assign nav_items = dash_bindings._value | split: '||' %}
    {% assign dash_map = map_filter_numbers_to_dashboard_filter_names._value | split: '||' %}
      {% for nav_item in nav_items %}
        {% assign nav_parts = nav_item | split: '|' %}
         {% assign dash_label = nav_parts[1] %}
  <!-- derive target_dashboard ID -->
        {% assign target_dashboard = nav_parts[0] %}
        <!-- check if target_dashboard is numeric for UDD ids or string for LookML dashboards -->
        {% assign check_target_type = target_dashboard | plus: 0 %}
        <!-- if LookML Dashboard then append model name if not provided -->
        <!-- if check_target_type equals 0 then string else numeric-->
            {% if check_target_type == 0 %}
            <!-- if target_dashboard contains '::' then model_name is already provided-->
              {% if target_dashboard contains '::' %}{% else %}
                {% assign target_dashboard = model_name | append: '::' | append: target_dashboard %}
              {% endif %}
            {% endif %}


      <!-- derive target_filter_mapping -->
          {% assign dash_filter_set = nav_parts[2] | split: ',' %}
          {% for dash_filter in dash_filter_set %}
              {% for map_item in dash_map %}
                  {% assign map_item_key = map_item | split:'|' | first %}
                  {% if dash_filter == map_item_key %}
                    {% assign map_item_value = map_item | split:'|' | last %}
                    {% assign filter_full_name = view_name | append: '.filter' | append: dash_filter | append: '|' | append: map_item_value %}
                    {% assign filters_mapping = filters_mapping | append: filter_full_name | append: '||' %}
                  {% endif %}

              {% endfor %}
          {% endfor %}

           <!-- start link_generate_dashboard_variable code -->
      {% assign content = '/dashboards-next/' %}
      {% assign link_query = link | split: '?' | last %}
      {% assign link_query_parameters = link_query | split: '&' %}
      {% assign target_content_filters = '' %}
      {% assign host = '' %}

      {% if new_page %}
      @{link_host}
      {% endif %}

            <!-- start of link_extract_context code -->
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

      <!-- end link_extract_context code -->

      <!-- start link_match_filters_to_destination -->

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
      <br><br><b>{{dash_label}}: filters_array_destination: </b>
      {{filters_array_destination}}
      <!-- end link_match_filters_to_destination -->
      <!-- begin link_build_filter_string -->
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
      <br><br><b>{{dash_label}}: filter_string: </b>
      {{filter_string}}
      <!-- end link_build_filter_string -->
      {% if default_filters != '' %}
      <!-- begin link_build_default_filter_string -->
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
      <br><br><b>default_filter_string: </b>
      {{default_filter_string}}
      <!-- end link_build_default_filter_string -->

      {% endif %}

      {% if default_filters_override == true and default_filters != '' %}
      {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
      {% elsif default_filters_override == false and default_filters != '' %}
      {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
      {% else %}
      {% assign target_content_filters = filter_string %}
      {% endif %}

      {% comment %} Builds final link to be presented in frontend {% endcomment %}
      <br><br><b>{{dash_label}} final link: </b>
      {{ link_host | append:content | append:target_dashboard | append: '?' | append: target_content_filters }}

       {% endfor %}
      </div>;;

  }

#   dimension: new_navigation_links_not_working_yet {
#     type: string
#     hidden: no
#     label: "Dashboard Navigation Links"
#     description: "Add to Single Value Visualization. Defined HTML styling will be shown."
#     # required_fields: [item_delimiter,value_delimiter]
#     sql:  '' ;;
#     html:
#     <div>
#     <!-- initialize variables -->
#     @{link_generate_variable_defaults}

#     {% assign link = link_generator._link %}
#     {% assign counter = 1 %}
#     {% assign nav_style = navigation_style._parameter_value %}
#     {% assign focus_page = navigation_focus_page._parameter_value | times: 1 %}
#     {% assign model_name = _model._name %}
#     {% assign view_name = _view._name %}
#     {% assign nav_items = dash_bindings._value | split: '||' %}
#     {% assign dash_map = map_filter_numbers_to_dashboard_filter_names._value | split: '||' %}

#     {% for nav_item in nav_items %}
#         {% assign nav_parts = nav_item | split: '|' %}

#         {% assign dash_label = nav_parts[1] %}

#     <!-- derive target_dashboard ID -->
#         {% assign target_dashboard = nav_parts[0] %}
#         <!-- check if target_dashboard is numeric for UDD ids or string for LookML dashboards -->
#         {% assign check_target_type = target_dashboard | plus: 0 %}
#         <!-- if LookML Dashboard then append model name if not provided -->
#         <!-- if check_target_type equals 0 then string else numeric-->
#             {% if check_target_type == 0 %}
#             <!-- if target_dashboard contains '::' then model_name is already provided-->
#               {% if target_dashboard contains '::' %}{% else %}
#                 {% assign target_dashboard = model_name | append: '::' | append: target_dashboard %}
#               {% endif %}
#             {% endif %}

#             {{target_dashboard}} <br>
#       <!-- derive target_filter_mapping -->
#           {% assign dash_filter_set = nav_parts[2] | split: ',' %}
#           {% for dash_filter in dash_filter_set %}
#               {% for map_item in dash_map %}
#                   {% assign map_item_key = map_item | split:'|' | first %}
#                   {% if dash_filter == map_item_key %}
#                     {% assign map_item_value = map_item | split:'|' | last %}
#                     {% assign filter_full_name = view_name | append: '.filter' | append: dash_filter | append: '|' | append: map_item_value %}
#                     {% assign filters_mapping = filters_mapping | append: filter_full_name | append: '||' %}
#                   {% endif %}

#               {% endfor %}
#           {% endfor %}

#     <!-- start link_generate_dashboard_variable code -->
#       {% assign content = '/dashboards-next/' %}
#       {% assign link_query = link | split: '?' | last %}
#       {% assign link_query_parameters = link_query | split: '&' %}
#       {% assign target_content_filters = '' %}
#       {% assign host = '' %}

#       {% if new_page %}
#       @{link_host}
#       {% endif %}

#       <!-- start of link_extract_context code -->
#       {% assign filters_array = '' %}
#       {% for parameter in link_query_parameters %}
#       {% assign parameter_key = parameter | split:'=' | first %}
#       {% assign parameter_value = parameter | split:'=' | last %}
#       {% assign parameter_test = parameter_key | slice: 0,2 %}
#       {% if parameter_test == 'f[' %}
#       {% comment %} Link contains multiple parameters, need to test if filter {% endcomment %}
#       {% if parameter_key != parameter_value %}
#       {% comment %} Tests if the filter value is is filled in, if not it skips  {% endcomment %}
#       {% assign parameter_key_size = parameter_key | size %}
#       {% assign slice_start = 2 %}
#       {% assign slice_end = parameter_key_size | minus: slice_start | minus: 1 %}
#       {% assign parameter_key = parameter_key | slice: slice_start, slice_end %}
#       {% assign parameter_clean = parameter_key | append:'|' |append: parameter_value %}
#       {% assign filters_array =  filters_array | append: parameter_clean | append: ',' %}
#       {% endif %}
#       {% elsif parameter_key == 'dynamic_fields' %}
#       {% assign dynamic_fields = parameter_value %}
#       {% elsif parameter_key == 'query_timezone' %}
#       {% assign query_timezone = parameter_value %}
#       {% endif %}
#       {% endfor %}
#       {% assign size = filters_array | size | minus: 1 %}
#       {% assign filters_array = filters_array | slice: 0, size %}
#       <br><br><b>{{dash_name}} source_filters_array: </b>
#       {{filters_array}}
#       <!-- end link_extract_context code -->

#     {% endfor %}
#     </div>;;

# }

# @{link_generate_dashboard_variable}
#           <a href="{{dashboard_url}}"
#           style="@{link_selected_button_style}">{{dash_name}}</a>
# {% for nav_item in nav_items %}
#       {% assign nav_parts = nav_item | split: '|' %}
#       {% assign dash_name = nav_parts[1] %}





#       <!-- build filter mapping based on dash filters and map of filters -->


#       <br>{{model_name}}
#     {% endfor %}
  # {% assign target_dashboard = nav_parts[0] %}
#       {% assign check_target_type = target_dashboard | plus: 0 %}
#       <!-- check if target_dashboard is numeric for UDD ids or string for LookML dashboards -->
#       <!-- if LookML Dashboard then append model name if not provided -->
#       <!-- if check_target_type equals 0 then string else numeric-->
#           {% if check_target_type == 0 %}
#           <!-- if target_dashboard contains '::' then model_name is already provided-->
#               {% if target_dashboard contains '::' %}
#                   {% else %}
#                   {% assign target_dashboard = modelName | append: '::' | append: target_dashboard %}
#               {% endif %}
#           {% endif %}

  #   {% for dash_filter in dash_filter_set %}
  #         {% for map_item in dash_map %}
  #           {% assign map_item_key = map_item | split:'|' | first %}
  #           {% if dash_filter == map_item_key %}

  #           {% assign filter_}
  #           {% assign map_item_value = map_item | split:'|' | last %}

  #   {% for destination_filter in filters_mapping %}
  #     {% comment %} This will loop through the value pairs to determine if there is a match to the destination {% endcomment %}
  #       {% assign destination_filter_key = destination_filter | split:'|' | first %}
  #       {% assign destination_filter_value = destination_filter | split:'|' | last %}
  #       {% if source_filter_key == destination_filter_key %}
  #         {% assign parameter_clean = destination_filter_value | append:'|' | append: source_filter_value %}
  #         {% assign filters_array_destination =  filters_array_destination | append: parameter_clean | append:',' %}
  #       {% endif %}
  #   {% endfor %}
  # {% endfor %}

# <!-- initialize variables -->
#     {% assign counter = 1 %}
#     {% assign navStyle = navigation_style._parameter_value %}
#     {% assign focus = navigation_focus_page._parameter_value | times: 1 %}
#     {% assign queryString = "" %}
#     {% assign modelName = _model._name %}

#     <!-- initial splits -->
#     {% assign navItems = dash_bindings._value | split: '||' %}
#     {% for navItem in navItems %}
#       {% assign navParts = navItem | split: value_delimiter._value %}
#       {% assign dashName = navParts[1] %}
#       {% assign dashFilters = navParts[2] %}

#       {% assign target_dashboard = navParts[0] %}
#       {% assign dashIDcheckType = target_dashboard | plus: 0 %}

#     <!-- check if id is numeric for UDD ids or string for LookML dashboards -->
#     <!-- if LookML Dashboard then append model name if not provided -->

#           <!-- if dashIDcheckType equals 0 then string else numeric-->
#           {% if dashIDcheckType == 0 %}
#           <!-- if dashID contains '::' then model_name is already provided-->
#               {% if target_dashboard contains '::' %}
#                   {% else %}
#                   {% assign target_dashboard = modelName | append: '::' | append: dashID %}
#               {% endif %}
#           {% endif %}

#     {{target_dashboard}}
#     <!-- increment counter by 1 -->
#     {% assign counter = counter | plus: 1 %}
#     {% endfor %}

#     {{target_dashboard}}
  # otc_dashboard_navigation_sales_ext.filter1|date||otc_dashboard_navigation_sales_ext.filter2|business_unit||otc_dashboard_navigation_sales_ext.filter3|customer_type||otc_dashboard_navigation_sales_ext.filter4|customer_country||otc_dashboard_navigation_sales_ext.filter5|customer_name||otc_dashboard_navigation_sales_ext.filter6|target_currency||otc_dashboard_navigation_sales_ext.filter7|order_source||otc_dashboard_navigation_sales_ext.filter8|item_category||otc_dashboard_navigation_sales_ext.filter10|test_or_demo


  dimension: test_navigation_html_link {
    required_fields: [item_delimiter,value_delimiter]
    sql:  'Test' ;;


    html: <div style="text-align: center; display: inline-block;">
          @{link_generate_variable_defaults}
          {% assign link = link_generator._link %}
          {% assign filters_mapping = 'otc_dashboard_navigation_sales_ext.filter1|date||otc_dashboard_navigation_sales_ext.filter2|business_unit||otc_dashboard_navigation_sales_ext.filter3|customer_type||otc_dashboard_navigation_sales_ext.filter4|customer_country||otc_dashboard_navigation_sales_ext.filter5|customer_name||otc_dashboard_navigation_sales_ext.filter6|target_currency||otc_dashboard_navigation_sales_ext.filter7|order_source||otc_dashboard_navigation_sales_ext.filter8|item_category' %}
          {% assign target_dashboard = _model._name | append: '::otc2_order_status_test' %}
          @{link_generate_dashboard_variable}
          <a href="{{dashboard_url}}"
          style="@{link_unselected_button_style}">Order Status</a>
          @{link_generate_variable_defaults}
          {% assign link = link_generator._link %}
          {% assign filters_mapping = 'otc_dashboard_navigation_sales_ext.filter1|date||otc_dashboard_navigation_sales_ext.filter2|business_unit||otc_dashboard_navigation_sales_ext.filter3|customer_type||otc_dashboard_navigation_sales_ext.filter4|customer_country||otc_dashboard_navigation_sales_ext.filter5|customer_name||otc_dashboard_navigation_sales_ext.filter6|target_currency||otc_dashboard_navigation_sales_ext.filter7|order_source||otc_dashboard_navigation_sales_ext.filter8|item_category||otc_dashboard_navigation_sales_ext.filter9|item_language' %}
          {% assign target_dashboard = _model._name | append: '::otc2_sales_performance_test' %}
          @{link_generate_dashboard_variable}
          <a href="{{dashboard_url}}"
          style="@{link_unselected_button_style}">Order Sales Performance</a>
          @{link_generate_variable_defaults}
          {% assign link = link_generator._link %}
          {% assign filters_mapping = 'otc_dashboard_navigation_sales_ext.filter1|date||otc_dashboard_navigation_sales_ext.filter2|business_unit||otc_dashboard_navigation_sales_ext.filter3|customer_type||otc_dashboard_navigation_sales_ext.filter4|customer_country||otc_dashboard_navigation_sales_ext.filter5|customer_name||otc_dashboard_navigation_sales_ext.filter6|target_currency||otc_dashboard_navigation_sales_ext.filter7|order_source||otc_dashboard_navigation_sales_ext.filter8|item_category||otc_dashboard_navigation_sales_ext.filter9|item_language' %}
          {% assign target_dashboard = _model._name | append: '::otc2_order_fulfillment_test' %}
          @{link_generate_dashboard_variable}
          <a href="{{dashboard_url}}"
          style="@{link_selected_button_style}">Order Fulfillment</a>
          </div>;;

    # html: <div>
    #       @{link_generate_variable_defaults}
    #       {% assign link = link_generator._link %}
    #       {{link}}
    #       </div>;;
    # html: @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign filters_mapping = 'sales_orders_daily_agg.ordered_date|date||sales_orders_daily_agg.business_unit_name|business_unit'  %}

    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::otc2_order_fulfillment_test' %}
    #   {% assign default_filters_override = false %}
    #   @{link_generate_dashboard_url};;

    # html: @{link_generate_variable_defaults}
    # {% assign link = link_generator._link %}
    # {% assign filters_mapping = 'sales_orders_daily_agg.invoice_date|date||sales_orders_daily_agg.business_unit_name|business_unit' %}
    # {% assign different_explore = true %}
    # {% assign target_model = _model._name %}
    # {% assign target_explore = 'sales_orders_daily_agg' %}
    # @{link_generate_explore_link} --if you drop the auto-printing from the function
    # <a href="{{explore_link}}">Sample</a>;;
  }

  dimension: test_navigation_link_parts {
    type: string
    sql: 'something' ;;
    # filter1|date||filter2|business_unit||filter3|customer_type||filter4|customer_country||filter5|customer_name||filter6|target_currency||filter7|order_source||filter8|item_category||filter9|item_language
    html:  <div>
            @{link_generate_variable_defaults}

      {% assign link = link_generator._link %}
      {% assign filters_mapping = 'otc_dashboard_navigation_sales_ext.filter1|date||otc_dashboard_navigation_sales_ext.filter2|business_unit||otc_dashboard_navigation_sales_ext.filter3|customer_type||otc_dashboard_navigation_sales_ext.filter4|customer_country||otc_dashboard_navigation_sales_ext.filter5|customer_name||otc_dashboard_navigation_sales_ext.filter6|target_currency||otc_dashboard_navigation_sales_ext.filter7|order_source||otc_dashboard_navigation_sales_ext.filter8|item_category||otc_dashboard_navigation_sales_ext.filter10|test_or_demo' %}
      {% assign target_dashboard = _model._name | append: '::otc2_order_status_test' %}

      <b>Target Dashboard: </b>{{target_dashboard}}

      <!-- start link_generate_dashboard_variable code -->
      {% assign content = '/dashboards-next/' %}
      {% assign link_query = link | split: '?' | last %}
      {% assign link_query_parameters = link_query | split: '&' %}
      {% assign target_content_filters = '' %}
      {% assign host = '' %}

      {% if new_page %}
      @{link_host}
      {% endif %}

      <!-- start of link_extract_context code -->
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
      <br><br><b>source_filters_array: </b>
      {{filters_array}}
      <!-- end link_extract_context code -->

      <!-- start link_match_filters_to_destination -->

      {% assign filters_mapping = filters_mapping | split: '||' %}
      {% assign filters_array = filters_array | split: ',' %}
      {% assign filters_array_destination = '' %}

      {% for source_filter in filters_array %}
      {% assign source_filter_key = source_filter | split:'|' | first %}
      {% assign source_filter_value = source_filter | split:'|' | last %}
              <br><b>source_filter_key: </b>{{source_filter_key}}
      {% for destination_filter in filters_mapping %}
      {% comment %} This will loop through the value pairs to determine if there is a match to the destination {% endcomment %}
      {% assign destination_filter_key = destination_filter | split:'|' | first %}
      {% assign destination_filter_value = destination_filter | split:'|' | last %}
              <!-- <br><b>destination_filter_key: </b>
      {% if source_filter_key == destination_filter_key %}
      {% assign parameter_clean = destination_filter_value | append:'|' | append: source_filter_value %}
      {% assign filters_array_destination =  filters_array_destination | append: parameter_clean | append:',' %}
      {% endif %}
      {% endfor %}
      {% endfor %}
      {% assign size = filters_array_destination | size | minus: 1 | at_least: 0 %}
      {% assign filters_array_destination = filters_array_destination | slice: 0, size %}
      <br><br><b>filters_array_destination: </b>
      {{filters_array_destination}}
      <!-- end link_match_filters_to_destination -->

      <!-- begin link_build_filter_string -->
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
      <br><br><b>filter_string: </b>
      {{filter_string}}
      <!-- end link_build_filter_string -->

      {% if default_filters != '' %}
      <!-- begin link_build_default_filter_string -->
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
      <br><br><b>default_filter_string: </b>
      {{default_filter_string}}
      <!-- end link_build_default_filter_string -->

      {% endif %}

      {% if default_filters_override == true and default_filters != '' %}
      {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
      {% elsif default_filters_override == false and default_filters != '' %}
      {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
      {% else %}
      {% assign target_content_filters = filter_string %}
      {% endif %}

      {% comment %} Builds final link to be presented in frontend {% endcomment %}
      <br><br><b>final link: </b>
      {{ link_host | append:content | append:target_dashboard | append: '?' | append: target_content_filters }}

      <!-- end link_generate_dashboard_variable code -->

      </div>;;
  }
# link_extract_context code {{jt_check_filters_string}} or {{filters_array}}
# link_match_filters_to_destination {{filters_array_destination}}



  measure: link_generator {
    hidden: yes
    type: number
    sql: 1 ;;
    drill_fields: [link_generator]
  }

  dimension: navigation {
    type: string
    hidden: no
    label: "Dashboard Navigation Links"
    description: "Add to Single Value Visualization. Defined HTML styling will be shown."
    required_fields: [item_delimiter,value_delimiter]
    sql:  '' ;;
    html:
    <!-- initial splits -->
      {% assign navItems = dash_bindings._value | split: item_delimiter._value %}
      {% assign filterItems = filter_bindings._value | split: item_delimiter._value %}

      <!-- initialize variables -->
      {% assign counter = 1 %}
      {% assign navStyle = navigation_style._parameter_value %}
      {% assign focus = navigation_focus_page._parameter_value | times: 1 %}
      {% assign queryString = "" %}
      {% assign modelName = _model._name %}

      <!--Define Styles-->
      <!-- establish link, div and span styles based on navigation_style parameter -->
      {% case navStyle %}
      {% when "buttons" %}
      {% assign sharedStyle = "display: block; border-spacing: 0; border-collapse: separate; border-radius: 6px; border: 1px solid #dcdcdc; margin-left: 0px; margin-bottom: 5px; padding: 6px 10px; line-height: 1.5; line-height: 1.5; user-select: none; font-size: 12px; font-style: tahoma; text-align: center; text-decoration: none; letter-spacing: 0px; white-space: normal; float: left;" %}
      {% assign linkStyle = sharedStyle | append: "background-color: #ffffff; color: #000000; font-weight: normal;" %}
      {% assign currentPageLinkStyle = sharedStyle | append: "background-color: #dbe8fb; color: #000000; font-weight: medium;" %}
      {% assign divStyle = "text-align: center; display: inline-block;" %}
      {% assign spanStyle = "" %}
      {% assign imgStyle = "" %}
      {% assign imgSrc = "" %}
      {% when "bar" %}
      {% assign linkStyle = "color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;" %}
      {% assign currentPageLinkStyle = linkStyle | append: "font-weight:bold;font-size: 20px;" %}
      {% assign divStyle = "border-radius: 5px; padding-top: 6px; padding-bottom: 20px; height: 60px; background: #F5F5F5;" %}
      {% assign spanStyle = "font-size: 18px; display: table; margin:0 auto;" %}
      {% assign imgStyle = "float: left; vertical-align: middle; height: 45px;" %}
      {% assign imgSrc = "@{image_dashboard_navigation}" %}
      {% when "tabs" %}
      {% assign sharedStyle = "font-color: #4285F4; padding: 5px 15px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px; "%}
      {% assign linkStyle = sharedStyle | append: "border-width: 1px; border-color: #D3D3D3;" %}
      {% assign currentPageLinkStyle = sharedStyle | append: "border-width: 2px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;" %}
      {% assign divStyle = "border-bottom: solid 2px #808080; padding: 6px 10px 5px 10px; height: 40px;" %}
      {% assign spanStyle = "font-size: 16px; padding: 6px 10px 0 10px; height: 40px;" %}
      {% assign imgStyle = "float: left; vertical-align: middle; height: 39px;" %}
      {% assign imgSrc = "@{image_dashboard_navigation}" %}
      {% when "small" %}
      {% assign linkStyle = "color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;" %}
      {% assign currentPageLinkStyle = linkStyle | append: "font-weight:bold;font-size: 12px;" %}
      {% assign divStyle = "float: left;" %}
      {% assign spanStyle = "font-size: 10px; display: table; margin:0 auto;" %}
      {% assign imgStyle = "" %}
      {% assign imgSrc = "" %}
      {% endcase %}


      <!-- loop through filterItems defined in filterBindings dimension to create queryString used in dashboard url-->
      {% for filterItem in filterItems %}
      <!-- split filter into parts -->
      {% assign filterParts = filterItem | split: value_delimiter._value %}
      {% assign filterField = filterParts[0] %} <!-- for readability -->
      {% assign filterName = filterParts[1] %} <!-- for readability -->

      <!-- Define Filters -->
      <!-- case on filter, because we can't mix value interpolation into logic evaluation -->
      <!-- for example, this will not work: {% assign filterValue = _filters['{{ filter }}'] %} -->
      <!-- Add more cases for more filters ** -->
      {% case filterField %}
      {% when "filter1" %}
      {% assign filterValue = _filters['filter1'] | url_encode %}
      {% when "filter2" %}
      {% assign filterValue = _filters['filter2'] | url_encode %}
      {% when "filter3" %}
      {% assign filterValue = _filters['filter3'] | url_encode %}
      {% when "filter4" %}
      {% assign filterValue = _filters['filter4'] | url_encode %}
      {% when "filter5" %}
      {% assign filterValue = _filters['filter5'] | url_encode %}
      {% when "filter6" %}
      {% assign filterValue = _filters['filter6'] | url_encode %}
      {% when "filter7" %}
      {% assign filterValue = _filters['filter7'] | url_encode %}
      {% when "filter8" %}
      {% assign filterValue = _filters['filter8'] | url_encode %}
      {% when "filter9" %}
      {% assign filterValue = _filters['filter9'] | url_encode %}
      {% when "filter10" %}
      {% assign filterValue = _filters['filter10'] | url_encode %}
      {% else %}
      {% assign filterValue = "out of range filter" %}
      <!-- if you see this value, you've added more filters than supported in filterBindings -->
      {% endcase %}

      <!-- create individual filterString -->
      {% assign filterString = filterName | append: "=" | append: filterValue %}

      <!-- tack individual filterString onto end of queryString -->
      {% assign queryString = queryString | append: filterString | append: '&' %}

      {% endfor %}


      <!-- begin HTML -edit styles as needed -->
      <center>
      <div style="{{ divStyle }}">
      <span style="{{ spanStyle }}">
      <img style="{{ imgStyle }}" src="{{ imgSrc }}"/>

      <!-- Loop through navigation items as defined in dashBindings dimension-->
      {% for navItem in navItems %}
      {% assign navParts = navItem | split: value_delimiter._value %}
      {% assign dashName = navParts[1] %}
      {% assign dashID = navParts[0] %}
      {% assign dashIDcheckType = dashID | plus: 0 %}

      <!-- check if id is numeric for UDD ids or string for LookML dashboards -->
      <!-- if LookML Dashboard then append model name if not provided -->

      <!-- if dashIDcheckType equals 0 then string else numeric-->
      {% if dashIDcheckType == 0 %}
      <!-- if dashID contains '::' then model_name is already provided-->
      {% if dashID contains '::' %}
      {% else %}
      {% assign dashID = modelName | append: '::' | append: dashID %}
      {% endif %}
      {% endif %}


      {% assign dashUrl = "/dashboards/" | append: dashID %}


      <!-- build links -->
      {% if navigation_focus_page._in_query and counter == focus %}
      <span style="{{ currentPageLinkStyle }}">{{ dashName }}</span>
      {% elsif _explore._dashboard_url == dashUrl %}
      <span style="{{ currentPageLinkStyle }}">{{ dashName }}</span>
      {% else %}
      <a style="{{ linkStyle }}" href="{{ dashUrl }}?{{ queryString }}">{{ dashName }}</a>
      {% endif %}

      <!-- increment counter by 1 -->
      {% assign counter = counter | plus: 1 %}
      {% endfor %}

      </span>
      </div>

      <!-- NOTE: There's a bug in _explore._dashboard_url liquid implementation -->
      <!-- until fixed use paramter navigation_focus_page or advise users to clear cache & refresh-->
      {% if navigation_focus_page._in_query == false %}
      <div>
      <span style="font-size: 10px;">{{ _explore._dashboard_url }} - clear cache & refresh to see active page</span>
      </div>
      {% endif %}
      </center>

      ;;
  }

}
