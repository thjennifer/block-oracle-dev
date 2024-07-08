- dashboard: otc2_order_fulfillment_test
  title: Order Fulfillment TEST 2
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: otc_template_sales_test

  filters:
  - name: date
    title: Ordered Date

  - name: item_language
    title: Language of Item Description
    type: field_filter
    default_value: "{{ _user_attributes['cortex_oracle_ebs_default_language'] }}"
    # default_value: 'US'
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    # explore: item_md
    # field: item_md__item_descriptions.language
    explore: language_codes_sdt
    field: language_codes_sdt.language_code
    listens_to_filters: [test_or_demo]


  elements:

  - name: navigation
    filters:
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '3'
    listen:
      date: otc_dashboard_navigation_sales_ext.filter1
      business_unit: otc_dashboard_navigation_sales_ext.filter2
      customer_type: otc_dashboard_navigation_sales_ext.filter3
      customer_country: otc_dashboard_navigation_sales_ext.filter4
      customer_name: otc_dashboard_navigation_sales_ext.filter5
      target_currency: otc_dashboard_navigation_sales_ext.filter6
      order_source: otc_dashboard_navigation_sales_ext.filter7
      item_category: otc_dashboard_navigation_sales_ext.filter8
      # item_language: otc_dashboard_navigation_sales_ext.filter9
      test_or_demo: otc_dashboard_navigation_sales_ext.filter10

  - name: navigation_testing
    explore: sales_orders_daily_agg
    type: single_value
    fields: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
    sorts: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
    row: 2
    col: 0
    width: 22
    height: 4
    model: cortex-oracle-ebs-test
    listen:
      date: otc_dashboard_navigation_sales_ext.filter1
      business_unit: otc_dashboard_navigation_sales_ext.filter2
      customer_type: otc_dashboard_navigation_sales_ext.filter3
      customer_country: otc_dashboard_navigation_sales_ext.filter4
      customer_name: otc_dashboard_navigation_sales_ext.filter5
      target_currency: otc_dashboard_navigation_sales_ext.filter6
      order_source: otc_dashboard_navigation_sales_ext.filter7
      item_category: otc_dashboard_navigation_sales_ext.filter8
      # item_language: otc_dashboard_navigation_sales_ext.filter9
      test_or_demo: otc_dashboard_navigation_sales_ext.filter10



  - title: In Full %
    name: In Full %
    explore: sales_orders
    type: single_value
    fields: [sales_orders.fulfilled_sales_order_percent, sales_orders.fulfilled_by_request_date_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    hidden_fields: [sales_orders.fulfilled_by_request_date_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    listen:
      date: sales_orders.ordered_date
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      business_unit: sales_orders.business_unit_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
    row: 2
    col: 0
    width: 4
    height: 3
    model: cortex-oracle-ebs-test
