######################
# use this template to provide standard navigation and filters for Sales Order to Cash dashboards
# this template can only be extended into another dashboard
#
######################

- dashboard: otc_template_core_filters
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false

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
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.business_unit_name

  - name: customer_type
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
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.parameter_customer_type

  - name: customer_country
    title: 'Customer: Country'
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.selected_customer_country
    listens_to_filters: [business_unit,customer_type]

  - name: customer_name
    title: 'Customer: Name'
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.selected_customer_name
    listens_to_filters: [business_unit,customer_type]

  - name: target_currency
    title: Target Currency
    type: field_filter
    default_value: "{{ _user_attributes['cortex_oracle_ebs_default_currency'] }}"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    explore: currency_rate_md
    field: currency_rate_md.to_currency

  elements:
  - name: dashboard_navigation
    type: single_value
    explore: sales_orders
    fields: [otc_dashboard_navigation_ext.navigation_links]
    filters:
        otc_dashboard_navigation_ext.parameter_navigation_focus_page: '1'
        otc_dashboard_navigation_ext.parameter_navigation_style: 'buttons'
        otc_dashboard_navigation_ext.parameter_navigation_subject: 'orders'
    show_single_value_title: false
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      customer_type: otc_dashboard_navigation_ext.filter3
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
    row: 0
    col: 0
    width: 24
    height: 1
