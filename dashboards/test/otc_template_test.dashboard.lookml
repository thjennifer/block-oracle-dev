######################
# use this template to provide standard navigation and filters for Sales Order to Cash dashboards
# this template can only be extended into another dashboard
#
######################

- dashboard: otc_template_test
  extension: required

  filters:
  - name: Order Date
    title: Order Date
    type: date_filter
    default_value:  ""
    # default_value: "2022/03/02 to 2022/03/03"
    # default_value: "last 1 year"
    # default_value: "@{DEFAULT_DATE_RANGE}"
    allow_multiple_values: true
    required: false
    ui_config:
      type: day_range_picker
      display: inline
      options: []

  - name: Business Unit
    title: Business Unit
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders
    listens_to_filters: [Test or Demo]
    field: sales_orders.business_unit_name

  - name: Country
    title: Sold to Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders
    listens_to_filters: [Business Unit]
    field: sales_orders.bill_to_customer_country

  - name: Customer
    title: Sold to Customer
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders
    listens_to_filters: [Country]
    field: sales_orders.bill_to_customer_name

  - name: Order Source
    title: Order Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders
    listens_to_filters: [Test or Demo]
    field: sales_orders.order_source_name

  - name: Item Category
    title: Item Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders
    field: sales_orders__lines.category_description
    listens_to_filters: [Test or Demo]

  - name: Target Currency
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
    listens_to_filters: [Test or Demo]
    field: currency_rate_md.to_currency

  - name: Test or Demo
    title: Test or Demo Data
    type: field_filter
    default_value: "demo"
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: sales_orders

    field: otc_common_parameters_xvw.parameter_use_demo_or_test_data


  elements:
    - title: navigation
      name: navigation
      explore: sales_orders
      type: single_value
      fields: [otc_dashboard_navigation_ext.navigation]
      filters:
        otc_dashboard_navigation_ext.navigation_focus_page: '1'
        otc_dashboard_navigation_ext.navigation_style: 'tabs'
      show_single_value_title: false
      show_comparison: false
      listen:
        Order Date: otc_dashboard_navigation_ext.filter1
        Business Unit: otc_dashboard_navigation_ext.filter2
        Country: otc_dashboard_navigation_ext.filter3
        Customer: otc_dashboard_navigation_ext.filter4
        Order Source: otc_dashboard_navigation_ext.filter5
        Item Category: otc_dashboard_navigation_ext.filter6
        Target Currency: otc_dashboard_navigation_ext.filter7
        Test or Demo: otc_dashboard_navigation_ext.filter8
      row: 0
      col: 0
      width: 24
      height: 1
