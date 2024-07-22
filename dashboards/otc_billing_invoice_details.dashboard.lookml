- dashboard: otc_billing_invoice_details
  title: Billing Invoice Details
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false
  description: ''

  # pull navigation bar and filters from template
  # if using parameter_navigation_focus_page for active dashboard, update dashboard_navigation tile to use the correct value
  extends: otc_template_billing

  filters:
  - name: order_source
    title: Order Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_invoices_daily_agg
    field: sales_invoices_daily_agg.order_source_name

  - name: item_category
    title: Item Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    explore: sales_invoices
    field: sales_invoices__lines.category_description

  - name: invoice_number
    title: Invoice Number
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    explore: sales_invoices
    field: sales_invoices.invoice_number
    listens_to_filters: [business_unit_name, customer_country, customer_name]

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

  - name: is_complete
    title: Is Complete (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_invoices
    field: sales_invoices.is_complete

  - name: is_discounted
    title: Is Discounted Item (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_invoices
    field: sales_invoices__lines.is_discount_selling_price

  - name: is_intercompany
    title: Is Intercompany (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    explore: sales_invoices
    field: sales_invoices__lines.is_intercompany



  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '3'
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
      order_source: otc_dashboard_navigation_ext.filter7
      item_category: otc_dashboard_navigation_ext.filter8

  - name: invoice_table
    title: Invoices with Line Item Details
    explore: sales_invoices
    type: looker_grid
    fields: [sales_invoices.invoice_number, sales_invoices.invoice_type_name, sales_invoices.invoice_date,
      sales_invoices.total_transaction_amount_target_currency, sales_invoices.total_tax_amount_target_currency,
      sales_invoices.is_complete,sales_invoices.bill_to_customer_name,
      sales_invoices__lines.order_source_name, sales_invoices__lines.line_number,
      sales_invoices__lines.item_part_number, sales_invoices__lines.item_description,
      sales_invoices__lines.category_description, sales_invoices__lines.invoiced_or_credited_quantity,
      sales_invoices__lines.quantity_uom, sales_invoices__lines.unit_list_price_target_currency,
      sales_invoices__lines.unit_selling_price_target_currency, sales_invoices__lines.percent_discount,
      sales_invoices__lines.transaction_amount_target_currency, sales_invoices__lines.discount_amount_target_currency,
      sales_invoices__lines.tax_amount_target_currency]
    sorts: [sales_invoices.invoice_number, sales_invoices__lines.line_number]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: transparent
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
    listen:
      date: sales_invoices.invoice_date
      business_unit: sales_invoices.business_unit_name
      customer_country: sales_invoices.bill_to_customer_country
      customer_name: sales_invoices.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      order_source: sales_invoices__lines.order_source_name
      item_category: sales_invoices__lines.category_description
      item_language: otc_common_parameters_xvw.parameter_language
      invoice_number: sales_invoices.invoice_number
      is_complete: sales_invoices.is_complete
      is_discounted: sales_invoices__lines.is_discount_selling_price
      is_intercompany: sales_invoices__lines.is_intercompany
    row: 0
    col: 0
    width: 24
    height: 12