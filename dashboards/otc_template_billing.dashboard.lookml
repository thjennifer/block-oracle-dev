#########################################################{
# OTC Template for Billing defines or modifies the
# objects shared across billings-related dashboards.
#
#  - Modified from otc_template_core:
#       date to use title Invoice Date
#       business_unit to change source explore/field
#       customer_type to limit to single option of bill
#       customer_country to change source explore/field
#       customer_name to change source explore/field
#       dashboard_navigation to remove listener for customer_type (will be bill for all billing-related dashboards)
#
# This template must be EXTENDED into other dashboards and
# filters/elements can be modified further as necessary
#########################################################}

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
    explore: otc_dashboard_navigation_ext
    filters:
      otc_dashboard_navigation_ext.parameter_navigation_subject: 'billing'
    listen:
      date: otc_dashboard_navigation_ext.filter1
      business_unit: otc_dashboard_navigation_ext.filter2
      # customer_type: otc_dashboard_navigation_ext.filter3
      customer_country: otc_dashboard_navigation_ext.filter4
      customer_name: otc_dashboard_navigation_ext.filter5
      target_currency: otc_dashboard_navigation_ext.filter6
