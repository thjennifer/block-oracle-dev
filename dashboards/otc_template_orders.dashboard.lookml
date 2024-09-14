#########################################################{
# OTC Template for Sales Orders defines or modifies the
# following elements shared across orders-related dashboards:
#
#  - Filters including default values:
#       order_source
#       item_category
#
#  - Extends otc_template_core and modifies:
#       date to use title Ordered Date
#       dashboard_navigation with additional listeners
#
# This template must be EXTENDED into other dashboards and
# filters/elements can be modified further as necessary
#########################################################}

- dashboard: otc_template_orders
  title: OTC Template for Sales Orders
  description: "Template which defines filters and elements used on sales orders-related dashboards. Extendable and customizable."

  extension: required
  extends: otc_template_core

  filters:
  - name: date
    title: Ordered Date

  - name: order_source
    title: Order Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.order_source_name
    listens_to_filters: [business_unit]

  - name: item_category
    title: Item Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg__lines.category_description
    listens_to_filters: [business_unit]

  elements:
  - name: dashboard_navigation
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      customer_type: otc_dashboard_navigation_ext.filter3
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
      order_source: otc_dashboard_navigation_ext.filter7
      item_category: otc_dashboard_navigation_ext.filter8
