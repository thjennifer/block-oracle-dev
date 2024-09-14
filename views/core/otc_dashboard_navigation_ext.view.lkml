#########################################################{
# PURPOSE
# Dynamically generates html links (including filters) to support navigation between
# related OTC Dashboards.
#
# SOURCE
# Extends View template_dashboard_navigation_ext
#
# REFERENCED BY
# Explores:
#   sales_orders
#   sales_orders_daily_agg
#   sales_invoices
#   sales_invoices_daily_agg
#   sales_payments
#   sales_payments_daily_agg
#
# CUSTOMIZATIONS {
# While the template_dashboard_navigation_ext provides much of the logic needed, customizations
# are required.
#   1. Added a new parameter called parameter_navigation_subject to support
#      multiple dashboard groupings for OTC:
#         Orders, Billing, Orders with Line Details and Billing with Line Details
#
#   2. Updated dimension map_filter_numbers_to_dashboard_filter_names with:
#       - filter number-to-dashboard filter values as follows:
#           1   date
#           2   business_unit
#           3   customer_type
#           4   customer_country
#           5   customer_name
#           6   target_currency
#           7   order_source
#           8   item_category
#           9   item_language
#       - example syntax:
#             sql: "1|date||2|business_unit||3|customer_type||4|customer_country" ;;
#
#   3. Updated dash_bindings dimension to:
#       - use parameter_navigation_subject value to specify 4 sets of dashboards:
#       subject               dashboard set
#       ---------------       ---------------
#       Orders                Order Status, Sales Performance, Order Fulfillment
#       Orders with Details   Order Status, Sales Performance, Order Fulfillment, Orders with Line Details
#       Billing               Billing & Invoicing, Accounts Receivable
#       Billing with Details  Billing & Invoicing, Accounts Receivable, Invoice Details
#
#       - and for each dashboard list the filters used on the dashboard that should be passed between dashboards in the set:
#       dashboard name                    link text               filters used
#       ---------------                   --------------------    ----------
#       otc_order_status                  Order Status              1,2,3,4,5,6,7,8
#       otc_order_sales_performance       Sales Performance         1,2,3,4,5,6,7,8,9
#       otc_order_fulfillment             Order Fulfillment         1,2,3,4,5,6,7,8,9
#       otc_order_line_item_details       Orders with Line Details  1,2,3,4,5,6,7,8,9
#       otc_billing_and_invoicing         Billing & Invoicing       1,2,3,4,5,6,7,8
#       otc_billing_accounts_receivable   Accounts Receivable       1,2,3,4,5,6
#       otc_billing_invoice_line_details  Invoice Details           1,2,3,4,5,6,7,8,9
#
#       - example syntax:
#           "otc_order_status|Order Status|1,2,3,4,5,6,7,8||otc_order_sales_performance|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment|Order Fulfillment|1,2,3,4,5,6,7,8,9"
#
#   4. Updated dimension parameter_navigation_focus_page to allow values 3 and 4
#
#   5. Updated hidden and label properties of filter1 to filter9. Also updated filter1 to use "type: date".
#
#   6. Added view_label = "@{label_view_for_dashboard_navigation}" for how these fields appear in the Explore.
#
#   7. Added derived_table sql: property to allow this view to also be a standalone Explore.
#}
#
# HOW TO USE FOR NAVIGATION {
#   1. Add to an Explore using a bare join (important if adding to a dashboard where you plan to use cross-filtering)
#         explore: sales_orders {
#         join: otc_dashboard_navigation_ext {
#           relationship: one_to_one
#           sql:  ;;
#           }}
#      Or Open the Explore OTC Dashboard Navigation (if planning to add to a dashboard where cross-filtering is disabled).
#
#   2. Open the Explore and add "Dashboard Links" dimension to a Single Value Visualization.
#
#   3. Add these navigation parameters to visualization and set to desired values:
#         Navigation Style = Buttons (or if using LookML, buttons)
#         Navigation Focus Page = 1 (if adding to first dashboard listed, set to 2 if added viz to second dashboard)
#         Navigation Subject Area = Orders (or if using LookML, orders)
#
#   4. Add navigation filters to the visualization. These filters will "listen" to the dashboard filters.
#
#   5. Add Visualization to dashboard and edit dashboard to pass the dashboard filters
#    to Filters 1 to N accordingly.
#
#    Alternatively, you can edit the dashboard LookML and the "listen" property as shown in
#    the LookML example below:
#       - name: navigation
#         explore: sales_orders
#         type: single_value
#         fields: [otc_dashboard_navigation_ext.navigation_links]
#         filters:
#           otc_dashboard_navigation_ext.parameter_navigation_focus_page: '1'
#           otc_dashboard_navigation_ext.parameter_navigation_style: 'buttons'
#         show_single_value_title: false
#         show_comparison: false
#         listen:
#           date: otc_dashboard_navigation_ext.filter1
#           business_unit: otc_dashboard_navigation_ext.filter2
#           customer_type: otc_dashboard_navigation_ext.filter3
#           customer_country: otc_dashboard_navigation_ext.filter4
#           customer_name: otc_dashboard_navigation_ext.filter5
#           target_currency: otc_dashboard_navigation_ext.filter6
#}
#########################################################}

