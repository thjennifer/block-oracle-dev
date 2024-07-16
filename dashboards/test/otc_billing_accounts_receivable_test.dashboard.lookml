- dashboard: otc_billing_accounts_receivable_test
  title: Accounts Receivable TEST

  extends: otc_template_billing_test

  filters:

  - name: business_unit
    explore: sales_payments_daily_agg
    field: sales_payments_daily_agg.business_unit_name

  - name: customer_country
    explore: sales_payments_daily_agg
    field: sales_payments_daily_agg.bill_to_customer_country

  - name: customer_name
    explore: sales_payments_daily_agg
    field: sales_payments_daily_agg.bill_to_customer_name

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

  - name: dso_days
    title: 'DSO: # Days for Calculation'
    type: field_filter
    default_value: '365'
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: dso_days_sdt
    field: dso_days_sdt.dso_days_string

  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '2'

  - name: total_receivables
    title: Total Receivables
    explore: sales_payments_daily_agg
    type: single_value
    fields: [sales_payments_daily_agg.total_receivables_target_currency]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: "Total value of all receivables not yet paid."
    listen:
      date: sales_payments_daily_agg.transaction_date
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      business_unit: sales_payments_daily_agg.business_unit_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 2
    col: 0
    width: 5
    height: 3
    model: cortex-oracle-ebs-test

  - name: past_due_receivables
    title: Total Past Due Receivables
    explore: sales_payments_daily_agg
    type: single_value
    fields: [sales_payments_daily_agg.total_overdue_receivables_target_currency]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: "Total value of receivables past their due date."
    listen:
      date: sales_payments_daily_agg.transaction_date
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      business_unit: sales_payments_daily_agg.business_unit_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 2
    col: 5
    width: 5
    height: 3
    model: cortex-oracle-ebs-test

  - name: doubtful_receivables
    title: Total Doubtful Receivables
    explore: sales_payments_daily_agg
    type: single_value
    fields: [sales_payments_daily_agg.total_doubtful_receivables_target_currency]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: "Total value of receivables not yet paid and expected to become bad debt (receivables past due > 90 days)."
    listen:
      date: sales_payments_daily_agg.transaction_date
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      business_unit: sales_payments_daily_agg.business_unit_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 4
    col: 0
    width: 5
    height: 3
    model: cortex-oracle-ebs-test

  - name: days_sales_outstanding
    title: Days Sales Outstanding
    # explore: sales_payments
    # explore: dso_payments_and_invoices_pdt
    explore: sales_payments_dso_days_agg_pdt
    type: single_value
    # fields: [sales_payments.days_sales_outstanding]
    fields: [sales_payments_dso_days_agg_pdt.days_sales_outstanding]
    # filters:
    #   sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    # note_text: "Under Construction"
    note_text: "Average time, in days, for which the receivables are outstanding. Calculated as (Ending Receivables Balance / Credit Sales) * N where N is number of days in period. User can choose 30, 90 or 365 days for the calculation with the dashboard parameter 'DSO: # Days for Calculation'."
    listen:
        customer_country: sales_payments_dso_days_agg_pdt.bill_to_customer_country
        customer_name: sales_payments_dso_days_agg_pdt.bill_to_customer_name
        business_unit: sales_payments_dso_days_agg_pdt.business_unit_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        dso_days: sales_payments_dso_days_agg_pdt.dso_days_string
        test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 4
    col: 5
    width: 5
    height: 3
    model: cortex-oracle-ebs-test

  - name: past_due_receivables_by_age
    title: Past Due Receivables by Age
    explore: sales_payments
    type: looker_bar
    fields: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name, sales_payments.total_overdue_receivables_target_currency]
    pivots: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    filters:
      sales_payments.is_open_and_overdue: 'Yes'
      sales_payments.is_payment_transaction: 'No'
    sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: false
    show_y_axis_ticks: false
    # y_axis_tick_density: default
    # y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    # trellis: row
    stacking: percent
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    color_application:
      collection_id: legacy
      palette_id: looker_classic
      options:
        steps: 5
        reverse: false
    # y_axes: [{label: Percent of Past Due Receivables, orientation: bottom, series: [
    #       {axisId: 30 Days Past Due - 1 - sales_payments.total_receivables_target_currency,
    #         id: 30 Days Past Due - 1 - sales_payments.total_receivables_target_currency,
    #         name: 30 Days Past Due}, {axisId: 60 Days Past Due - 2 - sales_payments.total_receivables_target_currency,
    #         id: 60 Days Past Due - 2 - sales_payments.total_receivables_target_currency,
    #         name: 60 Days Past Due}, {axisId: 90 Days Past Due - 3 - sales_payments.total_receivables_target_currency,
    #         id: 90 Days Past Due - 3 - sales_payments.total_receivables_target_currency,
    #         name: 90 Days Past Due}, {axisId: 91+  Days Past Due - 4 - sales_payments.total_receivables_target_currency,
    #         id: 91+  Days Past Due - 4 - sales_payments.total_receivables_target_currency,
    #         name: 91+  Days Past Due}], showLabels: false, showValues: false, unpinAxis: false,
    #     tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: false
    show_null_points: true
    # interpolation: linear
    # hidden_fields: []
    # defaults_version: 1
    # hidden_pivots: {}
    note_state: collapsed
    note_display: hover
    note_text: "Percent of past due receivables by age (or days past due). Number and size of age ranges are defined by dashboard parameters 'Aging Bucket: # of Days in Range' and 'Aging Bucket: # of Ranges'."
    listen:
      date: sales_payments.transaction_date
      customer_country: sales_payments.bill_to_customer_country
      customer_name: sales_payments.bill_to_customer_name
      business_unit: sales_payments.business_unit_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
      aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
      aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
    row: 2
    col: 11
    width: 14
    height: 6
    model: cortex-oracle-ebs-test

  - name: customers_with_highest_receivables
    title: Customers with Highest Receivables
    explore: sales_payments_daily_agg
    type: looker_bar
    fields: [sales_payments_daily_agg.bill_to_customer_number, sales_payments_daily_agg.bill_to_customer_name,
      sales_payments_daily_agg.total_receivables_target_currency, sales_payments_daily_agg.cumulative_total_receivables,
      sales_payments_daily_agg.percent_of_total_receivables]
    hidden_fields: [sales_payments_daily_agg.bill_to_customer_number, sales_payments_daily_agg.cumulative_total_receivables,
    sales_payments_daily_agg.percent_of_total_receivables]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    sorts: [sales_payments_daily_agg.percent_of_total_receivables desc]
    series_types:
      cumulative_percent_of_total_receivables: line
    series_colors: #2596be #74A09F
      sales_payments_daily_agg.total_receivables_target_currency: "#2596be"
      cumulative_percent_of_total_receivables: "#000"
    limit: 5000
    total: true
    # Use Table Calculations for Cumulative Percent of Total Receivables
    dynamic_fields:
    - category: table_calculation
      expression: "(${sales_payments_daily_agg.cumulative_total_receivables} / sum(${sales_payments_daily_agg.total_receivables_target_currency}))"
      label: Cumulative Percent of Total Receivables
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
      table_calculation: cumulative_percent_of_total_receivables
      _type_hint: number
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
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    # y_axes: [{label: '', orientation: top, series: [{axisId: sales_payments.total_receivables_target_currency, id: sales_payments.total_receivables_target_currency, name: Total Receivables (USD)}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: bottom, series: [{axisId: cumulative_percent_of_total_receivables, id: cumulative_percent_of_total_receivables,
    #           name: Cumulative Percent of Total Receivables}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    y_axes: [{label: '', orientation: top, series: [{axisId: sales_payments_daily_agg.total_receivables_target_currency,
            id: sales_payments_daily_agg.total_receivables_target_currency, name: Total Receivables
              (USD)}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: bottom,
        series: [{axisId: cumulative_percent_of_total_receivables, id: cumulative_percent_of_total_receivables,
            name: Cumulative Percent of Total Receivables}], showLabels: false, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'

    note_state: collapsed
    note_display: hover
    note_text: "Customers ranked in descending order by Total Receivables. Black line overlaying totals reflects a customer's Cumulative Percent of Total Receivables. Limited to 10 customers. To change, click Explore from Here. In the Visualization pane, click EDIT. Click on Plot tab and edit 'Limit Displayed Rows' property."
    listen:
      date: sales_payments_daily_agg.transaction_date
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      business_unit: sales_payments_daily_agg.business_unit_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
    row: 6
    col: 0
    width: 10
    height: 10
    model: cortex-oracle-ebs-test


  # # - name: companies_highest_receivables
  # #   title: Companies with Highest Receivables
  # #   explore: sales_payments
  # #   type: looker_bar
  # #   fields: [sales_payments.bill_to_customer_number, sales_payments.bill_to_customer_name, sales_payments.total_receivables_target_currency]
  # #   sorts: [sales_payments.total_amount_due_remaining_target_currency desc]
  # #   hidden_fields: [sales_payments.bill_to_customer_number]
  # #   filters:
  # #     sales_payments.is_payment_transaction: 'No'
  # #   limit: 5000
  # #   series_colors:
  # #     {sales_payments.total_receivables_target_currency: "#74A09F"}
  # #   x_axis_gridlines: false
  # #   y_axis_gridlines: false
  # #   show_view_names: false
  # #   show_y_axis_labels: true
  # #   show_y_axis_ticks: true
  # #   y_axis_tick_density: default
  # #   y_axis_tick_density_custom: 5
  # #   show_x_axis_label: false
  # #   show_x_axis_ticks: true
  # #   y_axis_scale_mode: linear
  # #   x_axis_reversed: false
  # #   y_axis_reversed: false
  # #   plot_size_by_field: false
  # #   limit_displayed_rows: true
  # #   limit_displayed_rows_values:
  # #     show_hide: show
  # #     first_last: first
  # #     num_rows: '10'
  # #   legend_position: center
  # #   point_style: none
  # #   show_value_labels: true
  # #   label_density: 25
  # #   x_axis_scale: auto
  # #   y_axis_combined: true
  # #   ordering: none
  # #   show_null_labels: false
  # #   show_totals_labels: false
  # #   show_silhouette: false
  # #   y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_payments.percent_of_total_receivable,
  # #           id: sales_payments.percent_of_total_receivable, name: Percent
  # #             of Total Receivable}], showLabels: true, showValues: false, unpinAxis: false,
  # #       tickDensity: default, tickDensityCustom: 5, type: linear}]
  # #   x_axis_zoom: true
  # #   y_axis_zoom: true
  # #   note_state: collapsed
  # #   note_display: hover
  # #   note_text: "Customers ranked in descending order by Total Receivables. Limited to 10 customers. To change, click Explore from Here. In the Visualization pane, click EDIT. Click on Plot tab and edit 'Limit Displayed Rows' property."
  # #   listen:
  # #     Date: sales_payments.transaction_date
  # #     Country: sales_payments.bill_to_customer_country
  # #     Customer: sales_payments.bill_to_customer_name
  # #     Business Unit: sales_payments.business_unit_name
  # #     Target Currency: otc_common_parameters_xvw.parameter_target_currency
  # #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  # #   row: 6
  # #   col: 0
  # #   width: 10
  # #   height: 10
  # #   model: cortex-oracle-ebs-test

  - name: customer_receivables_by_age
    title: Customers with Highest Past Due Receivables by Age
    explore: sales_payments
    type: looker_bar
    fields: [sales_payments.bill_to_customer_number, sales_payments.bill_to_customer_name,
      sales_payments.total_receivables_target_currency, sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    pivots: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    hidden_fields: [sales_payments.bill_to_customer_number]
    hidden_pivots:
      "$$$_row_total_$$$":
        is_entire_pivot_hidden: true
    filters:
      sales_payments.is_open_and_overdue: 'Yes'
      sales_payments.payment_class_code: '-PMT'
    sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name, sales_payments.total_receivables_target_currency
        desc 4]
    limit: 5000
    row_total: right
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: false
    show_y_axis_ticks: false
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: true
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: looker_classic
      options:
        steps: 5
        reverse: false
    x_axis_zoom: true
    y_axis_zoom: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    hidden_series: []
    series_colors: {}
    note_state: collapsed
    note_display: hover
    note_text: "Customers ranked in descending order by Total Past Due Receivables by Age. Number and size of age ranges are defined by dashboard parameters 'Aging Bucket: # of Days in Range and 'Aging Bucket: # of Ranges'. Limited to 10 customers. To change, click Explore from Here. In the Visualization pane, click EDIT. Click on Plot tab and edit 'Limit Displayed Rows' property."
    listen:
      date: sales_payments.transaction_date
      customer_country: sales_payments.bill_to_customer_country
      customer_name: sales_payments.bill_to_customer_name
      business_unit: sales_payments.business_unit_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      test_or_demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
      aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
      aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
    row: 6
    col: 11
    width: 14
    height: 10
    model: cortex-oracle-ebs-test


  # # - name: customer_receivables_by_age
  # #   title: Customers with Highest Past Due Receivables by Age
  # #   explore: sales_payments
  # #   type: looker_bar
  # #   fields: [sales_payments.bill_to_customer_number, sales_payments.bill_to_customer_name,
  # #     sales_payments.total_receivables_target_currency, sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
  # #   pivots: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
  # #   hidden_fields: [sales_payments.bill_to_customer_number]
  # #   # Use Row Total to sort
  # #   row_total: right
  # #   hidden_pivots:
  # #     "$$$_row_total_$$$":
  # #       is_entire_pivot_hidden: true
  # #   filters:
  # #     sales_payments.is_open_and_overdue: 'Yes'
  # #   sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name, sales_payments.total_receivables_target_currency
  # #       desc 4]
  # #   limit: 5000
  # #   limit_displayed_rows: true
  # #   limit_displayed_rows_values:
  # #     show_hide: show
  # #     first_last: first
  # #     num_rows: '10'

  # #   x_axis_gridlines: false
  # #   y_axis_gridlines: false
  # #   show_view_names: false
  # #   show_y_axis_labels: false
  # #   show_y_axis_ticks: false
  # #   y_axis_tick_density: default
  # #   y_axis_tick_density_custom: 5
  # #   show_x_axis_label: false
  # #   show_x_axis_ticks: true
  # #   y_axis_scale_mode: linear
  # #   x_axis_reversed: false
  # #   y_axis_reversed: false
  # #   plot_size_by_field: false
  # #   trellis: ''
  # #   stacking: percent

  # #   legend_position: center
  # #   show_value_labels: true
  # #   label_density: 25
  # #   x_axis_scale: auto
  # #   y_axis_combined: true
  # #   ordering: none
  # #   show_null_labels: false
  # #   show_totals_labels: false
  # #   show_silhouette: false
  # #   color_application:
  # #     collection_id: legacy
  # #     palette_id: looker_classic
  # #     options:
  # #       steps: 5
  # #       reverse: false
  # #   # y_axes: [{label: '', orientation: bottom, series: [{axisId: sales_payments.percent_of_total_receivable,
  # #   #         id: sales_payments.percent_of_total_receivable, name: Percent of Total Receivable}],
  # #   #         showLabels: true, showValues: false, unpinAxis: false,
  # #   #     tickDensity: default, tickDensityCustom: 5, type: linear}]
  # #   x_axis_zoom: true
  # #   y_axis_zoom: true
  # #   note_state: collapsed
  # #   note_display: hover
  # #   note_text: "Customers ranked in descending order by Total Past Due Receivables by Age. Number and size of age ranges are defined by dashboard parameters 'Aging Bucket: # of Days in Range' and 'Aging Bucket: # of Ranges'. Limited to 10 customers. To change, click Explore from Here. In the Visualization pane, click EDIT. Click on Plot tab and edit 'Limit Displayed Rows' property."
  # #   listen:
  # #     Date: sales_payments.transaction_date
  # #     Country: sales_payments.bill_to_customer_country
  # #     Customer: sales_payments.bill_to_customer_name
  # #     Business Unit: sales_payments.business_unit_name
  # #     Target Currency: otc_common_parameters_xvw.parameter_target_currency
  # #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  # #     aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
  # #     aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
  # #   row: 6
  # #   col: 11
  # #   width: 14
  # #   height: 10
  # #   model: cortex-oracle-ebs-test

  # # - name: Past Due Receivables by Aging Bucket
  # #   title: Past Due Receivables by Aging Bucket

  # #   explore: sales_payments
  # #   type: looker_bar
  # #   fields: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name, sales_payments.total_amount_due_remaining_target_currency,sales_payments.percent_of_total_receivables]
  # #   sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
  # #   filters:
  # #     sales_payments.is_open_and_overdue: "Yes"
  # #     sales_payments.is_payment_transaction: 'No'
  # #   limit: 50
  # #   x_axis_gridlines: false
  # #   y_axis_gridlines: false
  # #   show_view_names: false
  # #   show_y_axis_labels: true
  # #   show_y_axis_ticks: true
  # #   y_axis_tick_density: default
  # #   y_axis_tick_density_custom: 5
  # #   show_x_axis_label: false
  # #   show_x_axis_ticks: true
  # #   y_axis_scale_mode: linear
  # #   x_axis_reversed: false
  # #   y_axis_reversed: false
  # #   plot_size_by_field: false
  # #   limit_displayed_rows: false
  # #   legend_position: center
  # #   point_style: none
  # #   show_value_labels: true
  # #   label_density: 25
  # #   x_axis_scale: auto
  # #   y_axis_combined: true
  # #   ordering: none
  # #   show_null_labels: false
  # #   show_totals_labels: false
  # #   show_silhouette: false
  # #   y_axes: [{label: 'Percent of Past Due Receivables', orientation: bottom, series: [{axisId: sales_payments.percent_of_total_receivable,
  # #           id: sales_payments.percent_of_total_receivable, name: Percent
  # #             of Past Due Receivable}], showLabels: true, showValues: false, unpinAxis: false,
  # #       tickDensity: default, tickDensityCustom: 5, type: linear}]
  # #   x_axis_zoom: true
  # #   y_axis_zoom: true
  # #   hidden_fields: [sales_payments.total_amount_due_remaining_target_currency]
  # #   listen:
  # #     Date: sales_payments.transaction_date
  # #     Country: sales_payments.bill_to_customer_country
  # #     Customer: sales_payments.bill_to_customer_name
  # #     Business Unit: sales_payments.business_unit_name
  # #     Target Currency: otc_common_parameters_xvw.parameter_target_currency
  # #     Test or Demo: otc_common_parameters_xvw.parameter_use_demo_or_test_data
  # #     aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
  # #     aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
  # #   row: 15
  # #   col: 11
  # #   width: 10
  # #   height: 10
  # #   model: cortex-oracle-ebs-test
