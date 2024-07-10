- dashboard: otc_order_status_test
  title: Order Status TEST
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: otc_template_test

  filters:
    - name: Date
      title: Ordered Date

  elements:

  - title: navigation
    name: navigation
    filters:
      otc_dashboard_navigation_ext.navigation_focus_page: '1'

  - title: Total Sales Orders
    name: Total Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.selected_customer_country
      Customer: sales_orders.selected_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders."
    row: 2
    col: 0
    width: 6
    height: 2
    model: cortex-oracle-ebs-test

  - title: Return Orders
    name: Return Orders
    explore: sales_orders
    type: single_value
    # fields: [sales_orders.has_return_sales_order_percent]
    fields: [sales_orders.order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.order_count,sales_orders.no_holds_sales_order_percent]
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.selected_customer_country
      Customer: sales_orders.selected_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders with a product return."
    row: 2
    col: 6
    width: 6
    height: 2
    model: cortex-oracle-ebs-test

  - title: One Touch Orders
    name: One Touch Orders
    explore: sales_orders
    type: single_value
    # fields: [sales_orders.no_holds_sales_order_percent]
    fields: [sales_orders.order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.order_count,sales_orders.has_return_sales_order_percent]
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.selected_customer_country
      Customer: sales_orders.selected_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders processed without any holds."
    row: 2
    col: 12
    width: 6
    height: 2
    model: cortex-oracle-ebs-test

  - title: Blocked Orders
    name: Blocked Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.order_count]
    filters:
      sales_orders.is_blocked: 'Yes'
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.selected_customer_country
      Customer: sales_orders.selected_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders blocked (has hold or backorder)."
    row: 2
    col: 18
    width: 6
    height: 2
    model: cortex-oracle-ebs-test

  - title: Order Status
    name: Order Status donut
    explore: sales_orders
    type: looker_pie
    fields: [sales_orders.open_closed_cancelled, sales_orders.order_count]
    filters:
      sales_orders.open_closed_cancelled: "-NULL"
    sorts: [sales_orders.open_closed_cancelled desc]
    value_labels: labels
    label_type: labVal
    inner_radius: 60
    start_angle:
    end_angle:
    series_colors:
      Open: "#98B6B1"
      Closed: "#BFBDC1"
      Cancelled: "#EB9486"
    advanced_vis_config: |-
      {
        plotOptions: {
          pie: {
            dataLabels: {
              format: '<b>{key}</b><span style="font-weight: normal"> - <br>{percentage:.1f}%<br>{point.rendered}</span>',
            }
          }
        },
        title: {
          text: 'Order<br>Status',
          verticalAlign: 'middle',
        }
      }
    show_value_labels: false
    font_size: 12
    hidden_pivots: {}
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    legend_position: center
    point_style: none
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    title_hidden: true
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.selected_customer_country
      Customer: sales_orders.selected_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 4
    col: 12
    width: 12
    height: 8
    model: cortex-oracle-ebs-test

  - name: bbb_funnel
    title: Booking to Billed
    explore: sales_orders_daily_agg
    type: looker_funnel
    fields: [sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency_formatted,
      sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
      sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
      sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
      sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted]
    filters:
      sales_orders_daily_agg__lines.line_category_code: "-RETURN"
      sales_orders_daily_agg.order_category_code: "-RETURN"
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: false
    orientation: rows
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: inline
    # labelColorEnabled: true
    # labelColor: "#000000"
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      custom:
        id: 92e66b84-021e-3146-39de-2f52135eba51
        label: Custom
        type: continuous
        stops:
        - color: "#468faf"
          offset: 0
        - color: "#013a63"
          offset: 100
      options:
        steps: 5
        reverse: true
    isStepped: true
    labelOverlap: false
    up_color: false
    down_color: false
    total_color: "#80868B"
    show_value_labels: true
    show_x_axis_ticks: true
    show_x_axis_label: true
    x_axis_scale: auto
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_gridlines: true
    listen:
      Date: sales_orders_daily_agg.ordered_date
      Country: sales_orders_daily_agg.selected_customer_country
      Customer: sales_orders_daily_agg.selected_customer_name
      Business Unit: sales_orders_daily_agg.business_unit_name
      Order Source: sales_orders_daily_agg.order_source_name
      Item Category: sales_orders_daily_agg__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 4
    col: 0
    width: 12
    height: 8
    model: cortex-oracle-ebs-test
    # custom_color_enabled: true
    # show_single_value_title: true
    # single_value_title: Booking Amount
    # show_comparison: true
    # comparison_type: progress
    # comparison_reverse_colors: false
    # show_comparison_label: false
    # enable_conditional_formatting: false
    # conditional_formatting_include_totals: false
    # conditional_formatting_include_nulls: false
    # hidden_pivots: {}
    # hidden_fields:
    # hidden_points_if_no: []
    # x_axis_gridlines: false
    # show_view_names: false
    # y_axis_tick_density: default
    # y_axis_tick_density_custom: 5
    # y_axis_scale_mode: linear
    # x_axis_reversed: false
    # y_axis_reversed: false
    # plot_size_by_field: false
    # trellis: ''
    # stacking: ''
    # limit_displayed_rows: false
    # legend_position: center
    # point_style: none
    # label_density: 25
    # y_axis_combined: true
    # ordering: none
    # show_null_labels: false
    # show_totals_labels: false
    # show_silhouette: false
    # totals_color: "#808080"
    # defaults_version: 1
    # series_labels: {}


  # - name: Booking
  #   title: Booking Amount
  #   explore: sales_orders_daily_agg
  #   type: single_value
  #   fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency_formatted]
  #   hidden_fields: [sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted]
  #   filters:
  #     sales_orders_daily_agg__lines.line_category_code: "-RETURN"
  #     sales_orders_daily_agg.order_category_code: "-RETURN"
  #   custom_color_enabled: true
  #   show_single_value_title: true
  #   show_comparison: true
  #   comparison_type: progress_percentage
  #   comparison_reverse_colors: false
  #   show_comparison_label: false
  #   enable_conditional_formatting: false
  #   conditional_formatting_include_totals: false
  #   conditional_formatting_include_nulls: false
  #   # single_value_title: Booking Amount
  #   hidden_pivots: {}
  #   listen:
  #     Date: sales_orders.ordered_date
  #     Country: sales_orders.selected_customer_country
  #     Customer: sales_orders.selected_customer_name
  #     Business Unit: sales_orders.business_unit_name
  #     Order Source: sales_orders.order_source_name
  #     Item Category: sales_orders__lines.category_description
  #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  #   row: 2
  #   col: 16
  #   width: 8
  #   height: 3
  #   model: cortex-oracle-ebs-test

  # - name: Backlog
  #   title: Backlog Amount
  #   explore: sales_orders_daily_agg
  #   type: single_value
  #   fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency_formatted]
  #   hidden_fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted]
  #   filters:
  #     sales_orders_daily_agg__lines.line_category_code: "-RETURN"
  #     sales_orders_daily_agg.order_category_code: "-RETURN"
  #   custom_color_enabled: true
  #   show_single_value_title: true
  #   show_comparison: true
  #   # comparison_type: progress_percentage
  #   comparison_type: progress
  #   comparison_reverse_colors: false
  #   show_comparison_label: false
  #   enable_conditional_formatting: false
  #   conditional_formatting_include_totals: false
  #   conditional_formatting_include_nulls: false
  #   # single_value_title: Booking Amount
  #   hidden_pivots: {}
  #   listen:
  #     Date: sales_orders.ordered_date
  #     Country: sales_orders.selected_customer_country
  #     Customer: sales_orders.selected_customer_name
  #     Business Unit: sales_orders.business_unit_name
  #     Order Source: sales_orders.order_source_name
  #     Item Category: sales_orders__lines.category_description
  #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  #   row: 6
  #   col: 16
  #   width: 8
  #   height: 3
  #   model: cortex-oracle-ebs-test

  # - name: shipped
  #   title: Shipped Amount
  #   explore: sales_orders_daily_agg
  #   type: single_value
  #   fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency_formatted]
  #   hidden_fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted]
  #   filters:
  #     sales_orders_daily_agg__lines.line_category_code: "-RETURN"
  #     sales_orders_daily_agg.order_category_code: "-RETURN"
  #   custom_color_enabled: true
  #   show_single_value_title: true
  #   show_comparison: true
  #   # comparison_type: progress_percentage
  #   comparison_type: progress
  #   comparison_reverse_colors: false
  #   show_comparison_label: false
  #   enable_conditional_formatting: false
  #   conditional_formatting_include_totals: false
  #   conditional_formatting_include_nulls: false
  #   # single_value_title: Booking Amount
  #   hidden_pivots: {}
  #   listen:
  #     Date: sales_orders.ordered_date
  #     Country: sales_orders.selected_customer_country
  #     Customer: sales_orders.selected_customer_name
  #     Business Unit: sales_orders.business_unit_name
  #     Order Source: sales_orders.order_source_name
  #     Item Category: sales_orders__lines.category_description
  #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  #   row: 9
  #   col: 16
  #   width: 8
  #   height: 3
  #   model: cortex-oracle-ebs-test

  # - name: billed
  #   title: Billed Amount
  #   explore: sales_orders_daily_agg
  #   type: single_value
  #   fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_invoiced_amount_target_currency_formatted,
  #     sales_orders_daily_agg__lines__amounts.total_ordered_amount_target_currency_formatted]
  #   hidden_fields: [sales_orders_daily_agg__lines__amounts.total_booking_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_backlog_amount_target_currency_formatted,
  #   sales_orders_daily_agg__lines__amounts.total_shipped_amount_target_currency_formatted]
  #   filters:
  #     sales_orders_daily_agg__lines.line_category_code: "-RETURN"
  #     sales_orders_daily_agg.order_category_code: "-RETURN"
  #   custom_color_enabled: true
  #   show_single_value_title: true
  #   show_comparison: true
  #   comparison_type: progress_percentage
  #   comparison_reverse_colors: false
  #   show_comparison_label: false
  #   enable_conditional_formatting: false
  #   conditional_formatting_include_totals: false
  #   conditional_formatting_include_nulls: false
  #   # single_value_title: Booking Amount
  #   hidden_pivots: {}
  #   listen:
  #     Date: sales_orders.ordered_date
  #     Country: sales_orders.selected_customer_country
  #     Customer: sales_orders.selected_customer_name
  #     Business Unit: sales_orders.business_unit_name
  #     Order Source: sales_orders.order_source_name
  #     Item Category: sales_orders__lines.category_description
  #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  #   row: 12
  #   col: 16
  #   width: 8
  #   height: 3
  #   model: cortex-oracle-ebs-test
