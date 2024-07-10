include: "/views/core/otc_dashboard_navigation_sales_ext.view"

view: +otc_dashboard_navigation_sales_ext {

  label: "TEST Dashboard Navigation"

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: 'otc2_order_status_test|Order Status||otc2_sales_performance_test|Sales Performance||otc2_order_fulfillment_test|Order Fulfillment' ;;
    # sql: 'otc_billing_test|Billing & Invoicing||otc_accounts_receivable_test|Accounts Receivable Overview||otc_billing_invoice_details_test|Invoice Details' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|date||filter2|business_unit||filter3|customer_type||filter4|customer_country||filter5|customer_name||filter6|target_currency||filter7|order_source||filter8|item_category||filter9|item_language||filter10|test_or_demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  filter: filter10 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "test_or_demo"
  }

  # dimension: new_navigation_links {
  #   type: string
  #   hidden: no
  #   label: "Dashboard Navigation Links"
  #   description: "Add to Single Value Visualization. Defined HTML styling will be shown."
  #   required_fields: [item_delimiter,value_delimiter]
  #   sql:  '' ;;
  #   html:
  #   <!-- initial splits -->
  #   {% assign navItems = dash_bindings._value | split: item_delimiter._value %}

  #         @{link_generate_variable_defaults}
  #         {% assign link = link_generator._link %}
  #         {% assign filters_mapping = filter_bindings._value %}
  #         {% assign target_dashboard = _model._name | append: '::otc2_order_fulfillment_test' %}



  #   {% assign filterItems = filter_bindings._value | split: item_delimiter._value %}

  #   <!-- initialize variables -->
  #   {% assign counter = 1 %}
  #   {% assign navStyle = navigation_style._parameter_value %}
  #   {% assign focus = navigation_focus_page._parameter_value | times: 1 %}
  #   {% assign queryString = "" %}
  #   {% assign modelName = _model._name %}

  #   <!--Define Styles-->
  #   <!-- establish link, div and span styles based on navigation_style parameter -->
  #   {% case navStyle %}
  #   {% when "bar" %}
  #   {% assign linkStyle = "color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;" %}
  #   {% assign currentPageLinkStyle = linkStyle | append: "font-weight:bold;font-size: 20px;" %}
  #   {% assign divStyle = "border-radius: 5px; padding-top: 6px; padding-bottom: 20px; height: 60px; background: #F5F5F5;" %}
  #   {% assign spanStyle = "font-size: 18px; display: table; margin:0 auto;" %}
  #   {% assign imgStyle = "float: left; vertical-align: middle; height: 45px;" %}
  #   {% assign imgSrc = "@{image_dashboard_navigation}" %}
  #   {% when "tabs" %}
  #   {% assign sharedStyle = "font-color: #4285F4; padding: 5px 15px; border-style: solid; border-radius: 5px 5px 0 0; float: left; line-height: 20px; "%}
  #   {% assign linkStyle = sharedStyle | append: "border-width: 1px; border-color: #D3D3D3;" %}
  #   {% assign currentPageLinkStyle = sharedStyle | append: "border-width: 2px; border-color: #808080 #808080 #F5F5F5 #808080; font-weight: bold; background-color: #F5F5F5;" %}
  #   {% assign divStyle = "border-bottom: solid 2px #808080; padding: 6px 10px 5px 10px; height: 40px;" %}
  #   {% assign spanStyle = "font-size: 16px; padding: 6px 10px 0 10px; height: 40px;" %}
  #   {% assign imgStyle = "float: left; vertical-align: middle; height: 39px;" %}
  #   {% assign imgSrc = "@{image_dashboard_navigation}" %}
  #   {% when "small" %}
  #   {% assign linkStyle = "color: #0059D6; padding: 5px 15px; float: left; line-height: 40px;" %}
  #   {% assign currentPageLinkStyle = linkStyle | append: "font-weight:bold;font-size: 12px;" %}
  #   {% assign divStyle = "float: left;" %}
  #   {% assign spanStyle = "font-size: 10px; display: table; margin:0 auto;" %}
  #   {% assign imgStyle = "" %}
  #   {% assign imgSrc = "" %}
  #   {% endcase %}


  #   <!-- loop through filterItems defined in filterBindings dimension to create queryString used in dashboard url-->
  #   {% for filterItem in filterItems %}
  #   <!-- split filter into parts -->
  #   {% assign filterParts = filterItem | split: value_delimiter._value %}
  #   {% assign filterField = filterParts[0] %} <!-- for readability -->
  #   {% assign filterName = filterParts[1] %} <!-- for readability -->

  #   <!-- Define Filters -->
  #   <!-- case on filter, because we can't mix value interpolation into logic evaluation -->
  #   <!-- for example, this will not work: {% assign filterValue = _filters['{{ filter }}'] %} -->
  #   <!-- Add more cases for more filters ** -->
  #   {% case filterField %}
  #   {% when "filter1" %}
  #   {% assign filterValue = _filters['filter1'] | url_encode %}
  #   {% when "filter2" %}
  #   {% assign filterValue = _filters['filter2'] | url_encode %}
  #   {% when "filter3" %}
  #   {% assign filterValue = _filters['filter3'] | url_encode %}
  #   {% when "filter4" %}
  #   {% assign filterValue = _filters['filter4'] | url_encode %}
  #   {% when "filter5" %}
  #   {% assign filterValue = _filters['filter5'] | url_encode %}
  #   {% when "filter6" %}
  #   {% assign filterValue = _filters['filter6'] | url_encode %}
  #   {% when "filter7" %}
  #   {% assign filterValue = _filters['filter7'] | url_encode %}
  #   {% when "filter8" %}
  #   {% assign filterValue = _filters['filter8'] | url_encode %}
  #   {% when "filter9" %}
  #   {% assign filterValue = _filters['filter9'] | url_encode %}
  #   {% when "filter10" %}
  #   {% assign filterValue = _filters['filter10'] | url_encode %}
  #   {% else %}
  #   {% assign filterValue = "out of range filter" %}
  #   <!-- if you see this value, you've added more filters than supported in filterBindings -->
  #   {% endcase %}

  #   <!-- create individual filterString -->
  #   {% assign filterString = filterName | append: "=" | append: filterValue %}

  #   <!-- tack individual filterString onto end of queryString -->
  #   {% assign queryString = queryString | append: filterString | append: '&' %}

  #   {% endfor %}


  #   <!-- begin HTML -edit styles as needed -->
  #   <center>
  #   <div style="{{ divStyle }}">
  #   <span style="{{ spanStyle }}">
  #   <img style="{{ imgStyle }}" src="{{ imgSrc }}"/>

  #   <!-- Loop through navigation items as defined in dashBindings dimension-->
  #   {% for navItem in navItems %}
  #   {% assign navParts = navItem | split: value_delimiter._value %}
  #   {% assign dashName = navParts[1] %}
  #   {% assign dashID = navParts[0] %}
  #   {% assign dashIDcheckType = dashID | plus: 0 %}

  #   <!-- check if id is numeric for UDD ids or string for LookML dashboards -->
  #   <!-- if LookML Dashboard then append model name if not provided -->

  #   <!-- if dashIDcheckType equals 0 then string else numeric-->
  #   {% if dashIDcheckType == 0 %}
  #   <!-- if dashID contains '::' then model_name is already provided-->
  #   {% if dashID contains '::' %}
  #   {% else %}
  #   {% assign dashID = modelName | append: '::' | append: dashID %}
  #   {% endif %}
  #   {% endif %}


  #   {% assign dashUrl = "/dashboards/" | append: dashID %}


  #   <!-- build links -->
  #   {% if navigation_focus_page._in_query and counter == focus %}
  #   <span style="{{ currentPageLinkStyle }}">{{ dashName }}</span>
  #   {% elsif _explore._dashboard_url == dashUrl %}
  #   <span style="{{ currentPageLinkStyle }}">{{ dashName }}</span>
  #   {% else %}
  #   <a style="{{ linkStyle }}" href="{{ dashUrl }}?{{ queryString }}">{{ dashName }}</a>
  #   {% endif %}

  #   <!-- increment counter by 1 -->
  #   {% assign counter = counter | plus: 1 %}
  #   {% endfor %}

  #   </span>
  #   </div>;;

  dimension: test_navigation_html_link {
    required_fields: [item_delimiter,value_delimiter]
    sql:  'Test' ;;

    html: <div>
          @{link_generate_variable_defaults}
          {% assign link = link_generator._link %}
          {% assign filters_mapping = 'sales_orders_daily_agg.invoice_date|date||sales_orders_daily_agg.business_unit_name|business_unit' %}
          {% assign target_dashboard = _model._name | append: '::otc2_order_fulfillment_test' %}
          @{link_generate_dashboard_variable}
          <a href="{{dashboard_url}}"
          style="@{link_unselected_button_style}}">Order Fulfillment</a>
          @{link_generate_variable_defaults}
          {% assign link = link_generator._link %}
          {% assign filters_mapping = 'sales_orders_daily_agg.invoice_date|date||sales_orders_daily_agg.business_unit_name|business_unit' %}
          {% assign target_dashboard = _model._name | append: '::otc2_order_status_test' %}
          @{link_generate_dashboard_variable}
          <a href="{{dashboard_url}}"
          style="@{link_unselected_button_style}}">Order Status</a>
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
               <br><b>destination_filter_key: </b>{{destination_filter_key}}
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

}
