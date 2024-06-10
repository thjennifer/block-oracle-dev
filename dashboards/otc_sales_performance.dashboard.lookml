- dashboard: otc_sales_performance
  title: Sales Performance
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter
  extends: otc_template

  filters:
  - name: Product Level to Display
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
      otc_dashboard_navigation_ext.navigation_focus_page: '2'


  - name: Top Products by Sales
    title: Top Products by Sales
    explore: sales_orders
    type: looker_bar
    fields: [sales_orders__lines.selected_product_dimension_id, sales_orders__lines.selected_product_dimension_description, sales_orders__lines.total_sales_amount_target_currency_format_large_numbers]
    sorts: [sales_orders__lines.total_sales_amount_target_currency_format_large_numbers desc]
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
      {sales_orders__lines.total_sales_amount_target_currency_format_large_numbers: "#74A09F"}
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_orders__lines.total_sales_amount_target_currency_format_large_numbers,
            id: sales_orders__lines.total_sales_amount_target_currency_format_large_numbers
            }], showLabels: true, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true

    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
      Product Level to Display: sales_orders__lines.parameter_display_product_level
      Language: otc_common_parameters_xvw.parameter_language

    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Limited to 10 Products. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 2
    col: 0
    width: 10
    height: 10

  - name: Top Products by Avg Sales
    title: Top Products by Avg Sales
    explore: sales_orders
    type: looker_bar
    fields: [sales_orders__lines.selected_product_dimension_id, sales_orders__lines.selected_product_dimension_description, sales_orders__lines.average_sales_amount_per_order_target_currency]
    sorts: [sales_orders__lines.average_sales_amount_per_order_target_currency desc]
    hidden_fields: [sales_orders__lines.selected_product_dimension_id]

    # filters:
    #   sales_orders_v2.count_orders: ">=10"
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: false
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    series_colors:
      {sales_orders__lines.average_sales_amount_per_order_target_currency: "#53575E"}

    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_orders__lines.average_sales_amount_per_order_target_currency,
            id: sales_orders__lines.average_sales_amount_per_order_target_currency, name: Avg Sales per Order}], showLabels: true, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
      Product Level to Display: sales_orders__lines.parameter_display_product_level
      Language: otc_common_parameters_xvw.parameter_language
    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Average Sales per Order (Target Currency).<br>Limited to 10 Products. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 2
    col: 11
    width: 10
    height: 10

  - name: Top Business Unit by Sales
    title: Top Business Unit by Sales
    explore: sales_orders_daily_agg
    type: looker_bar
    fields: [sales_orders_daily_agg.business_unit_id,sales_orders_daily_agg.business_unit_name,sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numbers]
    sorts: [sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numbers desc]
    hidden_fields: [sales_orders_daily_agg.business_unit_id]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: false
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    series_colors:
      {sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numbers: "#74A09F"}
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numbers,
            id: sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numberst, name: Total
              Sales}], showLabels: true, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    listen:
      Order Date: sales_orders_daily_agg.ordered_date
      Country: sales_orders_daily_agg.bill_to_customer_country
      Customer: sales_orders_daily_agg.bill_to_customer_name
      Business Unit: sales_orders_daily_agg.business_unit_name
      Order Source: sales_orders_daily_agg.order_source_name
      Item Category: sales_orders_daily_agg__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data

    row: 20
    col: 0
    width: 10
    height: 10

  - name: Top Customers by Avg Sales
    title: Top Customers by Avg Sales
    explore: sales_orders
    type: looker_bar
    fields: [sales_orders.bill_to_customer_number, sales_orders.bill_to_customer_name, sales_orders__lines.average_sales_amount_per_order_target_currency]
    sorts: [sales_orders__lines.average_sales_amount_per_order_target_currency desc]
    hidden_fields: [sales_orders.bill_to_customer_number]
    # filters:
    #   sales_orders_v2.count_orders: ">=10"
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: false
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    series_colors:
      {sales_orders__lines.average_sales_amount_per_order_target_currency: "#53575E"}
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_orders__lines.average_sales_amount_per_order_target_currency,
            id: sales_orders__lines.average_sales_amount_per_order_target_currency
    }], showLabels: true, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    listen:
      Order Date: sales_orders.ordered_date
      Country: sales_orders.bill_to_customer_country
      Customer: sales_orders.bill_to_customer_name
      Business Unit: sales_orders.business_unit_name
      Order Source: sales_orders.order_source_name
      Item Category: sales_orders__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Average Sales per Order (Target Currency).<br>Limited to 10 Sold to customers. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 20
    col: 11
    width: 10
    height: 10

  - name: Sales by Order Source
    title: Sales by Order Source
    explore: sales_orders_daily_agg
    type: looker_pie
    fields: [sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numbers, sales_orders_daily_agg.order_source_id,
      sales_orders_daily_agg.order_source_name]
    sorts: [sales_orders_daily_agg__lines.total_sales_amount_target_currency_format_large_numbers desc 0]
    hidden_fields: [sales_orders_daily_agg.order_source_id]
    limit: 50
    column_limit: 50
    value_labels: labels
    label_type: labVal
    inner_radius: 50
    color_application:
      collection_id: 9d1da669-a6b4-4a4f-8519-3ea8723b79b5
      palette_id: 0c5264fb-0681-4817-b9a5-d3c81002ce4c
      options:
        steps: 5
        reverse: true
    series_colors: {}
    advanced_vis_config: |-
      {
        plotOptions: {
          pie: {
            dataLabels: {
              style: {
                fontSize: '100%'
              },
              enabled: true,
              format: '<b>{key}</b><span style="font-size: 80%; font-weight: normal"> <br>{percentage:.1f}%<br>{point.rendered}</span>',
            }
          }
        },
        title: {
          text: 'Order<br>Source',
          verticalAlign: 'middle',
          align: 'center',
          y: 10,
          x: -5,
          style: {
                fontSize: '120%',
                fontWeight: 'bold',
              },
        }
      }
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    defaults_version: 1
    hidden_pivots: {}
    title_hidden: true
    listen:
      Order Date: sales_orders_daily_agg.ordered_date
      Country: sales_orders_daily_agg.bill_to_customer_country
      Customer: sales_orders_daily_agg.bill_to_customer_name
      Business Unit: sales_orders_daily_agg.business_unit_name
      Order Source: sales_orders_daily_agg.order_source_name
      Item Category: sales_orders_daily_agg__lines.category_description
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_test_or_demo_data
    row: 21
    col: 0
    width: 10
    height: 7
