
- dashboard: qa_amounts_with_currency_conversion
  title: 'QA Amounts with Currency Conversion'
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''

  elements:
  - title: Daily Agg unnesting Amounts
    name: Daily Agg unnesting Amounts
    explore: sales_orders_daily_agg
    type: looker_grid
    fields: [sales_orders_daily_agg.ordered_year, sales_orders_daily_agg__lines__amounts.target_currency_code,
      sales_orders_daily_agg__lines__amounts.total_sales_amount_target_currency, sales_orders_daily_agg__lines.average_ordered_amount_per_order_target_currency,
      sales_orders_daily_agg.sales_order_count, sales_orders_daily_agg.cancelled_order_count,
      sales_orders_daily_agg.non_cancelled_order_count]
    filters: {}
    sorts: [sales_orders_daily_agg.ordered_year desc]
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
      sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency:
        is_active: false
    truncate_column_names: false
    defaults_version: 1
    y_axes: []
    hidden_pivots: {}
    listen:
      Ordered Year: sales_orders_daily_agg.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders_daily_agg.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 4
    col: 0
    width: 10
    height: 7
  - title: Sales Orders
    name: Sales Orders
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders.ordered_year, sales_orders.target_currency_code, sales_orders__lines.total_sales_amount_target_currency,
      sales_orders__lines.average_ordered_amount_per_order_target_currency, sales_orders.sales_order_count,
      sales_orders.cancelled_order_count, sales_orders.non_cancelled_order_count]
    filters: {}
    sorts: [sales_orders.ordered_year desc]
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
      sales_orders__lines.total_ordered_amount_target_currency:
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
    column_order: ["$$$_row_numbers_$$$", sales_orders.ordered_year, sales_orders.target_currency_code,
      sales_orders__lines.total_sales_amount_target_currency, sales_orders__lines.average_ordered_amount_per_order_target_currency,
      sales_orders.sales_order_count, sales_orders.cancelled_order_count, sales_orders.non_cancelled_order_count]
    listen:
      Ordered Year: sales_orders.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 4
    col: 10
    width: 11
    height: 7
  - title: Amount from SalesOrders
    name: Amount from SalesOrders
    explore: sales_orders
    type: single_value
    fields: [sales_orders__lines.total_sales_amount_target_currency]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      sales_orders__lines.total_ordered_amount_target_currency:
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
      Ordered Year: sales_orders.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 0
    col: 10
    width: 7
    height: 4
  - title: Amount from DailyAgg
    name: Amount from DailyAgg
    explore: sales_orders_daily_agg
    type: single_value
    fields: [sales_orders_daily_agg__lines.total_sales_amount_target_currency]
    # filters:
    #   sales_orders_daily_agg.order_category_code: "-RETURN"
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency:
        is_active: false
    truncate_column_names: false
    defaults_version: 1
    y_axes: []
    listen:
      Ordered Year: sales_orders_daily_agg.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders_daily_agg.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 0
    col: 0
    width: 7
    height: 4
  - title: Agg by Category
    name: Agg by Category
    explore: sales_orders_daily_agg
    type: looker_grid
    fields: [sales_orders_daily_agg__lines.category_id, sales_orders_daily_agg__lines.category_description,
      sales_orders_daily_agg__lines.total_sales_amount_target_currency, sales_orders_daily_agg__lines.average_ordered_amount_per_order_target_currency]
    filters: {}
    sorts: [sales_orders_daily_agg__lines.total_sales_amount_target_currency desc]
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
      sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency:
        is_active: false
    truncate_column_names: false
    defaults_version: 1
    y_axes: []
    hidden_pivots: {}
    listen:
      Ordered Year: sales_orders_daily_agg.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders_daily_agg.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 17
    col: 0
    width: 10
    height: 6
  - title: SalesOrder by Category
    name: SalesOrder by Category
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders__lines.category_id, sales_orders__lines.category_description,
      sales_orders__lines.total_sales_amount_target_currency, sales_orders__lines.average_ordered_amount_per_order_target_currency]
    filters: {}
    sorts: [sales_orders__lines.total_sales_amount_target_currency desc]
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
      sales_orders__lines.total_ordered_amount_target_currency:
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
      Ordered Year: sales_orders.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 17
    col: 10
    width: 11
    height: 6
  - title: Daily Agg using Lines only
    name: Daily Agg using Lines only
    explore: sales_orders_daily_agg
    type: looker_grid
    fields: [sales_orders_daily_agg.ordered_year, sales_orders_daily_agg__lines.total_sales_amount_target_currency,
      sales_orders_daily_agg__lines.average_ordered_amount_per_order_target_currency,
      sales_orders_daily_agg.sales_order_count, sales_orders_daily_agg.cancelled_order_count,
      sales_orders_daily_agg.non_cancelled_order_count]
    fill_fields: [sales_orders_daily_agg.ordered_year]
    filters: {}
    sorts: [sales_orders_daily_agg.ordered_year desc]
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
      sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency:
        is_active: false
    truncate_column_names: false
    defaults_version: 1
    y_axes: []
    hidden_pivots: {}
    listen:
      Ordered Year: sales_orders_daily_agg.ordered_year
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      order_category_code: sales_orders_daily_agg.order_category_code
      # Use Test or Demo Data: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 11
    col: 0
    width: 11
    height: 6
  filters:
  - name: Ordered Year
    title: Ordered Year
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    explore: sales_orders_daily_agg
    listens_to_filters: []
    field: sales_orders_daily_agg.ordered_year
  # - name: Use Test or Demo Data
  #   title: Use Test or Demo Data
  #   type: field_filter
  #   default_value: demo
  #   allow_multiple_values: true
  #   required: false
  #   ui_config:
  #     type: button_toggles
  #     display: inline
  #   model: cortex-oracle-ebs
  #   explore: sales_orders_daily_agg
  #   listens_to_filters: []
  #   field: otc_common_parameters_xvw.parameter_use_test_or_demo_data
  - name: Target Currency
    title: Target Currency
    type: field_filter
    default_value: EUR
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: sales_orders_daily_agg
    listens_to_filters: []
    field: otc_common_parameters_xvw.parameter_target_currency

  - name: order_category_code
    title: Order Category Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.order_category_code
