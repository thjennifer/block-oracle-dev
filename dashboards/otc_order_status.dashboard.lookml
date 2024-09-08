#########################################################{
# Order Status dashboard provides an overview of order-related metrics,
# including order volume, a breakdown of the order flow status from booking to billing,
# and an analysis of order status categories (open, closed, and cancelled).
#
# Extends otc_template_orders and modifies:
#   dashboard_navigation to set parameter_navigation_focus_page: '1'
#
# Visualization Elements:
#   total_orders - single-value viz
#   return_sales_order_percent - single-value viz
#   one_touch_orders_percent - single-value viz
#   blocked_orders - single-value viz
#   bbb_funnel - looker_funnel
#   order_status_donut - looker_pie
#
# Order Counts and Percents apply chart filter order_category_code <> 'RETURN'
# Not equal to return is used in case there is a category code like MIXED
# which includes lines for orders and returns.
#
# To handle order_category_code of MIXED, amount KPIs use chart filters for both
#   order_category_code <> 'RETURN'
#   line_category_code = 'ORDER'
#
#########################################################}

- dashboard: otc_order_status
  title: Order Status
  description: "Provides an overview of order-related metrics, including order volume, a breakdown of the order flow status from booking to billing, and an analysis of order status categories (open, closed, and cancelled)."

  extends: otc_template_orders

  elements:

  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '1'
#####################################################################################################
  - name: total_sales_orders
    title: Total Sales Orders
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.sales_order_count_formatted,
              sales_orders.has_return_sales_order_percent,
              sales_orders.no_holds_order_percent,
              sales_orders.blocked_order_count]
    hidden_fields: [sales_orders.has_return_sales_order_percent,
                    sales_orders.no_holds_order_percent,
                    sales_orders.blocked_order_count]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
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
#####################################################################################################
  - name: return_sales_order_percent
    title: Return Orders
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.sales_order_count_formatted,
              sales_orders.has_return_sales_order_percent,
              sales_orders.no_holds_order_percent,
              sales_orders.blocked_order_count]
    hidden_fields: [sales_orders.sales_order_count_formatted,
                    sales_orders.no_holds_order_percent,
                    sales_orders.blocked_order_count]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
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
#####################################################################################################
  - name: no_holds_sales_order_percent
    title: One Touch Orders
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.sales_order_count_formatted,
              sales_orders.has_return_sales_order_percent,
              sales_orders.no_holds_order_percent,
              sales_orders.blocked_order_count]
    hidden_fields: [sales_orders.sales_order_count_formatted,
                    sales_orders.has_return_sales_order_percent,
                    sales_orders.blocked_order_count]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
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
#####################################################################################################
  - name: blocked_orders
    title: Blocked Orders
    explore: sales_orders
    type: single_value
    fields: [ sales_orders.sales_order_count_formatted,
              sales_orders.has_return_sales_order_percent,
              sales_orders.no_holds_order_percent,
              sales_orders.blocked_order_count]
    hidden_fields: [sales_orders.sales_order_count_formatted,
                    sales_orders.has_return_sales_order_percent,
                    sales_orders.no_holds_order_percent]
    filters:
      sales_orders.order_category_code: '-RETURN'
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    note_state: collapsed
    note_display: hover
    note_text: "The number of sales orders blocked (is on hold or has backorder)."
    row: 2
    col: 18
    width: 6
    height: 2
#####################################################################################################
  - name: bbb_funnel
    title: Booking to Billing
    explore: sales_orders_daily_agg
    type: looker_funnel
    fields: [sales_orders_daily_agg__lines.total_ordered_amount_target_currency_formatted,
             sales_orders_daily_agg__lines.total_booking_amount_target_currency_formatted,
             sales_orders_daily_agg__lines.total_backlog_amount_target_currency_formatted,
             sales_orders_daily_agg__lines.total_shipped_amount_target_currency_formatted,
             sales_orders_daily_agg__lines.total_invoiced_amount_target_currency_formatted]
    filters:
      sales_orders_daily_agg__lines.line_category_code: "ORDER"
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
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      custom:
        id: 92e66b84-021e-3146-39de-2f52135eba51
        label: Custom
        type: continuous
        stops:
        - color: "#468FAF"
          offset: 0
        - color: "#013A63"
          offset: 100
      options:
        steps: 5
        reverse: true
    isStepped: true
    labelOverlap: false
    note_state: collapsed
    note_display: hover
    note_text: |-
      Beginning with Total Sales Ordered Amount, this funnel depicts the flow of amounts across the stages of a line item:
      </br>Booking
      </br>Backlog
      </br>Shipping
      </br>Billing
    listen:
      date: sales_orders_daily_agg.ordered_date
      business_unit: sales_orders_daily_agg.business_unit_name
      customer_type: sales_orders_daily_agg.parameter_customer_type
      customer_country: sales_orders_daily_agg.selected_customer_country
      customer_name: sales_orders_daily_agg.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders_daily_agg.order_source_name
      item_category: sales_orders_daily_agg__lines.category_description
    row: 4
    col: 0
    width: 12
    height: 8
#####################################################################################################
  - name: order_status_donut
    title: Order Status
    explore: sales_orders
    type: looker_pie
    fields: [sales_orders.open_closed_cancelled, sales_orders.sales_order_count_formatted]
    filters:
      sales_orders.open_closed_cancelled: "-NULL"
      sales_orders.order_category_code: "-RETURN"
    sorts: [sales_orders.open_closed_cancelled desc]
    title_hidden: true
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
        },
        tooltip: {
          enabled: false,
        },
      }
    note_state: collapsed
    note_display: hover
    note_text: "Percent of Sales Orders by Status: Open, Cancelled, or Closed."
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_type: sales_orders.parameter_customer_type
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
    row: 4
    col: 12
    width: 12
    height: 8
