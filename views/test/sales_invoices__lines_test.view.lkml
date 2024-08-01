include: "/views/core/sales_invoices__lines_rfn.view"
include: "/views/test/sales_invoices_common_amount_measures_ext_test.view"

view: +sales_invoices__lines {

  measure: average_unit_list_price_when_discount_target_currency_with_drill_link {
    hidden: yes
    type: number
    sql: ${average_unit_list_price_when_discount_target_currency} ;;
    value_format_name: decimal_2
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}' | append: '||sales_invoices__lines.is_discount_selling_price|is_discounted||sales_invoices__lines.is_intercompany|is_intercompany' %}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: average_unit_selling_price_when_discount_target_currency_with_drill_link {
    hidden: yes
    type: number
    sql: ${average_unit_selling_price_when_discount_target_currency} ;;
    value_format_name: decimal_2
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}' | append: '||sales_invoices__lines.is_discount_selling_price|is_discounted||sales_invoices__lines.is_intercompany|is_intercompany' %}
      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}
      {% assign default_filters='is_discounted=Yes'%}
      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }



#} end average unit prices and discount measures




  measure: total_transaction_amount_target_currency_formatted {
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_discount_amount_target_currency_formatted {
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }

  measure: total_tax_amount_target_currency_formatted {
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}'%}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }
  }


  dimension: is_null_invoice_line {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.LINE_ID is null ;;
  }

  dimension: is_null_order_header_id {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.ORDER_HEADER_ID is null ;;
  }

  dimension: is_null_tax_amount {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.TAX_AMOUNT is null ;;
  }

  measure: count_distinct_item_part_number {
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${item_part_number},'Unknown') ;;
  }

  measure: count_distinct_fiscal_period_set {
    view_label: "TEST STUFF"
    type: count_distinct
    sql: COALESCE(${fiscal_period_set_name},'Unknown') ;;
  }

  dimension: is_difference_invoice_date_and_ledger_date {
    hidden: no
    type: yesno
    view_label: "TEST STUFF"
    sql: ${TABLE}.LEDGER_DATE <> ${sales_invoices.invoice_raw} ;;
  }

  dimension: list_price_times_invoice_quantity {
    hidden: no
    type: number
    view_label: "TEST STUFF"
    sql: ${unit_list_price} *  ${invoiced_quantity} ;;
    value_format_name: decimal_2
  }

  dimension: selling_price_times_invoice_quantity {
    hidden: no
    type: number
    view_label: "TEST STUFF"
    sql: ${unit_selling_price} *  ${invoiced_quantity} ;;
    value_format_name: decimal_2
  }

  dimension: is_different_list_and_selling_price {
    type: yesno
    hidden: no
    view_label: "TEST STUFF"
    sql: ${unit_list_price}<> ${unit_selling_price};;
  }

  dimension: is_different_revenue_and_txn_amount {
    type: yesno
    hidden: no
    view_label: "TEST STUFF"
    sql: ${revenue_amount}<> ${transaction_amount};;
  }

  dimension: has_invoiced_and_credited_quantity_on_same_line {
    type: yesno
    hidden: no
    view_label: "TEST STUFF"
    sql: ${credited_quantity} is not null AND ${invoiced_quantity} is not null;;
  }

  dimension: trap_link_pieces {
    type: string
    view_label: "TEST STUFF"
    sql: @{link_generate_variable_defaults}
          {% assign link = link_generator._link %}'{{link}}';;

  }

  measure: trap_link_pieces_count {
    type: count
    view_label: "TEST STUFF"
    # sql: @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}'{{link}}';;
     # ## opens drill modal with the selected filters
    # link: {
    #   label: "testing url"
    #   url: "{{link}}"
    # }
    # drill_fields: [line_id]

    # link: {
    #   label: "Invoice Line Details"
    #   icon_url: "/favicon.ico"
    #   url: "
    #   @{link_generate_variable_defaults}
    #   {% assign link = link_generator._link %}
    #   {% assign filters_mapping = 'sales_invoices.invoice_date|date||sales_invoices.bill_to_customer_country|customer_country' %}
    #   {% assign model = _model._name %}
    #   {% assign target_dashboard = _model._name | append: '::otc_order_details' %}
    #   {% assign default_filters_override = false %}
    #   "
    # }

      link: {
        label: "Invoice Line Details"
        icon_url: "/favicon.ico"
        url: "
        @{link_generate_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign filters_mapping = 'sales_invoices.invoice_date|date||sales_invoices.bill_to_customer_country|customer_country'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

        {% assign default_filters_override = false %}
        @{link_generate_dashboard_url}
    "
  }

  }

  # breaking in link_match_filters_to_destination
  # {% assign filters_mapping = filters_mapping | split: '||' %}
  # {% assign filters_array = filters_array | split: ',' %}
  # {% assign filters_array_destination = '' %}

  # {% for source_filter in filters_array %}
  #   {% assign source_filter_key = source_filter | split:'|' | first %}
  #   {% assign source_filter_value = source_filter | split:'|' | last %}

  #   {% for destination_filter in filters_mapping %} {% comment %} This will loop through the value pairs to determine if there is a match to the destination {% endcomment %}
  #     {% assign destination_filter_key = destination_filter | split:'|' | first %}
  #     {% assign destination_filter_value = destination_filter | split:'|' | last %}
  #     {% if source_filter_key == destination_filter_key %}
  #       {% assign parameter_clean = destination_filter_value | append:'|' | append: source_filter_value %}
  #       {% assign filters_array_destination =  filters_array_destination | append: parameter_clean | append:',' %}
  #     {% endif %}
  #   {% endfor %}
  # {% endfor %}
  # {% assign size = filters_array_destination | size | minus: 1 %}
  # {% assign filters_array_destination = filters_array_destination | slice: 0, size %}

  # link: {
  #   label: "Open Order Details Dashboard"
  #   icon_url: "/favicon.ico"
  #   url: "
  #   @{link_generate_variable_defaults}
  #   {% assign link = link_generator._link %}
  #   {% assign filters_mapping = '@{link_otc_shared_filters}' | strip_new_lines | append: '||across_sales_and_billing_summary_xvw.order_status|Order Status||deliveries.is_blocked|Is Blocked' %}

  #   {% assign model = _model._name %}
  #   {% assign target_dashboard = _model._name | append: '::otc_order_details' %}

  #   {% assign default_filters_override = false %}

  #   @{link_generate_dashboard_url}
  #   "
  # }


  measure: total2_transaction_amount_target_currency_formatted {
    hidden: no
    type: sum
    view_label: "TEST STUFF"
    group_label: "Formatted as Large Numbers"
    label: "{% if _field._is_selected %}@{derive_currency_label}Total Transaction Amount ({{currency}}){%else%}Total Transaction Amount (Target Currency){%endif%}"
    sql: ${transaction_amount_target_currency} ;;
    value_format_name: format_large_numbers_d1
    link: {
      label: "Invoice Line Details"
      icon_url: "/favicon.ico"
      url: "
      @{link_generate_variable_defaults}
      {% assign link = link_generator._link %}
      {% assign qualify_filter_names = false %}
      {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'  | append: '||is_discount_selling_price|is_discounted||is_intercompany|is_intercompany' %}

      {% assign model = _model._name %}
      {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

      {% assign default_filters_override = false %}
      @{link_generate_dashboard_url}
      "
    }

    # html: <div>
    # @{link_generate_variable_defaults}
    # {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}' %}
    # {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}
    # <b>Filters Mapping: </b> {{filters_mapping}}
    # <br><br><b>Target Dashboard: </b>{{target_dashboard}}
    # </div>;;

    # html: html:  <div>
    # @{link_generate_variable_defaults}

    # {% assign link = link_generator._link %}
    # {% assign filters_mapping = '@{link_sales_invoices_source_to_target_dashboard_filters}' %}
    # {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

    # <b>Target Dashboard: </b>{{target_dashboard}}

    # <!-- start link_generate_dashboard_variable code -->
    # {% assign content = '/dashboards-next/' %}
    # {% assign link_query = link | split: '?' | last %}
    # {% assign link_query_parameters = link_query | split: '&' %}
    # {% assign target_content_filters = '' %}
    # {% assign host = '' %}

    # {% if new_page %}
    # @{link_host}
    # {% endif %}

    # <!-- start of link_extract_context code -->
    # {% assign filters_array = '' %}
    # {% for parameter in link_query_parameters %}
    # {% assign parameter_key = parameter | split:'=' | first %}
    # {% assign parameter_value = parameter | split:'=' | last %}
    # {% assign parameter_test = parameter_key | slice: 0,2 %}
    # {% if parameter_test == 'f[' %}
    #     {% comment %} Link contains multiple parameters, need to test if filter {% endcomment %}
    #     {% if parameter_key != parameter_value %}
    #     {% comment %} Tests if the filter value is is filled in, if not it skips  {% endcomment %}
    #     {% assign parameter_key_size = parameter_key | size %}
    #     {% assign slice_start = 2 %}
    #     {% assign slice_end = parameter_key_size | minus: slice_start | minus: 1 %}
    #     {% assign parameter_key = parameter_key | slice: slice_start, slice_end %}
    #     {% assign parameter_clean = parameter_key | append:'|' |append: parameter_value %}
    #     {% assign filters_array =  filters_array | append: parameter_clean | append: ',' %}
    #     {% endif %}
    #     {% elsif parameter_key == 'dynamic_fields' %}
    #     {% assign dynamic_fields = parameter_value %}
    #     {% elsif parameter_key == 'query_timezone' %}
    #     {% assign query_timezone = parameter_value %}
    #     {% endif %}
    #     {% endfor %}
    #     {% assign size = filters_array | size | minus: 1 %}
    #     {% assign filters_array = filters_array | slice: 0, size %}
    #     <br><br><b>source_filters_array: </b>
    #     {{filters_array}}
    #     <!-- end link_extract_context code -->

    #     <!-- start link_match_filters_to_destination -->

    #     {% assign filters_mapping = filters_mapping | split: '||' %}
    #     {% assign filters_array = filters_array | split: ',' %}
    #     {% assign filters_array_destination = '' %}

    #     {% for source_filter in filters_array %}
    #     {% assign source_filter_key = source_filter | split:'|' | first %}
    #     {% assign source_filter_value = source_filter | split:'|' | last %}
    #     <br><b>source_filter_key: </b>{{source_filter_key}}
    #     {% for destination_filter in filters_mapping %}
    #     {% comment %} This will loop through the value pairs to determine if there is a match to the destination {% endcomment %}
    #     {% assign destination_filter_key = destination_filter | split:'|' | first %}
    #     {% assign destination_filter_value = destination_filter | split:'|' | last %}
    #     <br><b>destination_filter_key: </b>{{destination_filter_key}}
    #     {% if source_filter_key == destination_filter_key %}
    #     {% assign parameter_clean = destination_filter_value | append:'|' | append: source_filter_value %}
    #     {% assign filters_array_destination =  filters_array_destination | append: parameter_clean | append:',' %}
    #     {% endif %}
    #     {% endfor %}
    #     {% endfor %}
    #     {% assign size = filters_array_destination | size | minus: 1 | at_least: 0 %}
    #     {% assign filters_array_destination = filters_array_destination | slice: 0, size %}
    #     <br><br><b>filters_array_destination: </b>
    #     {{filters_array_destination}}
    #     <!-- end link_match_filters_to_destination -->

    #     <!-- begin link_build_filter_string -->
    #     {% assign filter_string = '' %}
    #     {% assign filters_array_destination = filters_array_destination | split: ',' %}
    #     {% for filter in filters_array_destination %}
    #     {% assign filter_key = filter | split:'|' | first %}
    #     {% assign filter_value = filter | split:'|' | last %}

    #     {% if content == '/explore/' %}
    #     {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
    # {% else %}
    # {% assign filter_value = filter_value | encode_url %}
    # {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
    # {% endif %}

    # {% assign filter_string = filter_string | append: filter_compile | append:'&' %}
    # {% endfor %}
    # {% assign size = filter_string | size | minus: 1 | at_least: 0 %}
    # {% assign filter_string = filter_string | slice: 0, size %}
    # <br><br><b>filter_string: </b>
    # {{filter_string}}
    # <!-- end link_build_filter_string -->

    # {% if default_filters != '' %}
    # <!-- begin link_build_default_filter_string -->
    # {% assign default_filter_string = '' %}
    # {% assign default_filters = default_filters | split: ',' %}
    # {% for filter in default_filters %}
    # {% assign filter_key = filter | split:'=' | first %}
    # {% assign filter_value = filter | split:'=' | last %}
    # {% if content == '/explore/' %}
    # {% assign filter_compile = 'f[' | append: filter_key | append:']=' | append: filter_value %}
    # {% else %}
    # {% assign filter_value = filter_value | encode_url %}
    # {% assign filter_compile = filter_key | append:'=' | append: filter_value %}
    # {% endif %}
    # {% assign default_filter_string = default_filter_string | append: filter_compile | append:'&' %}
    # {% endfor %}
    # {% assign size = default_filter_string | size | minus: 1 | at_least: 0 %}
    # {% assign default_filter_string = default_filter_string | slice: 0, size %}
    # <br><br><b>default_filter_string: </b>
    # {{default_filter_string}}
    # <!-- end link_build_default_filter_string -->

    # {% endif %}

    # {% if default_filters_override == true and default_filters != '' %}
    # {% assign target_content_filters = default_filter_string | append:'&' | append: filter_string %}
    # {% elsif default_filters_override == false and default_filters != '' %}
    # {% assign target_content_filters = filter_string | append:'&' | append: default_filter_string %}
    # {% else %}
    # {% assign target_content_filters = filter_string %}
    # {% endif %}

    # {% comment %} Builds final link to be presented in frontend {% endcomment %}
    # <br><br><b>final link: </b>
    # {{ link_host | append:content | append:target_dashboard | append: '?' | append: target_content_filters }}

    # <!-- end link_generate_dashboard_variable code -->

    # </div>;;
    }




   }