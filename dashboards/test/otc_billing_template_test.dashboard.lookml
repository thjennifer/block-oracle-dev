######################
# use this template to provide standard navigation and filters for Sales Order to Cash dashboards
# this template can only be extended into another dashboard
#
######################

- dashboard: otc_billing_template_test
  extension: required

  filters:
  - name: date
    title: Date
    type: date_filter
    default_value:  ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: day_range_picker
      display: inline
      options: []

  - name: business_unit
    title: Business Unit
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_invoices_daily_agg
    listens_to_filters: [test_or_demo]
    field: sales_invoices_daily_agg.business_unit_name

  # - name: Customer Type
  #   title: 'Customer: Type'
  #   type: field_filter
  #   default_value: 'bill'
  #   allow_multiple_values: false
  #   required: false
  #   ui_config:
  #     type: button_toggles
  #     display: inline
  #     options:
  #       - bill
  #       - sold
  #   explore: sales_orders
  #   field: sales_orders.parameter_customer_type

  - name: customer_country
    title: 'Customer: Country'
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_invoices_daily_agg
    listens_to_filters: [business_unit, test_or_demo]
    field: sales_invoices_daily_agg.bill_to_customer_country

  - name: customer_name
    title: 'Customer: Name'
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_invoices_daily_agg
    listens_to_filters: [customer_country, test_or_demo]
    field: sales_invoices_daily_agg.bill_to_customer_name

  - name: order_source
    title: Order Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_invoices_daily_agg
    listens_to_filters: [test_or_demo]
    field: sales_invoices_daily_agg.order_source_name

  - name: item_category
    title: Item Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_invoices
    field: sales_invoices__lines.category_description
    listens_to_filters: [test_or_demo]

  - name: target_currency
    title: Target Currency
    type: field_filter
    default_value: "{{ _user_attributes['cortex_oracle_ebs_default_currency'] }}"
    # default_value: 'USD'
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    explore: currency_rate_md
    listens_to_filters: [test_or_demo]
    field: currency_rate_md.to_currency

  - name: test_or_demo
    title: Test or Demo Data
    type: field_filter
    default_value: "demo"
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: sales_invoices_daily_agg
    field: otc_common_parameters_xvw.parameter_use_demo_or_test_data


  # elements:
  #   - title: navigation
  #     name: navigation
  #     explore: sales_orders
  #     type: single_value
  #     fields: [otc_dashboard_navigation_ext.navigation]
  #     filters:
  #       otc_dashboard_navigation_ext.navigation_focus_page: '1'
  #       otc_dashboard_navigation_ext.navigation_style: 'tabs'
  #     show_single_value_title: false
  #     show_comparison: false
  #     listen:
  #       Date: otc_dashboard_navigation_ext.filter1
  #       Business Unit: otc_dashboard_navigation_ext.filter2
  #       # Customer Type: otc_dashboard_navigation_ext.filter3
  #       Country: otc_dashboard_navigation_ext.filter4
  #       Customer: otc_dashboard_navigation_ext.filter5
  #       Order Source: otc_dashboard_navigation_ext.filter6
  #       Item Category: otc_dashboard_navigation_ext.filter7
  #       Target Currency: otc_dashboard_navigation_ext.filter8
  #       Test or Demo: otc_dashboard_navigation_ext.filter9
  #     row: 0
  #     col: 0
  #     width: 24
  #     height: 1
