include: "/views/base/template_dashboard_navigation.view"

view: otc_dashboard_navigation_ext {
  extends: [template_dashboard_navigation]

  dimension: map_filter_numbers_to_dashboard_filter_names {
    sql: '1|date||2|business_unit||3|customer_type||4|customer_country||5|customer_name||6|target_currency||7|order_source||8|item_category||9|item_language' ;;
  }

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: {% assign subject = parameter_navigation_subject._parameter_value %}
          {% case subject %}
            {% when "orders" %}
            "otc_order_status|Order Status|1,2,3,4,5,6,7,8||otc_sales_performance|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment|Order Fulfillment|1,2,3,4,5,6,7,8,9"
          {% when "billing" %}
            "otc_billing|Billing & Invoicing|1,2,3,4,5,6,7,8||otc_accounts_receivable|Accounts Receivable|1,2,3,4,5,6||otc_billing_invoice_details|Invoice Details|1,2,3,4,5,6,7,8"
          {% endcase %}
          ;;
  }

  parameter: parameter_navigation_focus_page {
    allowed_value: {value: "3"}
    allowed_value: {value: "4"}
  }

  filter: filter1 {
    type: date
    hidden: yes
    label: "date"
  }
  filter: filter2 { hidden: yes label: "business_unit"}
  filter: filter3 { hidden: yes label: "customer type"}
  filter: filter4 { hidden: yes label: "customer_country"}
  filter: filter5 { hidden: yes label: "customer_name"}
  filter: filter6 { hidden: yes label: "target_currency"}
  filter: filter7 { hidden: yes label: "order_source"}
  filter: filter8 { hidden: yes label: "item_category"}
  filter: filter9 { hidden: yes label: "item_language"}

  parameter: parameter_navigation_subject {
    hidden: no
    type: unquoted
    allowed_value: {value: "orders" label: "Orders"}
    allowed_value: {value: "billing" label: "Billing"}
    default_value: "orders"
  }

  dimension: test_navigation_parts {
    type: string
    hidden: no
    label: "Test Navigation Parts"
    description: "Add to Single Value Visualization. Defined HTML styling will be shown."
    sql:  '' ;;
    html:
      <!-- initialize variables used in following steps-->
        @{link_generate_variable_defaults}

      <!-- capture the full url of the dashboard including filters -->
      {% assign link = link_generator._link %}.
      {% assign counter = 1 %}
      {% assign qualify_filter_names = false %}

      <!-- generate filters_mapping liquid variable passed into next step -->
      @{link_build_mappings_from_dash_bindings}

       <!-- generate dashboard_url liquid variable used below-->
      @{link_generate_dashboard_variable}

      <!-- generate page_style and focus_page_style liquid variables used below -->
      @{link_generate_dashboard_nav_style}

     <div>

      <b>{{dash_label}} - filters_mapping: </b>{{filters_mapping}} <br><br>

      <b>{{dash_label}} - url: </b>{{dashboard_url}} <br><br>

      <b>page style: </b>{{page_style}}
      <b>focus_page style: </b>{{focus_page_style}}
      <!-- increment counter by 1 -->
      {% assign counter = counter | plus: 1 %}
      {% endfor %}

      </div>

      ;;
  }

  # html:
  # <!-- initialize variables used in following steps-->
  # @{link_generate_variable_defaults}

  # <!-- capture the full url of the dashboard including filters -->
  # {% assign link = link_generator._link %}.
  # {% assign counter = 1 %}
  # {% assign qualify_filter_names = false %}

  # <!-- generate filters_mapping liquid variable passed into next step -->
  # @{link_build_mappings_from_dash_bindings}
  # <!-- generate dashboard_url liquid variable used below-->
  # @{link_generate_dashboard_variable}
  # <!-- generate page_style and focus_page_style liquid variables used below -->
  # @{link_generate_dashboard_nav_style}


  # <div style="{{ div_style }}">
  # <span style = "{{ span_style }}">

  # {% assign focus_page = navigation_focus_page._parameter_value | times: 1 %}

  # {% if navigation_focus_page._in_query and counter == focus_page %}
  # <span style="{{ focus_page_style }}">{{ dash_label }}</span>
  # {% elsif _explore._dashboard_url == dashboard_url %}
  # <span style="{{ focus_page_style }}">{{ dash_label }}</span>
  # {% else %}
  # <a style="{{ page_style }}" href="{{ dashboard_url }}">{{ dash_label }}</a>
  # {% endif %}
  # <!-- increment counter by 1 -->
  # {% assign counter = counter | plus: 1 %}
  # {% endfor %}
  # </span>
  # </div>

  # ;;

}
