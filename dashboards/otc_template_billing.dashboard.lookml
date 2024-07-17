- dashboard: otc_template_billing
  title: OTC Template for Billing
  description: "Template which defines filters and elements used on billing-related dashboards. Extendable and customizable."

  extension: required
  extends: otc_template_core

  filters:
  - name: date
    title: Invoice Date

  - name: business_unit
    explore: sales_invoices_daily_agg
    field: sales_invoices_daily_agg.business_unit_name

  - name: customer_type
    ui_config:
      options:
        - bill
    explore: sales_orders_daily_agg
    field: sales_orders_daily_agg.parameter_customer_type

  - name: customer_country
    explore: sales_invoices_daily_agg
    field: sales_invoices_daily_agg.bill_to_customer_country
    listens_to_filters: [business_unit]

  - name: customer_name
    explore: sales_invoices_daily_agg
    field: sales_invoices_daily_agg.bill_to_customer_name
    listens_to_filters: [business_unit]

  elements:
  - name: dashboard_navigation
    explore: sales_invoices_daily_agg
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_subject: 'billing'
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      # customer_type: otc_dashboard_navigation_ext.filter3
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
