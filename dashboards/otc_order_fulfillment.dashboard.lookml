#########################################################{
# Order Fulfillment dashboard provides insights into
# fulfillment performance over time, items with longest average
# order cycle time and items having fulfillment issues.
#
# Extends otc_template_orders and modifies to:
#   add filter for item_language
#   update dashboard_navigation to:
#       listen to item_language
#       set parameter_navigation_focus_page: '3'
#
# Visualization Elements:
#   in_full - single value
#   otif - single value
#   backordered - single value
#   delivery_performance_by_month - line chart
#   average_cycle_time - bar chart
#   delivery_efficiency - column + line chart
#
# Order Counts and Percents apply chart filter order_category_code <> 'RETURN'.
# Not equal to return is used in case there is a category code like MIXED
# which includes lines for orders and returns.
#
# To handle order_category_code like MIXED, amount KPIs use chart filters for both
#   order_category_code <> 'RETURN'
#   line_category_code = 'ORDER'
#########################################################}


- dashboard: otc_order_fulfillment
  title: Order Fulfillment
  description: "See delivery performance over time, items with longest average order cycle time, and items currently having fulfillment issues."
  crossfilter_enabled: true
  extends: otc_template_orders

  filters:
  - name: item_language
    title: Language of Item Description
    type: field_filter
    default_value: "{{ _user_attributes['cortex_oracle_ebs_default_language'] }}"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    explore: item_md
    field: item_md__item_descriptions.language_code


  elements:

  - name: dashboard_navigation
    explore: sales_orders
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '3'
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      customer_type: otc_dashboard_navigation_ext.filter3
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
      order_source: otc_dashboard_navigation_ext.filter7
      item_category: otc_dashboard_navigation_ext.filter8
      item_language: otc_dashboard_navigation_ext.filter9
#####################################################################################################
  - name: in_full
    title: In Full %
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.fulfilled_order_percent,
              sales_orders.fulfilled_by_request_date_order_percent,
              sales_orders.has_backorder_order_percent]
    hidden_fields: [sales_orders.fulfilled_by_request_date_order_percent,
                    sales_orders.has_backorder_order_percent]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders that are fulfilled (inventory is reserved and ready to be shipped) completely for all order lines."
    row: 2
    col: 0
    width: 4
    height: 3
#####################################################################################################
  - name: otif
    title: OTIF %
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.fulfilled_order_percent,
              sales_orders.fulfilled_by_request_date_order_percent,
              sales_orders.has_backorder_order_percent]
    hidden_fields: [sales_orders.fulfilled_order_percent,
                    sales_orders.has_backorder_order_percent]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "On Time in Full (OTIF) is the percentage of sales orders fulfilled completely by the requested delivery date."
    row: 6
    col: 0
    width: 4
    height: 3
#####################################################################################################
  - name: backordered
    title: Backordered %
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.fulfilled_order_percent,
              sales_orders.fulfilled_by_request_date_order_percent,
              sales_orders.has_backorder_order_percent]
    hidden_fields: [sales_orders.fulfilled_order_percent,
                    sales_orders.fulfilled_by_request_date_order_percent]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The percentage of sales orders with at least one item on backorder."
    row: 9
    col: 0
    width: 4
    height: 3