include: "/views/core/template_dashboard_navigation_ext.view"

view: otc_dashboard_navigation_ext {
  extends: [template_dashboard_navigation_ext]

  view_label: "@{label_view_for_dashboard_navigation}"

#--> Added a simple derived table syntax to allow a standalone Explore
#--> But to ensure that cross-filtering on a dashboard can be enabled, use bare join to include this view in the single Explore used for the dashboard.
  derived_table: {
    sql: SELECT 1 AS dummy_field ;;
  }

#--> Added new paramter for subject area that allows multiple dashboard sets to be defined.
  parameter: parameter_navigation_subject {
    hidden: no
    type: unquoted
    label: "Navigation Subject Area"
    description: "Which set of dashboards to display? Select either Orders, Orders with Line Details, Billing or Billing with Line Details."
    allowed_value: {value: "orders" label: "Orders" }
    allowed_value: {value: "billing" label: "Billing"}
    allowed_value: {value: "odetails" label: "Orders with Line Details"}
    allowed_value: {value: "bdetails" label: "Billing with Line Details"}
    default_value: "orders"
  }

  dimension: map_filter_numbers_to_dashboard_filter_names {
    sql: '1|date||2|business_unit||3|customer_type||4|customer_country||5|customer_name||6|target_currency||7|order_source||8|item_category||9|item_language' ;;
    # sql: "1|date||2|business_unit||3|customer_type||4|customer_country" ;;
  }

#--> Added logic to define dashboard set based on the subject area selected with parameter_navigation_subject
  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: {% assign subject = parameter_navigation_subject._parameter_value %}
          {% case subject %}
            {% when "orders" %}
            "otc_order_status|Order Status|1,2,3,4,5,6,7,8||otc_order_sales_performance|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment|Order Fulfillment|1,2,3,4,5,6,7,8,9"
          {% when "billing" %}
            "otc_billing_and_invoicing|Billing & Invoicing|1,2,3,4,5,6,7,8||otc_billing_accounts_receivable|Accounts Receivable|1,2,3,4,5,6"
          {% when "odetails" %}
            "otc_order_status|Order Status|1,2,3,4,5,6,7,8||otc_order_sales_performance|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment|Order Fulfillment|1,2,3,4,5,6,7,8,9||otc_order_line_details|Orders with Line Details|1,2,3,4,5,6,7,8,9"
           {% when "bdetails" %}
            "otc_billing_and_invoicing|Billing & Invoicing|1,2,3,4,5,6,7,8||otc_billing_accounts_receivable|Accounts Receivable|1,2,3,4,5,6||otc_billing_invoice_line_details|Invoice Details|1,2,3,4,5,6,7,8,9"
          {% endcase %}
          ;;
    # sql: "otc_order_status|Order Status|1,2,3,4||otc_sales_performance|Sales Performance|1,2,3,4" ;;
  }

  parameter: parameter_navigation_focus_page {
    allowed_value: {value: "3"}
    allowed_value: {value: "4"}
  }

  filter: filter1 {
    type: date
    hidden: no
    label: "date"
  }
  filter: filter2 { hidden: no label: "business_unit"}
  filter: filter3 { hidden: no label: "customer type"}
  filter: filter4 { hidden: no label: "customer_country"}
  filter: filter5 { hidden: no label: "customer_name"}
  filter: filter6 { hidden: no label: "target_currency"}
  filter: filter7 { hidden: no label: "order_source"}
  filter: filter8 { hidden: no label: "item_category"}
  filter: filter9 { hidden: no label: "item_language"}




}
