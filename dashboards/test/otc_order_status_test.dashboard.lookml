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
    row: 3
    col: 0
    width: 6
    height: 2

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
    row: 5
    col: 0
    width: 6
    height: 2

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
    row: 7
    col: 0
    width: 6
    height: 2

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
    row: 2
    col: 6
    width: 10
    height: 8