#####################################################################################################
  - name: delivery_performance_by_month
    title: Delivery Performance by Month
    explore: sales_orders
    type: looker_line
    fields: [ sales_orders.ordered_month,
              sales_orders.fulfilled_order_percent_formatted,
              sales_orders.fulfilled_by_request_date_order_percent_formatted]
    sorts: [sales_orders.ordered_month]
    filters:
      sales_orders.order_category_code: '-RETURN'
    limit: 500
    legend_position: center
    point_style: none
    show_null_points: false
    interpolation: linear
    x_axis_label: Month
    series_types:
      sales_orders.fulfilled_order_percent_formatted: line
      sales_orders.fulfilled_by_request_date_order_percent_formatted: line
    series_colors:
      sales_orders.fulfilled_order_percent_formatted: "#6494AA"
      sales_orders.fulfilled_by_request_date_order_percent_formatted: "#89BD9E"
    series_labels:
      sales_orders.fulfilled_order_percent_formatted: In Full %
      sales_orders.fulfilled_by_request_date_order_percent_formatted: OTIF %
    x_axis_datetime_label: "%B %y"
    advanced_vis_config: |-
      {
        tooltip: {
          format: '<table><th style="font-size: 1.8em;text-align: left;color: #808080; ">{key}</th></table><table>{#each points}<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:.1f}%</td></tr>{/each}',
          footerFormat: '</table>',
          shared: true,
          crosshairs: true,
          shadow: true,
          borderColor: '#CCCCCC',
          backgroundColor: '#FFFFFF',
        },
        yAxis: {
          labels: {
            format: '{text}%' ,
          },
          ceiling: 102,
          endOnTick: false,
          maxPadding: 0.2,
        },
      }
    note_state: collapsed
    note_display: hover
    note_text: "Monthly tracking of order fulfillment and on-time delivery. In Full % is the percentage of sales orders where all order lines have been fulfilled (inventory has been reserved and is ready for shipment). On Time in Full (OTIF) % is the percentage of sales orders that have been fulfilled completely by the requested delivery date."
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    row: 2
    col: 4
    width: 10
    height: 9
