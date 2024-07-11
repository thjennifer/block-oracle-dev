- dashboard: otc2_order_status_test
  title: Order Status TEST 2
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

  elements:

  - title: navigation
    name: navigation
    filters:
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '1'

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

  - name: new_navigation_testing
    explore: sales_orders_daily_agg
    filters:
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '1'
    type: single_value
    # type: looker_grid
    # fields: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
    # sorts: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
    row: 2
    col: 0
    width: 22
    height: 8
    truncate_text: no
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

  - name: navigation_testing
    row: 2
    col: 0
    width: 22
    height: 8
    truncate_text: no
    model: cortex-oracle-ebs-test
    filters:
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '1'
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

  - title: Total Sales Orders
    name: Total Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    listen:
      date: sales_orders.ordered_date
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      business_unit: sales_orders.business_unit_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders."
    row: 2
    col: 0
    width: 6
    height: 2
    model: cortex-oracle-ebs-test
