include: "/views/core/sales_invoices__lines_rfn.view"

view: +sales_invoices__lines {

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
    #   label: "Open Invoice Details Dashboard"
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
        label: "Open Invoice Details Dashboard"
        icon_url: "/favicon.ico"
        url: "
        @{link_generate_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign filters_mapping = 'sales_invoices.invoice_date|date||sales_invoices.bill_to_customer_country|customer_country'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details_test' %}

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


   }