#####################################################################################################
  - name: average_cycle_time
    title: Longest Average Order Cycle Time
    explore: sales_orders
    type: looker_bar
    fields: [ sales_orders__lines.selected_product_dimension_id,
              sales_orders__lines.selected_product_dimension_description,
              sales_orders__lines.average_cycle_time_days]
    sorts: [sales_orders__lines.average_cycle_time_days desc]
    hidden_fields: [sales_orders__lines.selected_product_dimension_id]
    filters:
      sales_orders.order_category_code: '-RETURN'
      sales_orders__lines.line_category_code: 'ORDER'
      sales_orders__lines.is_fulfilled: "Yes"
      sales_orders__lines.is_cancelled: "No"
      sales_orders__lines.parameter_display_product_level: "Item"
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    legend_position: center
    point_style: none
    show_value_labels: false
    y_axes: [{label: Average Order Cycle Time, orientation: bottom,
            series: [{axisId: sales_orders__lines.average_cycle_time_days,
                          id: sales_orders__lines.average_cycle_time_days,
                          name: Average of Order Cycle Time}], showLabels: false, showValues: false,
        tickDensity: custom, tickDensityCustom: 1, type: linear}]
    x_axis_label: ""
    series_colors:
      sales_orders__lines.average_cycle_time_days: "#B3DEE2"
    reference_lines: [{reference_type: line, range_start: min, range_end: max, margin_top: deviation,
      margin_value: mean, margin_bottom: deviation, label_position: left, color: "#000000",
      label: '', line_value: max}, {reference_type: line, line_value: min, range_start: max,
      range_end: min, margin_top: deviation, margin_value: mean, margin_bottom: deviation,
      label_position: right, color: "#000000"}]
    advanced_vis_config: |-
      {
      tooltip: {
        format: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{key}</th></table><table>{#each points}<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:.1f}</td></tr>{/each}',
        footerFormat: '</table>',
        shared: true,
        crosshairs: true,
        borderColor: '#CCCCCC',
        backgroundColor: '#FFFFFF',
        shadow: true,
      },
      yAxis: [{
        plotLines: [{
            color: '#transparent',
            label: {
              align: 'right',
              verticalAlign: 'top',
              x: -5,
              y: 2,
            },
          },
          {
            color: '#transparent',
            label: {
              align: 'left',
              verticalAlign: 'bottom',
              x: 0,
              y: -1,
            },
          },
        ]
      }, ],
      }
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      item_language: otc_common_parameters_xvw.parameter_language
    note_state: collapsed
    note_display: hover
    note_text: "Top 10 Items with longest average order cycle times. Order cycle time is the average number of days between order placement and order fulfillment."
    row: 2
    col: 14
    width: 10
    height: 9
#####################################################################################################
  - name: delivery_efficiency
    title: Order vs Fulfillment Efficiency
    explore: sales_orders
    type: looker_line
    fields: [ sales_orders__lines.inventory_item_id,
              sales_orders__lines.item_description,
              sales_orders__lines.total_ordered_quantity_by_item_formatted,
              sales_orders__lines.total_fulfilled_quantity_by_item_formatted,
              sales_orders__lines.difference_ordered_fulfilled_quantity_by_item]
    sorts: [sales_orders__lines.difference_ordered_fulfilled_quantity_by_item desc]
    hidden_fields: [sales_orders__lines.inventory_item_id]
    filters:
      sales_orders.order_category_code: '-RETURN'
      sales_orders__lines.line_category_code: 'ORDER'
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    show_null_points: true
    interpolation: step
    y_axes: [{label: 'Quantities', orientation: left,
              series: [{axisId: sales_orders__lines.total_ordered_quantity_by_item_formatted,
                            id: sales_orders__lines.total_ordered_quantity_by_item_formatted,
                          name: Total Ordered Quantity},
                      {axisId: sales_orders__lines.total_fulfilled_quantity_by_item_formatted,
                           id: sales_orders__lines.total_fulfilled_quantity_by_item_formatted,
                         name: Total Fulfilled Quantity}], showLabels: true, showValues: true, },
            {label: 'Difference', orientation: right,
              series: [{axisId: sales_orders__lines.difference_ordered_fulfilled_quantity_by_item,
                            id: sales_orders__lines.difference_ordered_fulfilled_quantity_by_item,
                          name: Difference Ordered Fulfilled Quantity By Item}], showLabels: true, showValues: true,}]
    x_axis_label: Item
    series_types:
      sales_orders__lines.total_ordered_quantity_by_item_formatted: column
      sales_orders__lines.total_fulfilled_quantity_by_item_formatted: column
      sales_orders__lines.difference_ordered_fulfilled_quantity_by_item: line
    series_colors:
      sales_orders__lines.total_ordered_quantity_by_item_formatted: "#12B5CB"
      sales_orders__lines.total_fulfilled_quantity_by_item_formatted: "#A6CFD5"
      sales_orders__lines.difference_ordered_fulfilled_quantity_by_item: "#404040"
    series_labels:
      sales_orders__lines.total_ordered_quantity_by_item_formatted: Total Ordered Quantity
      sales_orders__lines.total_fulfilled_quantity_by_item_formatted: Total Fulfilled Quantity
    x_axis_label_rotation: 0
    advanced_vis_config: |-
      {
        chart: {
          spacingBottom: 60,
        },
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
          name: 'Difference',
          lineWidth: 1,
          },
        ],
        legend: {
          verticalAlign: 'top',
        },
        tooltip: {
          format: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{key}</th></table><table>{#each points}<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f}</td></tr>{/each}',
          footerFormat: '</table>',
          shared: true,
          crosshairs: true,
          borderColor: '#CCCCCC',
          backgroundColor: '#FFFFFF',
          shadow: true,
        },
        xAxis: {
          crosshair: true,
          labels: {
            angle: 0,
            style: {
              cursor: 'pointer',
              fontSize: '11px',
              color: 'inherit',
              textOverflow: 'none',
            },
          },
        },
      }
    note_state: collapsed
    note_display: above
    note_text: "Top 10 Items with Largest Difference between Quantity Ordered and Fulfilled"
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      item_language: otc_common_parameters_xvw.parameter_language
    row: 10
    col: 0
    width: 24
    height: 12
