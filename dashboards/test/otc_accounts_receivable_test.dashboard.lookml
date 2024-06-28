- dashboard: otc_accounts_receivable_test
  title: Accounts Receivable TEST
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  filters_location_top: false

  extends: otc_accounts_receivable_template_test

  filters:
  - name: aging_bucket_size
    title: 'Aging Bucket: # of Days in Range'
    type: field_filter
    default_value: '30'
    allow_multiple_values: true
    required: false
    ui_config:
      type: slider
      display: inline
      options:
        min: 1
        max: 365
    explore: sales_payments
    field: sales_payments_dynamic_aging_bucket_sdt.dummy_bucket_size

  - name: aging_bucket_count
    title: 'Aging Bucket: # of Ranges'
    type: field_filter
    default_value: '4'
    allow_multiple_values: true
    required: false
    ui_config:
      type: slider
      display: inline
      options:
        min: 1
        max: 6
    explore: sales_payments
    field: sales_payments_dynamic_aging_bucket_sdt.dummy_bucket_number

  elements:
  - title: navigation
    name: navigation
    filters:
      otc_dashboard_navigation_ext.navigation_focus_page: '4'

  - title: Total Receivables
    name: Total Receivables
    explore: sales_payments
    type: single_value
    fields: [sales_payments.total_amount_due_remaining_target_currency]
    filters:
      sales_payments.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    listen:
      Date: sales_payments.transaction_date
      Country: sales_payments.bill_to_customer_country
      Customer: sales_payments.bill_to_customer_name
      Business Unit: sales_payments.business_unit_name
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 2
    col: 0
    width: 5
    height: 2

  - title: Total Past Due Receivables
    name: Total Past Due Receivables
    explore: sales_payments
    type: single_value
    fields: [sales_payments.total_overdue_receivables_target_currency]

    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: "Overdue means past the due date."
    listen:
      Date: sales_payments.transaction_date
      Country: sales_payments.bill_to_customer_country
      Customer: sales_payments.bill_to_customer_name
      Business Unit: sales_payments.business_unit_name
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 2
    col: 5
    width: 5
    height: 2

  - title: Total Doubtful Receivables
    name: Total Doubtful Receivables
    explore: sales_payments
    type: single_value
    fields: [sales_payments.total_doubtful_receivables_target_currency]
    filters: {}
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: "Doubtful means greater than 90 days past the due date."
    listen:
      Date: sales_payments.transaction_date
      Country: sales_payments.bill_to_customer_country
      Customer: sales_payments.bill_to_customer_name
      Business Unit: sales_payments.business_unit_name
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 2
    col: 10
    width: 5
    height: 2

  - title: Total Receivables by Company
    name: Total Receivables by Company
    explore: sales_payments
    type: looker_bar
    fields: [sales_payments.bill_to_customer_number, sales_payments.bill_to_customer_name, sales_payments.total_amount_due_remaining_target_currency]
    sorts: [sales_payments.total_amount_due_remaining_target_currency desc]
    hidden_fields: [sales_payments.bill_to_customer_number]
    filters:
      sales_payments.is_payment_transaction: 'No'
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_payments.percent_of_total_receivable,
            id: sales_payments.percent_of_total_receivable, name: Percent
              of Total Receivable}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true

    listen:
      Date: sales_payments.transaction_date
      Country: sales_payments.bill_to_customer_country
      Customer: sales_payments.bill_to_customer_name
      Business Unit: sales_payments.business_unit_name
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 5
    col: 0
    width: 10
    height: 10

  - name: Past Due Receivables by Aging Bucket
    title: Past Due Receivables by Aging Bucket

    explore: sales_payments
    type: looker_bar
    fields: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name, sales_payments.total_amount_due_remaining_target_currency,sales_payments.percent_of_total_receivables]
    sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    filters:
      sales_payments.is_open_and_overdue: "Yes"
      sales_payments.is_payment_transaction: 'No'
    limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    y_axes: [{label: 'Percent of Past Due Receivables', orientation: bottom, series: [{axisId: sales_payments.percent_of_total_receivable,
            id: sales_payments.percent_of_total_receivable, name: Percent
              of Past Due Receivable}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    hidden_fields: [sales_payments.total_amount_due_remaining_target_currency]
    listen:
      Date: sales_payments.transaction_date
      Country: sales_payments.bill_to_customer_country
      Customer: sales_payments.bill_to_customer_name
      Business Unit: sales_payments.business_unit_name
      Target Currency: otc_common_parameters_xvw.parameter_target_currency
      Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
      aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
      aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
    row: 5
    col: 11
    width: 10
    height: 10
