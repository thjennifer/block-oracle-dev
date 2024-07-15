- dashboard: otc_template_orders_test
  title: OTC Template for Sales Orders TEST

  extension: required
  extends: otc_template_core_filters_test

  filters:
  - name: date
    title: Ordered Date

  - name: order_source
    title: Order Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.order_source_name
    listens_to_filters: [business_unit, test_or_demo]

  - name: item_category
    title: Item Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg__lines.category_description
    listens_to_filters: [business_unit, test_or_demo]

  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '1'
      otc_dashboard_navigation_ext.parameter_navigation_style: 'tabs'
      otc_dashboard_navigation_ext.parameter_navigation_subject: 'orders'
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      customer_type: otc_dashboard_navigation_ext.filter3
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
      order_source: otc_dashboard_navigation_ext.filter7
      item_category: otc_dashboard_navigation_ext.filter8
      # item_language: otc_dashboard_navigation_ext.filter9
