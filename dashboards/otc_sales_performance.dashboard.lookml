- dashboard: otc_sales_performance
  title: Sales Performance
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false
  description: ''

  # pull navigation bar and filters from template
  # if using navigation_focus_page parameter for active dashboard update navigation tile to use the correct filter

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
    # explore: item_md
    # field: item_md__item_descriptions.language
    explore: language_codes_sdt
    field: language_codes_sdt.language_code

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



  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '2'
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

  - name: top_products_by_sales
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
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      item_language: otc_common_parameters_xvw.parameter_language
      product_level: sales_orders__lines.parameter_display_product_level
    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Limited to 10 Products. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 2
    col: 0
    width: 12
    height: 10

  - name: top_products_by_avg_sales
    title: Top Products by Avg Sales
    explore: sales_orders
    type: looker_bar
    fields: [sales_orders__lines.selected_product_dimension_id, sales_orders__lines.selected_product_dimension_description, sales_orders__lines.average_sales_amount_per_order_target_currency]
    sorts: [sales_orders__lines.average_sales_amount_per_order_target_currency desc]
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
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      item_language: otc_common_parameters_xvw.parameter_language
      product_level: sales_orders__lines.parameter_display_product_level
    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Average Sales per Order (Target Currency).<br>Limited to 10 Products. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 2
    col: 12
    width: 12
    height: 10

  - name: top_business_units_by_sales
    title: Top Business Unit by Sales
    explore: sales_orders_daily_agg
    type: looker_bar
    fields: [sales_orders_daily_agg.business_unit_id,sales_orders_daily_agg.business_unit_name,sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted]
    sorts: [sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted desc]
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
      {sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted: "#74A09F"}
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted,
            id: sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted, name: Total
              Sales}], showLabels: true, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    listen:
      date: sales_orders_daily_agg.ordered_date
      business_unit: sales_orders_daily_agg.business_unit_name
      customer_type: sales_orders_daily_agg.parameter_customer_type
      customer_country: sales_orders_daily_agg.selected_customer_country
      customer_name: sales_orders_daily_agg.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders_daily_agg.order_source_name
      item_category: sales_orders_daily_agg__lines.category_description
    row: 20
    col: 0
    width: 12
    height: 10

  - name: top_customers_by_avg_sales
    title: Top Customers by Avg Sales
    explore: sales_orders
    type: looker_bar
    fields: [sales_orders.selected_customer_number, sales_orders.selected_customer_name, sales_orders__lines.average_sales_amount_per_order_target_currency]
    sorts: [sales_orders__lines.average_sales_amount_per_order_target_currency desc]
    hidden_fields: [sales_orders.selected_customer_number]
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
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    # note_state: expanded
    note_display: hover
    note_text: |-
      <font size="-2">Average Sales per Order (Target Currency).<br>Limited to 10 Sold to customers. To change this row limit, select "Explore from Here" option and adjust the row limit.
      </font>
    row: 20
    col: 12
    width: 12
    height: 10

  - name: sales_by_order_source
    title: Sales by Order Source
    explore: sales_orders_daily_agg
    type: looker_pie
    fields: [sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted, sales_orders_daily_agg.order_source_id,
      sales_orders_daily_agg.order_source_name]
    sorts: [sales_orders_daily_agg__lines.total_sales_amount_target_currency_formatted desc 0]
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
          text: '<br>Order<br>Source',
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
      date: sales_orders_daily_agg.ordered_date
      business_unit: sales_orders_daily_agg.business_unit_name
      customer_type: sales_orders_daily_agg.parameter_customer_type
      customer_country: sales_orders_daily_agg.selected_customer_country
      customer_name: sales_orders_daily_agg.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders_daily_agg.order_source_name
      item_category: sales_orders_daily_agg__lines.category_description
    row: 21
    col: 0
    width: 12
    height: 7
