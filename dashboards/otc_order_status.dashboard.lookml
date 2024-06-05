- dashboard: otc_order_status
  title: Order Status
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: otc_template

  elements:

  - title: navigation
    name: navigation
    filters:
      otc_dashboard_navigation_ext.navigation_focus_page: '1'

  - title: Total Orders
    name: Total Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.order_count,sales_orders.has_return_order_percent,sales_orders.no_holds_order_percent]
    hidden_fields: [sales_orders.has_return_order_percent,sales_orders.no_holds_order_percent]
    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders."
    row: 2
    col: 0
    width: 4
    height: 2

  - title: Return Orders
    name: Return Orders
    explore: sales_orders
    type: single_value
    # fields: [sales_orders.has_return_order_percent]
    fields: [sales_orders.order_count,sales_orders.has_return_order_percent,sales_orders.no_holds_order_percent]
    hidden_fields: [sales_orders.order_count,sales_orders.no_holds_order_percent]
    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders with a product return."
    row: 3
    col: 0
    width: 4
    height: 2

  - title: One Touch Orders
    name: One Touch Orders
    explore: sales_orders
    type: single_value
    # fields: [sales_orders.no_holds_order_percent]
    fields: [sales_orders.order_count,sales_orders.has_return_order_percent,sales_orders.no_holds_order_percent]
    hidden_fields: [sales_orders.order_count,sales_orders.has_return_order_percent]
    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders processed without any holds."
    row: 5
    col: 0
    width: 4
    height: 2

  - title: Blocked Orders
    name: Blocked Orders
    explore: sales_orders
    type: single_value
    fields: [sales_orders.order_count]
    filters:
      sales_orders.is_blocked: 'Yes'
    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders blocked (has hold or backorder)."
    row: 7
    col: 0
    width: 4
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
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 2
    col: 4
    width: 10
    height: 8

  # - name: Order Status
  #   title: Order Status
  #   explore: sales_orders
  #   type: looker_column
  #   # fields: [across_sales_and_billing_summary_xvw.order_status, sales_orders_v2.count_orders]
  #   fields: [sales_orders.open_closed_cancelled, sales_orders.order_count_with_details_link, sales_orders.max_open_closed_cancelled]
  #   pivots: [sales_orders.open_closed_cancelled]
  #   hidden_fields: [sales_orders.max_open_closed_cancelled]
  #   filters:
  #     sales_orders.open_closed_cancelled: "-NULL"
  #   sorts: [sales_orders.open_closed_cancelled]
  #   limit: 500
  #   column_limit: 50
  #   x_axis_gridlines: false
  #   y_axis_gridlines: true
  #   show_view_names: false
  #   show_y_axis_labels: true
  #   show_y_axis_ticks: true
  #   y_axis_tick_density: default
  #   y_axis_tick_density_custom: 5
  #   show_x_axis_label: true
  #   show_x_axis_ticks: false
  #   y_axis_scale_mode: linear
  #   x_axis_reversed: false
  #   y_axis_reversed: false
  #   plot_size_by_field: false
  #   trellis: ''
  #   stacking: percent
  #   limit_displayed_rows: false
  #   legend_position: center
  #   point_style: none
  #   show_value_labels: true
  #   label_density: 25
  #   x_axis_scale: auto
  #   y_axis_combined: true
  #   ordering: none
  #   show_null_labels: false
  #   show_totals_labels: false
  #   show_silhouette: false
  #   totals_color: "#808080"
  #   y_axes: [{label: '', orientation: bottom, series: [{axisId: Open - sales_orders.order_count_with_details_link,
  #           id: Open - sales_orders.order_count_with_details_link, name: Open, }, {axisId: Closed - sales_orders.order_count_with_details_link, id: Closed
  #             - sales_orders.order_count_with_details_link, name: Closed, }, {axisId: Cancelled - sales_orders.order_count_with_details_link, id: Cancelled
  #             - sales_orders.order_count_with_details_link, name: Cancelled, }], showLabels: false, showValues: false, unpinAxis: false,
  #       tickDensity: default, tickDensityCustom: 5, type: linear, }]



  #   x_axis_zoom: true
  #   y_axis_zoom: true
  #   hide_legend: true
  #   # series_colors:
  #   #   Open - sales_orders_v2.count_orders: "#98B6B1"
  #   #   Closed - sales_orders_v2.count_orders: "#BFBDC1"
  #   #   Cancelled - sales_orders_v2.count_orders: "#Eb9486"
  #   series_colors:
  #     Open - sales_orders.order_count_with_details_link: "#98B6B1"
  #     Closed - sales_orders.order_count_with_details_link: "#BFBDC1"
  #     Cancelled - sales_orders.order_count_with_details_link: "#Eb9486"

  #   advanced_vis_config: |-
  #     {
  #       plotOptions: {
  #         series: {
  #           dataLabels: {
  #             enabled: true,
  #             align: 'center',
  #             inside: true,
  #             use_html: true,
  #             format: '<span style="font-size:140%"<b>{series.name}</b></span><span style="font-weight: normal; font-size:100%; "><br><br>{point.y: ,.0f}  ({percentage:.1f}%)</span>',
  #           },
  #         },
  #       },
  #       series: [{
  #         name: 'Cancelled',
  #         dataLabels: {
  #           enabled: true,
  #           inside: true,
  #         },
  #       }, {
  #         name: 'Closed',
  #         dataLabels: {
  #           enabled: true,
  #           inside: true,
  #         },
  #       }, {
  #         name: 'Open',
  #         dataLabels: {
  #           enabled: true,
  #           inside: true,

  #         },
  #       }]
  #     }
  #   listen:
  #     Order Date: sales_orders.ordered_date
  #     Country: sales_orders.bill_to_customer_country
  #     Customer: sales_orders.bill_to_customer_name
  #     Business Unit: sales_orders.business_unit_name
  #     Order Source: sales_orders.order_source_name
  #     Item Category: sales_orders__lines.category_description
  #     Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
  #   row: 2
  #   col: 4
  #   width: 4
  #   height: 8



  # - title: Fill Rate %
  #   name: Fill Rate %
  #   explore: sales_orders_v2
  #   type: single_value
  #   fields: [sales_order_schedule_line_sdt.avg_fill_rate_item]
  #   listen:
  #     Order Date: sales_orders_v2.creation_date_erdat_date
  #     Division: divisions_md.division_name_vtext
  #     Country: countries_md.country_name_landx
  #     Sales Org: sales_organizations_md.sales_org_name_vtext
  #     Distribution Channel: distribution_channels_md.distribution_channel_name_vtext
  #     Product: materials_md.material_text_maktx
  #     Sold to: customers_md.customer_name
  #   note_state: collapsed
  #   note_display: hover
  #   note_text: "The percentage of sales orders that can be fulfilled immediately by available inventory."
  #   row: 11
  #   col: 4
  #   width: 4
  #   height: 3