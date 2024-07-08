include: "/views/core/otc_dashboard_navigation_sales_ext.view"

view: +otc_dashboard_navigation_sales_ext {

  label: "@{view_label_for_filters}"

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: 'otc2_order_status_test|Order Status||otc2_sales_performance_test|Sales Performance||otc2_order_fulfillment_test|Order Fulfillment' ;;
    # sql: 'otc_billing_test|Billing & Invoicing||otc_accounts_receivable_test|Accounts Receivable Overview||otc_billing_invoice_details_test|Invoice Details' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|date||filter2|business_unit||filter3|customer_type||filter4|customer_country||filter5|customer_name||filter6|target_currency||filter7|order_source||filter8|item_category||filter9|item_language||filter10|test_or_demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  filter: filter10 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "test_or_demo"
  }

}
