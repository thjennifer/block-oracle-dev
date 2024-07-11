- dashboard: otc_template_sales_test
  extension: required
  extends: otc_template_core_filters_test

  filters:


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
    listens_to_filters: [test_or_demo]

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
    listens_to_filters: [test_or_demo]

  elements:
    - name: navigation
      title: navigation
      explore: sales_orders_daily_agg
      type: single_value
      fields: [otc_dashboard_navigation_sales_ext.navigation]
      filters:
        otc_dashboard_navigation_sales_ext.navigation_focus_page: '1'
        otc_dashboard_navigation_sales_ext.navigation_style: 'tabs'
      show_single_value_title: false
      show_comparison: false
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
      row: 0
      col: 0
      width: 24
      height: 1
      model: cortex-oracle-ebs-test

    - name: new_navigation_testing
      explore: sales_orders_daily_agg
      type: single_value
      # type: looker_grid
      # fields: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
      # fields: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
      fields: [otc_dashboard_navigation_sales_ext.new_navigation_links]
      # sorts: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
      filters:
        otc_dashboard_navigation_sales_ext.navigation_focus_page: '1'
        otc_dashboard_navigation_sales_ext.navigation_style: 'tabs'
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
      explore: sales_orders_daily_agg
      # type: single_value
      type: looker_grid
      fields: [otc_dashboard_navigation_sales_ext.new_navigation_links]
      # sorts: [otc_dashboard_navigation_sales_ext.test_navigation_html_link]
      filters:
        otc_dashboard_navigation_sales_ext.navigation_focus_page: '1'
        otc_dashboard_navigation_sales_ext.navigation_style: 'tabs'
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
