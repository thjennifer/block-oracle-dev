#########################################################{
# Accounts Receivable dashboard provides an analysis of
# receivables, encompassing both current and overdue amounts.
# Also identifies customers with the highest outstanding
# receivables, along with an assessment of the duration
# of their overdue payments.
#
# Extends otc_template_billing and modifies to:
#   update business_unit, customer_country, customer_name to
#     use sales_payments_daily_agg Explore
#
#   add new filters for aging_bucket_size, aging_bucket_count,
#     and dso_days
#
#   update dashboard_navigation to:
#       use sales_payments_daily_agg Explore
#       set parameter_navigation_focus_page: '2'
#
#
# Visualization Elements:
#   total_receivables - single-value viz
#   past_due_receivables - single-value viz
#   doubtful_receivables - single-value viz
#   days_sales_outstanding - single-value viz
#   past_due_receivables_by_age - stacked bar chart as percent of total
#   customers_with_highest_receivables - bar & line chart
#   customer_receivables_by_age - stacked bar chart
#
#########################################################}

- dashboard: otc_billing_accounts_receivable
  title: Accounts Receivable
  description: "Analysis of receivables, encompassing both current and overdue amounts. Identification of customers with the highest outstanding receivables, along with an assessment of the duration of their overdue payments"

  extends: otc_template_billing

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
    allow_multiple_values: false
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
    allow_multiple_values: false
    required: false
    ui_config:
      type: slider
      display: inline
      options:
        min: 1
        max: 6
    explore: sales_payments
    field: sales_payments_dynamic_aging_bucket_sdt.dummy_bucket_count

  - name: dso_days
    title: 'DSO: # Days for Calculation'
    type: field_filter
    default_value: '365'
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: sales_payments_dso_days_agg_pdt
    field: sales_payments_dso_days_agg_pdt.dso_days_string

  elements:
  - name: dashboard_navigation
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_focus_page: '2'
#####################################################################################################
  - name: total_receivables
    title: Total Receivables
    explore: sales_payments_daily_agg
    type: single_value
    fields: [ sales_payments_daily_agg.total_receivables_target_currency_formatted,
              sales_payments_daily_agg.total_overdue_receivables_target_currency_formatted,
              sales_payments_daily_agg.total_doubtful_receivables_target_currency_formatted]
    hidden_fields: [sales_payments_daily_agg.total_overdue_receivables_target_currency_formatted,
                    sales_payments_daily_agg.total_doubtful_receivables_target_currency_formatted]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: |-
      Total value of all receivables not yet paid.
      </br></br>May be lower value than other receivables KPIs because total includes any credits a customer may have.
    listen:
      date: sales_payments_daily_agg.transaction_date
      business_unit: sales_payments_daily_agg.business_unit_name
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
    row: 2
    col: 0
    width: 5
    height: 3
#####################################################################################################
  - name: past_due_receivables
    title: Total Past Due Receivables
    explore: sales_payments_daily_agg
    type: single_value
    fields: [sales_payments_daily_agg.total_receivables_target_currency_formatted,
             sales_payments_daily_agg.total_overdue_receivables_target_currency_formatted,
             sales_payments_daily_agg.total_doubtful_receivables_target_currency_formatted]
    hidden_fields: [sales_payments_daily_agg.total_receivables_target_currency_formatted,
                    sales_payments_daily_agg.total_doubtful_receivables_target_currency_formatted]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: |-
      Total value of receivables past their due date.
    listen:
      date: sales_payments_daily_agg.transaction_date
      business_unit: sales_payments_daily_agg.business_unit_name
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
    row: 2
    col: 5
    width: 5
    height: 3
#####################################################################################################
  - name: doubtful_receivables
    title: Total Doubtful Receivables
    explore: sales_payments_daily_agg
    type: single_value
    fields: [ sales_payments_daily_agg.total_receivables_target_currency_formatted,
              sales_payments_daily_agg.total_overdue_receivables_target_currency_formatted,
              sales_payments_daily_agg.total_doubtful_receivables_target_currency_formatted]
    hidden_fields: [sales_payments_daily_agg.total_receivables_target_currency_formatted,
                    sales_payments_daily_agg.total_overdue_receivables_target_currency_formatted]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: |-
      Total value of receivables not yet paid and expected to become bad debt (receivables past due > 90 days).
    listen:
      date: sales_payments_daily_agg.transaction_date
      business_unit: sales_payments_daily_agg.business_unit_name
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
    row: 4
    col: 0
    width: 5
    height: 3
