#########################################################{
# Billing and Invoicing dashboard provides an overview of
# invoice volume and amounts including monthly trends.
# Highlights customers with highest discounts (average
# discount amount and percentages).
#
# Extends otc_template_billing and modifies to:
#   add filters order_source and item_category
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
#####################################################################################################
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
#####################################################################################################
    - name: invoice_amount
      title: Total Invoice Amount
      explore: sales_invoices_daily_agg
      type: single_value
      fields: [ sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,
                sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,
                sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      hidden_fields: [sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,
                      sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
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
#####################################################################################################
    - name: discount_amount
      title: Total Discount Amount
      explore: sales_invoices_daily_agg
      type: single_value
      fields: [ sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,
                sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,
                sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      hidden_fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,
                      sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
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
      note_text: |-
        Total discount amount of invoices.
        </br></br>Discounts are calculated by subtracting the Gross Unit Selling Price from the Unit List Price as both prices are inclusive of taxes.
        If the Gross Unit Selling Price is unavailable, the pre-tax price is used, possibly leading to inflated discounts.
      row: 2
      col: 12
      width: 6
      height: 2
#####################################################################################################
    - name: tax_amount
      title: Total Tax Amount
      explore: sales_invoices_daily_agg
      type: single_value
      fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,
              sales_invoices_daily_agg.total_discount_amount_target_currency_formatted,
              sales_invoices_daily_agg.total_tax_amount_target_currency_formatted]
      hidden_fields: [sales_invoices_daily_agg.total_transaction_amount_target_currency_formatted,
                      sales_invoices_daily_agg.total_discount_amount_target_currency_formatted]
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
#####################################################################################################
    - name: invoices_by_month
      title: Invoice Volumes by Month
      explore: sales_invoices
      type: looker_line
      fields: [sales_invoices.invoice_month,
              sales_invoices.invoice_count,
              sales_invoices__lines.total_transaction_amount_target_currency_formatted]
      sorts: [sales_invoices.invoice_month desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: false
      show_x_axis_ticks: true
      show_null_points: false
      discontinuous_nulls: true
      legend_position: center
      point_style: circle_outline
      y_axes: [{label: '', orientation: left,
                series: [{axisId: sales_invoices.invoice_count,
                              id: sales_invoices.invoice_count,
                            name: Invoice Count}], showLabels: true, showValues: true, },
          {label: '', orientation: right,
            series: [{axisId: sales_invoices__line.total_transaction_amount_target_currency_formatted,
                          id: sales_invoices__lines.total_transaction_amount_target_currency_formatted,
                        name: Total Invoice Amount}], showLabels: true, showValues: true,}]
      series_types:
        sales_invoices.invoice_count: area
      series_colors:
        sales_invoices__lines.total_transaction_amount_target_currency_formatted: "#808080"
        sales_invoices.invoice_count: "#2596BE"

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
            backgroundColor: '#FFFFFF',
            shadow: true,
            format: '<table><th style="font-size: 1.8em;text-align: left;color: #808080; ">{key}</th></table><table>{#each points}<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f}</td></tr>{/each}',
            footerFormat: '</table>',
            useHTML: true,
            shared: true,
            crosshairs: true,
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
#####################################################################################################
    - name: customer_discounts
      title: Customers with Highest Volume of Discounts
      explore: sales_invoices
      type: looker_line
      fields: [sales_invoices.bill_to_site_use_id,
                sales_invoices.bill_to_customer_name,
                sales_invoices.invoice_count,
                sales_invoices__lines.average_percent_discount_when_taken_formatted,
                sales_invoices__lines.invoice_line_count,
                sales_invoices__lines.total_discount_amount_target_currency,
                sales_invoices__lines.discount_invoice_line_percent_formatted,
                sales_invoices__lines.average_unit_list_price_when_discount_target_currency,
                sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency]
      hidden_fields: [sales_invoices.bill_to_site_use_id,
                      sales_invoices.invoice_count,
                      sales_invoices__lines.invoice_line_count,
                      sales_invoices__lines.total_discount_amount_target_currency]
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
      show_x_axis_label: false
      x_axis_label_rotation: 0
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      legend_position: center
      point_style: circle
      show_value_labels: true
      show_null_points: false
      interpolation: step
      color_application:
        collection_id: legacy
        palette_id: looker_classic
        options:
          steps: 5
          reverse: false
      y_axes: [{label: 'Avg Unit Prices when Discount', orientation: left,
                series: [{axisId: sales_invoices__lines.average_unit_list_price_when_discount_target_currency,
                              id: sales_invoices__lines.average_unit_list_price_when_discount_target_currency,
                            name: Average Unit List Price when Discount},
                         {axisId: sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency,
                              id: sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency,
                            name: Average Unit Selling Price when Discount}],
                            showLabels: true, showValues: true, valueFormat: "#,###",},
                {label: 'Discount percentages', orientation: right,
                    series: [{axisId: sales_invoices__lines.average_percent_discount_when_taken_formatted,
                                  id: sales_invoices__lines.average_percent_discount_when_taken_formatted,
                                name: Average % Discount},
                            {axisId: sales_invoices__lines.discount_invoice_line_percent_formatted,
                                 id: sales_invoices__lines.discount_invoice_line_percent_formatted,
                               name: Frequency of Discounts}],
                  showLabels: true, showValues: true, minValue: 0, }]
      limit_displayed_rows: true
      limit_displayed_rows_values:
        show_hide: show
        first_last: first
        num_rows: '5'
      series_types:
        sales_invoices__lines.average_unit_list_price_when_discount_target_currency: column
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency: column
      series_labels:
        sales_invoices__lines.average_percent_discount_when_taken_formatted: "Average Discount %"
        sales_invoices__lines.discount_invoice_line_percent_formatted: "Discount Frequency (% of Invoice Lines)"
        sales_invoices__lines.average_unit_list_price_when_discount_target_currency: "Average Unit List Price"
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency: "Average Gross Unit Selling Price"
      series_colors:
        sales_invoices__lines.average_unit_list_price_when_discount_target_currency: "#76B5C5"
        sales_invoices__lines.average_gross_unit_selling_price_when_discount_target_currency: "#E28743"
        sales_invoices__lines.discount_invoice_line_percent_formatted: "#192D54"
        sales_invoices__lines.average_percent_discount_when_taken_formatted: "#873E23"
      series_point_styles:
        sales_invoices__lines.average_percent_discount_when_taken_formatted: triangle
      advanced_vis_config: |-
        {
          series: [
            {
              id: 'sales_invoices__lines.average_percent_discount_when_taken_formatted',
              tooltip: {
                headerFormat: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{point.key}</th>',
                pointFormat: '<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.1f}%</td></tr>',
                footerFormat: '</table>',
                shared: true,
              },
              dataLabels: {
                format: '{y:.1f}%',
                color: '#873E23',
                allowOverlap: false,
              },
            },
            {
              id: 'sales_invoices__lines.discount_invoice_line_percent_formatted',
              tooltip: {
                headerFormat: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{point.key}</th>',
                pointFormat: '<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.1f}%</td></tr>',
                footerFormat: '</table>',
                shared: true,
              },
              dataLabels: {
                format: '{y:.1f}%',
                color: '#192D54',
                allowOverlap: false,
              },
              type: 'line',
              dashStyle: "dash",
            },
            {
              id: 'sales_invoices__lines.average_unit_list_price_when_discount_target_currency',
              dataLabels: {
                enabled: false,
              },
              tooltip: {
                headerFormat: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{point.key}</th>',
                pointFormat: '<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f}</td></tr>',
                footerFormat: '</table>',
                shared: true,
              },
            },
            {
              id: 'sales_invoices__lines.average_unit_selling_price_when_discount_target_currency',
              dataLabels: {
                enabled: false,
              },
              tooltip: {
                headerFormat: '<table><th style="font-size: 1.8em;text-align: left;color: #808080;">{point.key}</th>',
                pointFormat: '<tr><th style="text-align: left;color:{point.color};">{series.name}:&nbsp;&nbsp;</th><td style="text-align: right;color:{point.color};" >{point.y:,.0f}</td></tr>',
                footerFormat: '</table>',
                shared: true,
              },
            },
          ],
          tooltip: {
            backgroundColor: '#FFFFFF',
            formatter: null,
            shared: true,
            crosshairs: true,
            shadow: true,
          },
        }
      note_state: collapsed
      note_display: hover
      note_text: |-
        <div style="text-align: left;">
        Customers are ranked in descending order by Total Discount Amount across non-Intercompany invoice lines.
        </br></br>Average Unit List Price and Average Unit Selling Price across invoice lines with a discount are shown as columns.
        </br></br>The Average Discount % taken as well as the Frequency of Discounts (as % of invoice lines) are also shown as lines.
        </br></br>Discounts are calculated by subtracting the Gross Unit Selling Price from the Unit List Price as both prices are inclusive of taxes.
        If the Gross Unit Selling Price is unavailable, the pre-tax price is used, possibly leading to inflated discounts.
        </div>
      listen:
        date: sales_invoices.invoice_date
        business_unit: sales_invoices.business_unit_name
        customer_country: sales_invoices.bill_to_customer_country
        customer_name: sales_invoices.bill_to_customer_name
        target_currency: otc_common_parameters_xvw.parameter_target_currency
        order_source: sales_invoices__lines.order_source_name
        item_category: sales_invoices__lines.category_description
      row: 16
      col: 0
      width: 24
      height: 7
