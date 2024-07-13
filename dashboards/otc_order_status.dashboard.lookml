- dashboard: otc_order_status
  title: Order Status
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: otc_template_orders

  elements:

  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '1'

  - name: total_orders
    title: Total Sales Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.sales_order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      # customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders."
    row: 2
    col: 0
    width: 6
    height: 2

  - name: return_orders
    title: Return Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.sales_order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.sales_order_count,sales_orders.no_holds_sales_order_percent]
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      # customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders with a product return."
    row: 2
    col: 6
    width: 6
    height: 2

  - name: one_touch_orders
    title: One Touch Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.sales_order_count,sales_orders.has_return_sales_order_percent,sales_orders.no_holds_sales_order_percent]
    hidden_fields: [sales_orders.sales_order_count,sales_orders.has_return_sales_order_percent]
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      # customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders processed without any holds."
    row: 2
    col: 12
    width: 6
    height: 2

  - name: blocked_orders
    title: Blocked Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.order_count]
    filters:
      sales_orders.is_blocked: 'Yes'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      # customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders blocked (has hold or backorder)."
    row: 2
    col: 18
    width: 6
    height: 2

  - name: bbb_funnel
    title: Booking to Billed
    explore: sales_orders_daily_agg
    type: looker_funnel
    fields: [sales_orders_daily_agg__lines.total_ordered_amount_target_currency_formatted,
      sales_orders_daily_agg__lines.total_booking_amount_target_currency_formatted,
      sales_orders_daily_agg__lines.total_backlog_amount_target_currency_formatted,
      sales_orders_daily_agg__lines.total_shipped_amount_target_currency_formatted,
      sales_orders_daily_agg__lines.total_invoiced_amount_target_currency_formatted]
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
      date: sales_orders_daily_agg.ordered_date
      business_unit: sales_orders_daily_agg.business_unit_name
      # customer_type: sales_orders_daily_agg.parameter_customer_type
      customer_country: sales_orders_daily_agg.selected_customer_country
      customer_name: sales_orders_daily_agg.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders_daily_agg.order_source_name
      item_category: sales_orders_daily_agg__lines.category_description
    row: 4
    col: 0
    width: 12
    height: 8

  - name: order_status_donut
    title: Order Status
    explore: sales_orders
    type: looker_pie
    fields: [sales_orders.open_closed_cancelled, sales_orders.order_count]
    filters:
      sales_orders.open_closed_cancelled: "-NULL"
      sales_orders.order_category_code: "-RETURN"
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
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      # customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    row: 4
    col: 12
    width: 12
    height: 8