#####################################################################################################
  - name: days_sales_outstanding
    title: Days Sales Outstanding
    explore: sales_payments_dso_days_agg_pdt
    type: single_value
    fields: [sales_payments_dso_days_agg_pdt.days_sales_outstanding]
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: false
    note_state: collapsed
    note_display: hover
    note_text: |-
      <div style="text-align: left;">
      Average time, in days, for which the receivables are outstanding.
      </br></br>Calculated as:
      <p style="text-align: center;">(Ending Receivables Balance / Credit Sales) * N</p>
      where N is the number of days in the period.
      </br></br>User can choose 30, 90 or 365 days for the calculation with the dashboard parameter:
      <span style="color:#AECBFA;">
      </br>&ensp;&ensp;&ensp;DSO: # Days for Calculation
      </span>
      </br></br>The dashboard filter <span style="color:#AECBFA;">Invoice Date</span> does not impact this KPI.
      </div>
    listen:
        business_unit: sales_payments_dso_days_agg_pdt.business_unit_name
        customer_country: sales_payments_dso_days_agg_pdt.bill_to_customer_country
        customer_name: sales_payments_dso_days_agg_pdt.bill_to_customer_name
        target_currency: sales_payments_dso_days_agg_pdt.target_currency_code
        dso_days: sales_payments_dso_days_agg_pdt.dso_days_string
    row: 4
    col: 5
    width: 5
    height: 3
#####################################################################################################
  - name: past_due_receivables_by_age
    title: Past Due Receivables by Age
    explore: sales_payments
    type: looker_bar
    fields: [ sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name,
              sales_payments.total_overdue_receivables_target_currency_formatted]
    pivots: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    filters:
      sales_payments.is_open_and_overdue: 'Yes'
      sales_payments.is_payment_transaction: 'No'
    sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    x_axis_gridlines: false
    show_y_axis_labels: false
    show_y_axis_ticks: false
    show_x_axis_labels: false
    show_x_axis_ticks: false
    stacking: percent
    legend_position: center
    show_value_labels: true
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    color_application:
      collection_id: legacy
      palette_id: looker_classic
      options:
        steps: 5
        reverse: false
    x_axis_zoom: true
    y_axis_zoom: false
    advanced_vis_config: |-
      {
        tooltip: {
          format: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">Past Due Receivables</th></table><table>{#each points}<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f} ({point.percentage:.0f}%)</td></tr>{/each}',
          footerFormat: '</table>',
          shared: true,
          backgroundColor: '#FFFFFF',
          shadow: true,
        },
      }
    note_state: collapsed
    note_display: hover
    note_text: |-
      <p style="text-align: left;">
      Percent of past due receivables by age (or days past due).
      </br> </br>Number and size of age ranges are defined by dashboard parameters:
      <span style="color:#AECBFA;">
      </br>&ensp;&ensp;&ensp;Aging Bucket: # of Days in Range
      </br>&ensp;&ensp;&ensp;Aging Bucket: # of Ranges
      </span>
      </p>
    listen:
      date: sales_payments.transaction_date
      business_unit: sales_payments.business_unit_name
      customer_country: sales_payments.bill_to_customer_country
      customer_name: sales_payments.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
      aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
    row: 2
    col: 11
    width: 14
    height: 6
