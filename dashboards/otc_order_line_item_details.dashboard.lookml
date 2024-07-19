- dashboard: otc_order_line_item_details
  title: Order Details with Line Items


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

  # - name: is_discounted
  #   title: Is Discounted Item (Yes / No)
  #   type: field_filter
  #   default_value: ''
  #   allow_multiple_values: true
  #   required: false
  #   ui_config:
  #     type: button_group
  #     display: inline
  #   explore: sales_invoices
  #   field: sales_invoices__lines.is_discount_selling_price

  # - name: is_intercompany
  #   title: Is Intercompany (Yes / No)
  #   type: field_filter
  #   default_value: ''
  #   allow_multiple_values: true
  #   required: false
  #   ui_config:
  #     type: button_group
  #     display: inline
  #   explore: sales_invoices
  #   field: sales_invoices__lines.is_intercompany



  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_subject: 'orders'
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '4'

    # Order Type / Status (open, delivered, blocked, canceled, return)
# OrderID
# ItemID
# Product
# Customer (Sold To / Ship To / Billed To parties)
# Order Date (Creation Date)
# Item Ordered Quantity with Unit of Measure
# Item Fulfilled Quantity (inventory is reserved and ready to be shipped)
# Item List Price (per Unit)
# Item Discount Amount
# Item Net Price (after discount)
# Item Ordered Amount (Item Net Price multiplied by Item Quantity)
# Item Fulfilled Amount (Item Net Price multiplied by Item Quantity where item is fulfilled)
# Target Currency & Exchange Rate

  - name: order_line_item_table
    title: Orders with Line Item Details
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders.order_number, sales_orders.open_closed_cancelled_with_symbols, sales_orders.is_fulfilled_with_symbols, sales_orders.is_blocked_with_symbols,
            sales_orders.has_return_line_with_symbols, sales_orders.total_sales_ordered_amount_target_currency,
            sales_orders__lines.line_number, sales_orders__lines.item_part_number, sales_orders__lines.item_description,
            sales_orders.selected_customer_name, sales_orders.ordered_date,
            sales_orders__lines.ordered_quantity, sales_orders__lines.quantity_uom, sales_orders__lines.fulfilled_quantity,
            sales_orders__lines.unit_list_price_target_currency, sales_orders__lines.unit_discount_amount_target_currency,
            sales_orders__lines.unit_selling_price_target_currency,
            sales_orders__lines.ordered_amount_target_currency, sales_orders__lines.fulfilled_amount_target_currency,
            sales_orders__lines.currency_conversion_rate]
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
    series_text_format:
      sales_orders.open_closed_cancelled_with_symbols:
        align: center
      sales_orders.is_fulfilled_with_symbols:
        align: center
      sales_orders.is_blocked_with_symbols:
        align: center
      sales_orders.has_return_line_with_symbols:
        align: center
    series_column_widths:
      sales_orders__lines.item_description: 250
    listen:
      date: sales_orders.ordered_date
      business_unit: sales_orders.business_unit_name
      customer_country: sales_orders.selected_customer_country
      customer_name: sales_orders.selected_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_orders.order_source_name
      item_category: sales_orders__lines.category_description
      item_language: otc_common_parameters_xvw.parameter_language
      order_number: sales_orders.order_number
      has_return: sales_orders.has_return_line
      is_blocked: sales_orders.is_blocked
      is_fulfilled: sales_orders.is_fulfilled
    row: 0
    col: 0
    width: 24
    height: 16

  - name: summary
    title: Summary
    explore: sales_orders
    type: looker_grid
    fields: [sales_orders.sales_order_count,sales_orders.fulfilled_sales_order_count, sales_orders.blocked_sales_order_count, sales_orders.has_return_sales_order_count, sales_orders__lines.count_order_lines,
             sales_orders__lines.total_sales_amount_target_currency,sales_orders__lines.total_fulfilled_amount_target_currency]
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
      order_number: sales_orders.order_number
      has_return: sales_orders.has_return_line
      is_blocked: sales_orders.is_blocked
      is_fulfilled: sales_orders.is_fulfilled
    row: 13
    col: 0
    width: 24
    height: 2
