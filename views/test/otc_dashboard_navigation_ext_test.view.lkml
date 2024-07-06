include: "/views/core/otc_dashboard_navigation_ext.view"

view: +otc_dashboard_navigation_ext {

  label: "@{view_label_for_filters}"

  dimension: dash_bindings {
    hidden: yes
    type: string
    # sql: 'otc_order_status_test|Order Status||otc_sales_performance_test|Sales Performance||otc_order_fulfillment_test|Order Fulfillment||otc_accounts_receivable_test|Accounts Receivable' ;;
    sql: 'otc_order_status_test|Order Status||otc_sales_performance_test|Sales Performance||otc_order_fulfillment_test|Order Fulfillment' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|Date||filter2|Business+Unit||filter3|Customer+Type||filter4|Country||filter5|Customer||filter6|Order+Source||filter7|Item+Category||filter8|Target+Currency||filter9|Test+or+Demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  filter: filter9 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Test or Demo"
  }

  }
