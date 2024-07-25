#########################################################{
# Billing and Invoicing dashboard provides an overview of
# invoice volume and amounts including monthly trends.
# Highlights customers with highest discounts (average
# discount amount and percentages).
#
# Extends otc_template_billing and modifies to:
#   adds filters order_source and item_category
#   update dashboard_navigation to:
#       listen to order_source and item_category
#       set parameter_navigation_focus_page: '1'
#
# Visualization Elements:
#   invoice_count - single-value viz
#   invoice_amount - single-value viz
#   discount_amount - single-value viz
#   tax_amount - single-value viz
#   invoices_by_month - area & line chart
#   customer_discounts - column & line chart
#
#########################################################}

- dashboard: otc_billing_and_invoicing
  title: Billing and Invoicing
  description: "Overview of invoice volume and amounts including monthly trends. Highlights customers with highest discounts (average discount amount and percentages)."

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
      explore: sales_invoices_daily_agg
      field: sales_invoices_daily_agg.category_description

  elements:
    - name: dashboard_navigation
      explore: sales_invoices_daily_agg
      filters:
        otc_dashboard_navigation_ext.parameter_navigation_focus_page: '1'
      listen:
        date: otc_dashboard_navigation_ext.filter1
        business_unit: otc_dashboard_navigation_ext.filter2
        customer_country: otc_dashboard_navigation_ext.filter4
        customer_name: otc_dashboard_navigation_ext.filter5
        target_currency: otc_dashboard_navigation_ext.filter6
        order_source: otc_dashboard_navigation_ext.filter7
        item_category: otc_dashboard_navigation_ext.filter8

    - name: invoice_count
      title: Total Invoice Count
      explore: sales_invoices
      type: single_value
      fields: [sales_invoices.invoice_count_formatted]
      listen:
        date: sales_invoices.invoice_date
        business_unit: sales_invoices.business_unit_name
        customer_country: sales_invoices.bill_to_customer_country
        customer_name: sales_invoices.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices__lines.order_source_name
        item_category: sales_invoices__lines.category_description
      note_state: collapsed
      note_display: hover
      note_text: "Total count of invoices."
      row: 2
      col: 0
      width: 6
      height: 2

    - name: invoice_amount
      title: Total Invoice Amount
      explore: sales_invoices_daily_agg
      type: single_value
      fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted
              ,sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      hidden_fields: [sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      listen:
        date: sales_invoices_daily_agg.invoice_date
        business_unit: sales_invoices_daily_agg.business_unit_name
        customer_country: sales_invoices_daily_agg.bill_to_customer_country
        customer_name: sales_invoices_daily_agg.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices_daily_agg.order_source_name
        item_category: sales_invoices_daily_agg.category_description
      note_state: collapsed
      note_display: hover
      note_text: "Total amount of invoices."
      row: 2
      col: 6
      width: 6
      height: 2


    - name: discount_amount
      title: Total Discount Amount
      explore: sales_invoices_daily_agg
      type: single_value
      fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted
              ,sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      hidden_fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      listen:
        date: sales_invoices_daily_agg.invoice_date
        business_unit: sales_invoices_daily_agg.business_unit_name
        customer_country: sales_invoices_daily_agg.bill_to_customer_country
        customer_name: sales_invoices_daily_agg.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices_daily_agg.order_source_name
        item_category: sales_invoices_daily_agg.category_description
      note_state: collapsed
      note_display: hover
      note_text: "Total discount amount of invoices."
      row: 2
      col: 12
      width: 6
      height: 2


    - name: tax_amount
      title: Total Tax Amount
      explore: sales_invoices_daily_agg
      type: single_value
      fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted
              ,sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      hidden_fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,sales_invoices_daily_agg.total_discount_amount_target_currency_formatted]
      listen:
        date: sales_invoices_daily_agg.invoice_date
        business_unit: sales_invoices_daily_agg.business_unit_name
        customer_country: sales_invoices_daily_agg.bill_to_customer_country
        customer_name: sales_invoices_daily_agg.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices_daily_agg.order_source_name
        item_category: sales_invoices_daily_agg.category_description
      note_state: collapsed
      note_display: hover
      note_text: "Total tax amount of invoices."
      row: 2
      col: 18
      width: 6
      height: 2

    - name: invoices_by_month
      title: Invoice Volumes by Month
      explore: sales_invoices
      type: looker_line
      fields: [sales_invoices.invoice_month, sales_invoices.invoice_count, sales_invoices__lines.total_transaction_amount_target_currency_formatted]
      fill_fields: [sales_invoices.invoice_month]
      sorts: [sales_invoices.invoice_month desc]
      limit: 500
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      legend_position: center
      point_style: circle_outline
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: false
      interpolation: linear
      y_axes: [{label: '', orientation: left, series: [{axisId: sales_invoices.invoice_count,
              id: sales_invoices.invoice_count, name: Invoice Count}], showLabels: true,
          showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
          type: linear}, {label: !!null '', orientation: right, series: [{axisId: sales_invoices__lines.total_transaction_amount_target_currency_formatted,
              id: sales_invoices__lines.total_transaction_amount_target_currency_formatted,
              name: Total Invoice Amount}], showLabels: true, showValues: true,
          unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
      x_axis_zoom: true
      y_axis_zoom: true
      series_types:
        sales_invoices.invoice_count: area
      series_colors:
        sales_invoices__lines.total_transaction_amount_target_currency_formatted: "#808080"
        sales_invoices.invoice_count: "#2596be"
      discontinuous_nulls: true
      advanced_vis_config: |-
        {
          chart: {},
          series: [{
            name: "Invoice Count",
            lineWidth: 5,
            marker: {
              enabled: false
            },
          }, ],
          tooltip: {
            backgroundColor: '#C0C0C0',
            crosshairs: [true, true],
            format: '<span style="font-size: 1.8em">{key}</span><br/>{#each points}<span style="color:{color}; font-weight: bold;">\u25CF {series.name}: </span>{y:,.0f}<br/>{/each}',
            shared: true
          },
        }
      listen:
        date: sales_invoices.invoice_date
        business_unit: sales_invoices.business_unit_name
        customer_country: sales_invoices.bill_to_customer_country
        customer_name: sales_invoices.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices__lines.order_source_name
        item_category: sales_invoices__lines.category_description
      note_state: collapsed
      note_display: hover
      note_text: "Invoice total counts and amounts by month."
      row: 6
      col: 0
      width: 24
      height: 7

    - name: customer_discounts
      title: Customers with Highest Volume of Discounts
      explore: sales_invoices
      type: looker_line
      fields: [sales_invoices.bill_to_site_use_id, sales_invoices.bill_to_customer_name,
        sales_invoices.invoice_count, sales_invoices__lines.average_percent_discount_when_taken,
        sales_invoices__lines.invoice_line_count, sales_invoices__lines.total_discount_amount_target_currency,
        sales_invoices__lines.discount_invoice_line_percent, sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link,
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency_with_drill_link]
      hidden_fields: [sales_invoices.bill_to_site_use_id, sales_invoices.invoice_count,
        sales_invoices__lines.invoice_line_count, sales_invoices__lines.total_discount_amount_target_currency]
      filters:
        sales_invoices__lines.is_intercompany: 'No'
      sorts: [sales_invoices__lines.total_discount_amount_target_currency desc]
      limit: 500
      column_limit: 50
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_tick_density_custom: 5
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      legend_position: center
      point_style: circle
      show_value_labels: true
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: false
      interpolation: step
      color_application:
        collection_id: legacy
        palette_id: looker_classic
        options:
          steps: 5
          reverse: false
      y_axes: [{label: 'Avg Unit Prices when Discount', orientation: left, series: [{axisId: sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link,
              id: sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link,
              name: Average Unit List Price when Discount}, {axisId: sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency_with_drill_link,
              id: sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency_with_drill_link,
              name: Average Unit Selling Price when Discount}], showLabels: true,
          showValues: true, valueFormat: "#,###", unpinAxis: false, tickDensity: default, type: linear},
        {label: 'Discount percentages', orientation: right, series: [{axisId: sales_invoices__lines.average_percent_discount_when_taken,
              id: sales_invoices__lines.average_percent_discount_when_taken, name: Average
                % Discount}, {axisId: sales_invoices__lines.discount_invoice_line_percent,
              id: sales_invoices__lines.discount_invoice_line_percent, name: Frequency of Discounts}], showLabels: true, showValues: true,
              # maxValue: 1,
          minValue: 0, unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
      x_axis_zoom: true
      y_axis_zoom: true
      limit_displayed_rows: true
      limit_displayed_rows_values:
        show_hide: show
        first_last: first
        num_rows: '5'
      series_types:
        sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link: column
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency_with_drill_link: column
      series_labels:
        sales_invoices__lines.average_percent_discount_when_taken: "Average Discount %"
        sales_invoices__lines.discount_invoice_line_percent: "Discount Frequency (% of Invoice Lines)"
        sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link: "Average Unit List Price"
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency_with_drill_link: "Average Gross Unit Selling Price"
      series_colors:
        sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link: "#76b5c5"
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency_with_drill_link: "#e28743"
        sales_invoices__lines.discount_invoice_line_percent: "#192d54"
        sales_invoices__lines.average_percent_discount_when_taken: "#873e23"
      series_point_styles:
        sales_invoices__lines.average_percent_discount_when_taken: triangle
      advanced_vis_config: |-
        {
          series: [
            {
              id: 'sales_invoices__lines.average_percent_discount_when_taken',
              tooltip: {
                followPointer: false,
              },
            },
            {
              id: 'sales_invoices__lines.discount_invoice_line_percent',

              tooltip: {
                followPointer: false,
              },
              type: 'line',
              dashStyle: "dash",
            },
            {
              id: 'sales_invoices__lines.average_unit_list_price_when_discount_target_currency_with_drill_link',
              dataLabels: {
                enabled: false,
              },
              tooltip: {
                followPointer: true,
              },
            },
            {
              id: 'sales_invoices__lines.average_unit_selling_price_when_discount_target_currency_with_drill_link',
              dataLabels: {
                enabled: false,
              },
              tooltip: {
                followPointer: true,
              },
            },
          ],
          tooltip: {
            backgroundColor: '#C0C0C0',
            format: '<span style="font-size: 1.8em">{key}</span><br/>{#each points}<span style="color:{color}; font-weight: bold;">\u25CF {series.name}: </span>{y:,.2f}<br/>{/each}',
            shared: true,
          },
        }
      listen:
        date: sales_invoices.invoice_date
        business_unit: sales_invoices.business_unit_name
        customer_country: sales_invoices.bill_to_customer_country
        customer_name: sales_invoices.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices__lines.order_source_name
        item_category: sales_invoices__lines.category_description
      note_state: collapsed
      note_display: hover
      note_text: "Customers are ranked in descending order by Total Discount Amount across non-Intercompany invoice lines. Average Unit List Price and Average Unit Selling Price across invoice lines are shown as columns. The Average Discount % taken as well as the Frequncy of Discounts (as % of invoice lines) are also shown as lines."
      row: 16
      col: 0
      width: 24
      height: 7
