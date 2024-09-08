#########################################################{
# Order Line Details dashboard provides
# a table of orders including details like customer, items,
# ordered quantities and amounts.
#
# This dashboard is accessed through drills from select KPIs.
#
# Extends otc_template_orders and modifies to:
#   add filters to support KPI-specific drills
#   update dashboard_navigation to:
#       listen to item_language
#       set parameter_navigation_focus_page: '4'
#       set parameter_navigation_subject: 'odetails'
#
# Visualization Elements:
#   order_line_item_table
#
#########################################################}

- dashboard: otc_order_line_item_details
  title: Order Line Details
  description: 'Provides a table of orders including details like customer, items, ordered quantities and amounts.'


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

  - name: order_status
    title: Order Status
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders.open_closed_cancelled

  - name: is_fulfilled
    title: Is Fulfilled (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders.is_fulfilled

  - name: is_fulfilled_by_request_date
    title: Is Fulfilled by Request Date (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders.is_fulfilled_by_request_date

  - name: has_return
    title: Has Return (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders.has_return_line

  - name: is_blocked
    title: Is Blocked (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders.is_blocked

  - name: is_booking
    title: Line Item Is in Booking (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders__lines.is_booking

  - name: is_backlog
    title: Line Item in Backlog (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders__lines.is_backlog

  - name: is_backordered
    title: Line Item is Backordered (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders__lines.is_backordered

  - name: order_category_code
    title: Order Category Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
    explore: sales_orders
    field: sales_orders.order_category_code

  - name: line_category_code
    title: Line Category Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_orders
    field: sales_orders__lines.line_category_code

  - name: order_number
    title: Order Number
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders
    field: sales_orders.order_number
    listens_to_filters: [business_unit_name, customer_country, customer_name]

  - name: line_id
    title: Line ID
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders
    field: sales_orders__lines.line_id
    listens_to_filters: [business_unit_name, customer_country, customer_name]

  - name: item_description
    title: Item Description
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_orders
    field: sales_orders__lines.item_description
    listens_to_filters: [item_language, category_description]


  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_subject: 'odetails'
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '4'
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

  - name: order_line_item_table
    title: Orders with Line Item Details
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders.order_number,
            sales_orders.order_category_code,
            sales_orders.open_closed_cancelled_with_symbols,
            sales_orders.is_fulfilled_with_symbols,
            sales_orders.is_blocked_with_symbols,
            sales_orders.has_return_line_with_symbols,
            sales_orders.total_sales_amount_target_currency,
            sales_orders__lines.line_id,
            sales_orders__lines.line_number,
            sales_orders__lines.item_part_number,
            sales_orders__lines.item_description,
            sales_orders.selected_customer_name,
            sales_orders.ordered_date,
            sales_orders__lines.ordered_quantity,
            sales_orders__lines.quantity_uom,
            sales_orders__lines.fulfilled_quantity,
            sales_orders__lines.unit_list_price_target_currency,
            sales_orders__lines.unit_discount_amount_target_currency,
            sales_orders__lines.unit_selling_price_target_currency,
            sales_orders__lines.ordered_amount_target_currency,
            sales_orders__lines.fulfilled_amount_target_currency,
            sales_orders.currency_conversion_rate,
            sales_orders__lines.has_return_with_symbols,
            sales_orders__lines.is_backlog_with_symbols,
            sales_orders__lines.is_booking_with_symbols,
            sales_orders__lines.is_backordered_with_symbols]
    sorts: [sales_orders.order_number, sales_orders__lines.line_number]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: false
    show_row_totals: false
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      sales_orders.open_closed_cancelled_with_symbols: Order Status
      sales_orders.is_fulfilled_with_symbols: Is Fulfilled
      sales_orders.is_blocked_with_symbols: Is Blocked
      sales_orders.has_return_line_with_symbols: Has Return
      sales_orders__lines.has_return_with_symbols: Item Returned
      sales_orders__lines.is_backlog_with_symbols: Item in Backlog
      sales_orders__lines.is_booking_with_symbols: Item in Booking
      sales_orders__lines.is_backordered_with_symbols: Item is Backordered
    series_text_format:
      sales_orders.open_closed_cancelled_with_symbols:
        align: center
      sales_orders.is_fulfilled_with_symbols:
        align: center
      sales_orders.is_blocked_with_symbols:
        align: center
      sales_orders.has_return_line_with_symbols:
        align: center
      sales_orders__lines.has_return_with_symbols:
        align: center
      sales_orders__lines.is_backlog_with_symbols:
        align: center
      sales_orders__lines.is_booking_with_symbols:
        align: center
      sales_orders__lines.is_backordered_with_symbols:
        align: center
    series_column_widths:
      sales_orders__lines.item_description: 250

    note_state: collapsed
    note_display: below
    note_text: |-
      <div style=text-align:left;font-size:11px;color:#808080;">
      In Sales Orders, discounts are determined by deducting the pre-tax Unit Selling Price from the pre-tax Unit List Price. This method differs from Sales Invoices, where the post-tax prices are used.
      </div>
    listen:
        date: sales_orders.ordered_date
        business_unit: sales_orders.business_unit_name
        customer_country: sales_orders.selected_customer_country
        customer_name: sales_orders.selected_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_orders.order_source_name
        item_category: sales_orders__lines.category_description
        item_language: otc_common_parameters_xvw.parameter_language
        order_status: sales_orders.open_closed_cancelled
        has_return: sales_orders.has_return_line
        is_blocked: sales_orders.is_blocked
        is_fulfilled: sales_orders.is_fulfilled
        is_fulfilled_by_request_date: sales_orders.is_fulfilled_by_request_date
        is_booking: sales_orders__lines.is_booking
        is_backlog: sales_orders__lines.is_backlog
        is_backordered: sales_orders__lines.is_backordered
        order_category_code: sales_orders.order_category_code
        line_category_code: sales_orders__lines.line_category_code
        order_number: sales_orders.order_number
        line_id: sales_orders__lines.line_id
        item_description: sales_orders__lines.item_description
    row: 0
    col: 0
    width: 24
    height: 16

  - name: summary
    title: Summary
    explore: sales_orders
    type: looker_grid
    fields: [ sales_orders.sales_order_count,
              sales_orders.fulfilled_order_count,
              sales_orders.blocked_order_count,
              sales_orders.has_return_sales_order_count,
              sales_orders__lines.count_order_lines,
              sales_orders__lines.total_sales_amount_target_currency,
              sales_orders__lines.total_fulfilled_amount_target_currency]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: unstyled
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: right
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: false
    show_row_totals: false
    truncate_header: false
    minimum_column_width: 30
    series_cell_visualizations:
      sales_orders.sales_order_count:
        is_active: false
    listen:
        date: sales_orders.ordered_date
        business_unit: sales_orders.business_unit_name
        customer_country: sales_orders.selected_customer_country
        customer_name: sales_orders.selected_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_orders.order_source_name
        item_category: sales_orders__lines.category_description
        item_language: otc_common_parameters_xvw.parameter_language
        order_status: sales_orders.open_closed_cancelled
        has_return: sales_orders.has_return_line
        is_blocked: sales_orders.is_blocked
        is_fulfilled: sales_orders.is_fulfilled
        is_fulfilled_by_request_date: sales_orders.is_fulfilled_by_request_date
        is_booking: sales_orders__lines.is_booking
        is_backlog: sales_orders__lines.is_backlog
        is_backordered: sales_orders__lines.is_backordered
        order_category_code: sales_orders.order_category_code
        line_category_code: sales_orders__lines.line_category_code
        order_number: sales_orders.order_number
        line_id: sales_orders__lines.line_id
        item_description: sales_orders__lines.item_description
    row: 13
    col: 0
    width: 24
    height: 2
