- dashboard: otc2_sales_performance_test
  title: Sales Performance2 TEST
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: [otc_template_sales_test]

  filters:
  - name: date
    title: Ordered Date

  - name: product_level
    title: Product Level to Display
    type: field_filter
    default_value: "Category"
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: sales_orders
    field: sales_orders__lines.parameter_display_product_level

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
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '2'
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
    type: single_value
    # type: looker_grid
    filters:
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '2'
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
      item_language: otc_dashboard_navigation_sales_ext.filter9
      test_or_demo: otc_dashboard_navigation_sales_ext.filter10

  - name: navigation_testing
    row: 2
    col: 0
    width: 22
    height: 8
    truncate_text: no
    model: cortex-oracle-ebs-test
    filters:
      otc_dashboard_navigation_sales_ext.navigation_focus_page: '2'
    listen:
      date: otc_dashboard_navigation_sales_ext.filter1
      business_unit: otc_dashboard_navigation_sales_ext.filter2
      customer_type: otc_dashboard_navigation_sales_ext.filter3
      customer_country: otc_dashboard_navigation_sales_ext.filter4
      customer_name: otc_dashboard_navigation_sales_ext.filter5
      target_currency: otc_dashboard_navigation_sales_ext.filter6
      order_source: otc_dashboard_navigation_sales_ext.filter7
      item_category: otc_dashboard_navigation_sales_ext.filter8
      item_language: otc_dashboard_navigation_sales_ext.filter9
      test_or_demo: otc_dashboard_navigation_sales_ext.filter10


  - name: Top Products by Sales
    title: Top Products by Sales
    explore: sales_orders
    type: looker_bar
    fields: [sales_orders__lines.selected_product_dimension_id, sales_orders__lines.selected_product_dimension_description, sales_orders__lines.total_sales_amount_target_currency_formatted]
    sorts: [sales_orders__lines.total_sales_amount_target_currency_formatted desc]
    hidden_fields: [sales_orders__lines.selected_product_dimension_id]

    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: false
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    series_colors:
      {sales_orders__lines.total_sales_amount_target_currency_formatted: "#74A09F"}
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_orders__lines.total_sales_amount_target_currency_formatted,
            id: sales_orders__lines.total_sales_amount_target_currency_formatted
            }], showLabels: true, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true

    listen:
      date: sales_orders.ordered_date
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      business_unit: sales_orders.business_unit_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
      product_level: sales_orders__lines.parameter_display_product_level
      item_language: otc_common_parameters_xvw.parameter_language

    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Limited to 10 Products. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 2
    col: 0
    width: 12
    height: 10
    model: cortex-oracle-ebs-test
