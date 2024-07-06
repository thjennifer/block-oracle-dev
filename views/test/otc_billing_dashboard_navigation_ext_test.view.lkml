include: "/views/core/otc_billing_dashboard_navigation_ext.view"

view: +otc_billing_dashboard_navigation_ext {

  label: "@{view_label_for_filters}"

  dimension: dash_bindings {
    hidden: yes
    type: string
    # sql: 'otc_order_status|Order Status||otc_sales_performance|Sales Performance||otc_order_fulfillment|Order Fulfillment||otc_accounts_receivable|Accounts Receivable' ;;
    sql: 'otc_billing_test|Billing & Invoicing||otc_accounts_receivable_test|Accounts Receivable Overview||otc_billing_invoice_details_test|Invoice Details' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|date||filter2|business_unit||filter3|customer_type||filter4|customer_country||filter5|customer_name||filter6|target_currency||filter7|order_source||filter8|item_category||filter9|test_or_demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  filter: filter9 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "test_or_demo"
  }

}