#####################################################################################################
  - name: customers_with_highest_receivables
    title: Customers with Highest Receivables
    explore: sales_payments_daily_agg
    type: looker_bar
    fields: [ sales_payments_daily_agg.bill_to_customer_number,
              sales_payments_daily_agg.bill_to_customer_name,
              sales_payments_daily_agg.total_receivables_target_currency_formatted,
              sales_payments_daily_agg.cumulative_total_receivables]
    hidden_fields: [sales_payments_daily_agg.bill_to_customer_number,
                    sales_payments_daily_agg.cumulative_total_receivables]
    filters:
      sales_payments_daily_agg.is_payment_transaction: 'No'
    sorts: [sales_payments_daily_agg.percent_of_total_receivables desc]
    series_types:
      cumulative_percent_of_total_receivables: line
    series_colors:
      sales_payments_daily_agg.total_receivables_target_currency_formatted: "#2596BE"
      cumulative_percent_of_total_receivables: "#000000"
    limit: 10
    total: true
    # Use Table Calculations for Cumulative Percent of Total Receivables
    dynamic_fields:
    - category: table_calculation
      expression: "(${sales_payments_daily_agg.cumulative_total_receivables} / ${sales_payments_daily_agg.total_receivables_target_currency_formatted:total} )*100"
      label: Cumulative Percent of Total Receivables
      value_format:
      value_format_name: decimal_0
      _kind_hint: measure
      table_calculation: cumulative_percent_of_total_receivables
      _type_hint: number
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    show_silhouette: false
    y_axes: [{label: '', orientation: top,
              series: [{axisId: sales_payments_daily_agg.total_receivables_target_currency_formatted,
                            id: sales_payments_daily_agg.total_receivables_target_currency_formatted,
              }], showLabels: false, showValues: false, },
        {label: '', orientation: bottom,
          series: [{axisId: cumulative_percent_of_total_receivables,
                        id: cumulative_percent_of_total_receivables,
                      name: Cumulative Percent of Total Receivables}], showLabels: false, showValues: false,}]
    advanced_vis_config: |-
      {
        series: [
        {
          tooltip: {
            headerFormat: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{point.key}</th>',
            pointFormat: '<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f}</td></tr>',
            shared: true,
            footerFormat: '</table>'
          },
        },
        {
          tooltip: {
            headerFormat: '<table> <th style="font-size: 1.8em;text-align: left;color: #808080;">{point.key}</th>',
            pointFormat: '<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};">{point.y:,.0f}%</td></tr>',
            shared: true,
            footerFormat: '</table>'
          },
          dataLabels: {
            format: '{y:.0f}%',
            color: '#000000',
            align: 'left',
            allowOverlap: false,
          },
        },
        ],
        tooltip: {
          backgroundColor: '#FFFFFF',
          shared: true,
          formatter: null,
          shadow: true,
          crosshairs: true,
        },
      }
    note_state: collapsed
    note_display: hover
    note_text: |-
      <p style="text-align: left;">
      Customers ranked in descending order by Total Receivables. The black line reflects a customer's Cumulative Percent of Total Receivables.
      </br></br>Limited to 10 customers.
      To change:
      </br>1. Click the three-dot menu at the top right of tile
      and select 'Explore from here'.
      </br></br>2. In the Data pane, change the row limit to desired value.
      </div>
    listen:
      date: sales_payments_daily_agg.transaction_date
      business_unit: sales_payments_daily_agg.business_unit_name
      customer_country: sales_payments_daily_agg.bill_to_customer_country
      customer_name: sales_payments_daily_agg.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
    row: 6
    col: 0
    width: 10
    height: 10
#####################################################################################################
  - name: customer_receivables_by_age
    title: Customers with Highest Past Due Receivables by Age
    explore: sales_payments
    type: looker_bar
    fields: [ sales_payments.bill_to_customer_number,
              sales_payments.bill_to_customer_name,
              sales_payments.total_overdue_receivables_target_currency_formatted,
              sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    pivots: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name]
    dynamic_fields:
      - category: table_calculation
        expression: sum(pivot_row(${sales_payments.total_overdue_receivables_target_currency_formatted}))
        label: Row Total
        value_format_name: format_large_numbers_d1
        _kind_hint: supermeasure
        table_calculation: row_total
        _type_hint: number
    hidden_fields: [sales_payments.bill_to_customer_number, row_total]
    filters:
      sales_payments.is_open_and_overdue: 'Yes'
      sales_payments.payment_class_code: '-PMT'
    sorts: [sales_payments_dynamic_aging_bucket_sdt.aging_bucket_name, row_total desc]
    show_y_axis_ticks: false
    show_y_axis_labels: false
    show_x_axis_label: false
    stacking: normal
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    legend_position: center
    show_value_labels: true
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
    advanced_vis_config: |-
      {
        tooltip: {
          format: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{key}</th></table><table>{#each points}<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f} ({point.percentage:.0f}%)</td></tr>{/each}',
          footerFormat: '</table>',
          shared: true,
          crosshairs: true,
          backgroundColor: '#FFFFFF',
          shadow: true,
        },
      }
    note_state: collapsed
    note_display: hover
    note_text: |-
      <div style="text-align: left;">
        Customers ranked in descending order by Total Past Due Receivables.
      </br> </br>Number and size of age ranges are defined by dashboard parameters:
      <span style="color:#AECBFA;">
      </br>&ensp;&ensp;&ensp;Aging Bucket: # of Days in Range
      </br>&ensp;&ensp;&ensp;Aging Bucket: # of Ranges
      </span>
      </br></br>Limited to 10 customers. To change:
      </br> 1. Click the three-dot menu at the top right of tile
      and select 'Explore from here'.
      </br></br>2. In the Visualization pane, click EDIT.
      </br></br>3. Click on the Plot tab and edit 'Limit Displayed Rows' property.
      </div>
    listen:
      date: sales_payments.transaction_date
      business_unit: sales_payments.business_unit_name
      customer_country: sales_payments.bill_to_customer_country
      customer_name: sales_payments.bill_to_customer_name
      target_currency: otc_common_parameters_xvw.parameter_target_currency
      aging_bucket_size: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_size
      aging_bucket_count: sales_payments_dynamic_aging_bucket_sdt.parameter_aging_bucket_count
    row: 6
    col: 11
    width: 14
    height: 10
