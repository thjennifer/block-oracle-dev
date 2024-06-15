######################
# use this template to provide standard navigation and filters for Sales Order to Cash dashboards
# this template can only be extended into another dashboard
#
######################

- dashboard: otc_template
  extension: required

  filters:
  - name: Date
    title: Date
    type: date_filter
    default_value:  ""
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
    field: sales_orders.business_unit_name

  - name: Customer Type
    title: 'Customer: Type'
    type: field_filter
    default_value: 'bill'
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options:
        - bill
        - sold
    explore: sales_orders
    field: sales_orders.parameter_customer_type

  - name: Country
    title: 'Customer: Country'
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders
    listens_to_filters: [Business Unit, Customer Type]
    field: sales_orders.selected_customer_country

  - name: Customer
    title: 'Customer: Name'
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders
    listens_to_filters: [Country, Customer Type]
    field: sales_orders.selected_customer_name

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


  - name: Target Currency
    title: Target Currency
    type: field_filter
    default_value: "{{ _user_attributes['cortex_oracle_ebs_default_currency'] }}"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    explore: currency_rate_md
    field: currency_rate_md.to_currency



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
        Date: otc_dashboard_navigation_ext.filter1
        Business Unit: otc_dashboard_navigation_ext.filter2
        Customer Type: otc_dashboard_navigation_ext.filter3
        Country: otc_dashboard_navigation_ext.filter4
        Customer: otc_dashboard_navigation_ext.filter5
        Order Source: otc_dashboard_navigation_ext.filter6
        Item Category: otc_dashboard_navigation_ext.filter7
        Target Currency: otc_dashboard_navigation_ext.filter8
      row: 0
      col: 0
      width: 24
      height: 1
