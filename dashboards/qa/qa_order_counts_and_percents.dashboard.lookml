- dashboard: qa_order_counts_and_percents
  title: QA Order Counts and Percents
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: QqnKBVmOvPwfw1ETsCs0Jo
  elements:
  - title: SalesOrders
    name: SalesOrders
    model: cortex-oracle-ebs
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders.order_count, sales_orders.no_holds_sales_order_count, sales_orders.cancelled_sales_order_count,
      sales_orders.has_return_sales_order_count, sales_orders.blocked_sales_order_count,
      sales_orders.open_sales_order_count, sales_orders.fulfilled_sales_order_count, sales_orders.fulfilled_by_request_date_sales_order_count,
      sales_orders.has_backorder_sales_order_count, sales_orders.fulfilled_by_promise_date_sales_order_count,
      sales_orders.fillable_sales_order_count, sales_orders.non_cancelled_sales_order_count]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      sales_orders.open_sales_order_count:
        is_active: false
    hidden_pivots: {}
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    y_axes: []
    listen:
      Category Description: sales_orders__lines.category_description
      Ordered Date: sales_orders.ordered_date
      Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 0
    col: 0
    width: 24
    height: 3
  - title: Agg Counts
    name: Agg Counts
    model: cortex-oracle-ebs
    explore: sales_orders_daily_agg
    type: looker_grid
    fields: [sales_orders_daily_agg.order_count, sales_orders_daily_agg.no_holds_sales_order_count,
      sales_orders_daily_agg.cancelled_sales_order_count, sales_orders_daily_agg.has_return_sales_order_count,
      sales_orders_daily_agg.blocked_sales_order_count, sales_orders_daily_agg.open_sales_order_count,
      sales_orders_daily_agg.fulfilled_sales_order_count, sales_orders_daily_agg.fulfilled_by_request_date_sales_order_count,
      sales_orders_daily_agg.has_backorder_sales_order_count, sales_orders_daily_agg.fulfilled_by_promise_date_sales_order_count,
      sales_orders_daily_agg.fillable_sales_order_count, sales_orders_daily_agg.non_cancelled_sales_order_count]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      sales_orders_daily_agg__lines.total_sales_amount_target_currency:
        is_active: false
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_pivots: {}
    defaults_version: 1
    y_axes: []
    listen:
      Ordered Date: sales_orders_daily_agg.ordered_date
      Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 3
    col: 0
    width: 24
    height: 4
  - title: SalesOrders %s
    name: SalesOrders %s
    model: cortex-oracle-ebs
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders.has_backorder_sales_order_percent, sales_orders.cancelled_sales_order_percent,
      sales_orders.has_return_sales_order_percent, sales_orders.fulfilled_sales_order_percent,
      sales_orders.fulfilled_by_request_date_sales_order_percent, sales_orders.no_holds_sales_order_percent]
    filters:
      sales_orders__lines.category_description: ''
      sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data: demo
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      sales_orders.open_sales_order_count:
        is_active: false
    hidden_pivots: {}
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    y_axes: []
    listen:
      Ordered Date: sales_orders.ordered_date
      Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 7
    col: 0
    width: 10
    height: 4
  - title: Agg %s
    name: Agg %s
    model: cortex-oracle-ebs
    explore: sales_orders_daily_agg
    type: looker_grid
    fields: [sales_orders_daily_agg.has_backorder_sales_order_percent, sales_orders_daily_agg.cancelled_sales_order_percent,
      sales_orders_daily_agg.has_return_sales_order_percent, sales_orders_daily_agg.fulfilled_sales_order_percent,
      sales_orders_daily_agg.fulfilled_by_request_date_sales_order_percent, sales_orders_daily_agg.no_holds_sales_order_percent]
    filters:
      sales_orders_daily_agg__lines.item_category_description: ''
      sales_orders_common_parameters_xvw.parameter_use_test_or_demo_data: demo
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      sales_orders_daily_agg__lines.total_sales_amount_target_currency:
        is_active: false
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_pivots: {}
    defaults_version: 1
    y_axes: []
    listen:
      Ordered Date: sales_orders_daily_agg.ordered_date
      Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 11
    col: 0
    width: 10
    height: 3
  filters:
  - name: Ordered Date
    title: Ordered Date
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: cortex-oracle-ebs
    explore: sales_orders
    listens_to_filters: []
    field: sales_orders.ordered_date
  - name: Use Test or Demo Data
    title: Use Test or Demo Data
    type: field_filter
    default_value: demo
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
    model: cortex-oracle-ebs
    explore: sales_orders
    listens_to_filters: []
    field: otc_common_parameters_xvw.parameter_use_test_or_demo_data
  - name: Category Description
    title: Category Description
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: cortex-oracle-ebs
    explore: sales_orders
    listens_to_filters: []
    field: sales_orders__lines.category_description