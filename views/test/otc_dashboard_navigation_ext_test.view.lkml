include: "/views/core/otc_dashboard_navigation_ext.view"

view: +otc_dashboard_navigation_ext {

  dimension: dash_bindings {
    hidden: yes
    type: string
    # sql: 'otc_order_status_test|Order Status||otc_sales_performance_test|Sales Performance||otc_order_fulfillment_test|Order Fulfillment||otc_accounts_receivable_test|Accounts Receivable' ;;
    sql: 'otc_order_status_test|Order Status||otc_sales_performance_test|Sales Performance||otc_order_fulfillment_test|Order Fulfillment' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|Date||filter2|Business+Unit||filter3|Country||filter4|Customer||filter5|Order+Source||filter6|Item+Cagegory||filter7|Target+Currency||filter8|Test+or+Demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  filter: filter8 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Test or Demo"
  }

  }
