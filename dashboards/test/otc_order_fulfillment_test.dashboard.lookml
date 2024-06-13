- dashboard: otc_order_fulfillment_test
  title: Order Fulfillment TEST
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: otc_template_test

  filters:
  - name: Date
    title: Ordered Date

  - name: Language
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
    listens_to_filters: [Test or Demo]


  elements:

  - title: navigation
    name: navigation
    filters:
      otc_dashboard_navigation_ext.navigation_focus_page: '3'

  - title: In Full %
    name: In Full %
    explore: sales_orders
    type: single_value
    fields: [sales_orders.fulfilled_sales_order_percent, sales_orders.fulfilled_by_request_date_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    hidden_fields: [sales_orders.fulfilled_by_request_date_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely (all order lines are fulfilled)."
    row: 2
    col: 0
    width: 4
    height: 3

  - title: OTIF %
    name: OTIF %
    explore: sales_orders
    type: single_value
    fields: [sales_orders.fulfilled_sales_order_percent, sales_orders.fulfilled_by_request_date_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    hidden_fields: [sales_orders.fulfilled_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders fulfilled completely (for all line items) by the requested delivery date."
    row: 6
    col: 0
    width: 4
    height: 3

  - title: Backordered %
    name: Backordered %
    explore: sales_orders
    type: single_value
    fields: [sales_orders.fulfilled_sales_order_percent, sales_orders.fulfilled_by_request_date_sales_order_percent,sales_orders.has_backorder_sales_order_percent]
    hidden_fields: [sales_orders.fulfilled_sales_order_percent,sales_orders.fulfilled_by_request_date_sales_order_percent]
    # enable_conditional_formatting: true
    # conditional_formatting: [{type: greater than, value: 0.05, background_color: '',
    #     font_color: "#DB4C40", bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders with at least one item on backorder."
    row: 9
    col: 0
    width: 4
    height: 3

  - title: Delivery Performance by Month
    name: Delivery Performance by Month
    explore: sales_orders
    type: looker_line
    fields: [sales_orders.ordered_month,sales_orders.fulfilled_sales_order_percent,sales_orders.fulfilled_by_request_date_sales_order_percent]
    sorts: [sales_orders.ordered_month]
    limit: 500
    column_limit: 50
    legend_position: center
    point_style: none
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: []
    x_axis_label: Month
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      sales_orders.fulfilled_sales_order_percent: line
      sales_orders.fulfilled_by_request_date_sales_order_percent: line
    series_colors:
      # sales_order_item_delivery_summary_ndt.percent_orders_delivered_on_time: "#F39B6D"
      sales_orders.fulfilled_sales_order_percent: "#6494AA"
      sales_orders.fulfilled_by_request_date_sales_order_percent: "#89BD9E"
    series_labels:
      # sales_order_item_delivery_summary_ndt.percent_orders_delivered_on_time: On Time %
      # sales_orders.ordered_month
      sales_orders.fulfilled_sales_order_percent: In Full %
      sales_orders.fulfilled_by_request_date_sales_order_percent: OTIF %
    x_axis_datetime_label: "%B %y"
    defaults_version: 1
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 2
    col: 4
    width: 10
    height: 9

  - title: Longest Average Order Cycle Time (Days)
    name: Longest Average Order Cycle Time
    explore: sales_orders
    type: looker_bar
    # fields: [sales_orders__lines.inventory_item_id,sales_orders__lines.item_description, sales_orders__lines.average_cycle_time_days]
    # sorts: [sales_orders__lines.average_cycle_time_days desc]
    # hidden_fields: [sales_orders__lines.inventory_item_id]
    fields: [sales_orders__lines.selected_product_dimension_id,sales_orders__lines.selected_product_dimension_description, sales_orders__lines.average_cycle_time_days]
    sorts: [sales_orders__lines.average_cycle_time_days desc]
    hidden_fields: [sales_orders__lines.selected_product_dimension_id]
    filters:
      sales_orders__lines.average_cycle_time_days: ">0"
      sales_orders__lines.parameter_display_product_level: "Item"
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    limit_displayed_rows: true
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
    y_axes: [{label: Average Order Cycle Time, orientation: bottom, series: [{axisId: sales_orders__lines.average_cycle_time_days,
            id: sales_orders__lines.average_cycle_time_days, name: Average
              of Order Cycle Time}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: custom, tickDensityCustom: 1, type: linear}]
    x_axis_label: ""
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_colors:
      sales_orders__lines.average_cycle_time_days: "#B3DEE2"
    reference_lines: [{reference_type: line, range_start: min, range_end: max, margin_top: deviation,
      margin_value: mean, margin_bottom: deviation, label_position: left, color: "#000000",
      label: '', line_value: max}, {reference_type: line, line_value: min, range_start: max,
      range_end: min, margin_top: deviation, margin_value: mean, margin_bottom: deviation,
      label_position: right, color: "#000000"}]
    advanced_vis_config: "{\n  yAxis: [{\n \n    plotLines: [{\n        color: '#transparent',\n\
        \        label: {\n          align: 'center',\n          verticalAlign: 'top',\n\
        \          x: -5,\n          y: 2,\n        },\n    \n      },\n      {\n  \
        \      color: '#transparent',\n        label: {\n          align: 'center',\n\
        \          verticalAlign: 'bottom',\n          x: 0,\n          y: -1,\n   \
        \     },\n        \n      },\n    ],\n    \n\n  }, ],\n}"
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
      Language: otc_common_parameters_xvw.parameter_language
      # Product Level to Display: sales_orders__lines.parameter_display_product_level
    note_state: collapsed
    note_display: hover
    note_text: "Order cycle time is average number of days between order placement and order fulfillment. "
    row: 2
    col: 14
    width: 10
    height: 9



  - title: Order vs Fulfillment Efficiency
    name: Order vs Fulfillment Efficiency
    explore: sales_orders
    type: looker_line
    # type: looker_bar
    fields: [sales_orders__lines.inventory_item_id, sales_orders__lines.item_description,
    sales_orders__lines.total_ordered_quantity_by_item, sales_orders__lines.total_fulfilled_quantity_by_item,
    sales_orders__lines.difference_ordered_fulfilled_quantity_by_item]
    sorts: [sales_orders__lines.difference_ordered_fulfilled_quantity_by_item desc]
    hidden_fields: [sales_orders__lines.inventory_item_id]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: step
    # y_axes: [{label: '', orientation: left, series: [{axisId: sales_orders__lines.total_ordered_quantity_by_item,
    #       id: sales_orders__lines.total_ordered_quantity_by_item, name: Total Ordered Quantity}, {axisId: sales_orders__lines.total_fulfilled_quantity_by_item,
    #       id: sales_orders__lines.total_fulfilled_quantity_by_item, name: Total Fulfilled Quantity},
    #     {axisId: sales_orders__lines.difference_ordered_fulfilled_quantity_by_item,
    #       id: sales_orders__lines.difference_ordered_fulfilled_quantity_by_item,
    #       name: Difference Ordered Quantity minus Fulfilled Quantity}], showLabels: true, showValues: true,
    #   unpinAxis: false, tickDensity: default, type: linear}]
    y_axes: [{label: 'Quantities', orientation: left, series: [{axisId: sales_orders__lines.total_ordered_quantity_by_item,
          id: sales_orders__lines.total_ordered_quantity_by_item, name: Total Ordered
            Quantity}, {axisId: sales_orders__lines.total_fulfilled_quantity_by_item,
          id: sales_orders__lines.total_fulfilled_quantity_by_item, name: Total Fulfilled
            Quantity}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
      type: linear}, {label: 'Difference', orientation: right, series: [{axisId: sales_orders__lines.difference_ordered_fulfilled_quantity_by_item,
          id: sales_orders__lines.difference_ordered_fulfilled_quantity_by_item, name: Difference
            Ordered Fulfilled Quantity By Item}], showLabels: true, showValues: true,
      unpinAxis: false, tickDensity: default, type: linear}]
    x_axis_label: Item
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    hidden_series: []
    series_types:
      sales_orders__lines.total_ordered_quantity_by_item: column
      sales_orders__lines.total_fulfilled_quantity_by_item: column
      sales_orders__lines.difference_ordered_fulfilled_quantity_by_item: line
    series_colors:
      sales_orders__lines.total_ordered_quantity_by_item: "#12B5CB"
      sales_orders__lines.total_fulfilled_quantity_by_item: "#A6CFD5"
      sales_orders__lines.difference_ordered_fulfilled_quantity_by_item: "#596157"
    series_labels:
      sales_orders__lines.total_ordered_quantity_by_item: Total Ordered Quantity
      sales_orders__lines.total_fulfilled_quantity_by_item: Total Fulfilled Quantity
    label_color: []
    reference_lines: []
    x_axis_label_rotation: 0
    advanced_vis_config: |-
      {
        chart: {},
        series: [{
          name: 'Total Ordered Quantity',
          dataLabels: {
            enabled: false,
          }
        }, {
          name: 'Total Fulfilled Quantity',
          dataLabels: {
            enabled: false,
          }
        },
        {
          name: 'Difference'
        },]
      }
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    note_state: collapsed
    note_display: above
    note_text: Top 10 Items with Largest Difference between Quantity Ordered and Fulfilled
    listen:
      Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
      Language: otc_common_parameters_xvw.parameter_language
    row: 10
    col: 0
    width: 24
    height: 12
