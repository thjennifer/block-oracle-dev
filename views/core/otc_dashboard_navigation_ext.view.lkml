include: "/views/base/navigation_template.view"

view: otc_dashboard_navigation_ext {
  extends: [navigation_template]

  dimension: dash_bindings {
    hidden: yes
    type: string
    # sql: 'otc_order_status|Order Status||otc_sales_performance|Sales Performance||otc_order_fulfillment|Order Fulfillment||otc_accounts_receivable|Accounts Receivable' ;;
    sql: 'otc_order_status|Order Status||otc_sales_performance|Sales Performance||otc_order_fulfillment|Order Fulfillment' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|Date||filter2|Business+Unit||filter3|Customer+Type||filter4|Country||filter5|Customer||filter6|Order+Source||filter7|Item+Category||filter8|Target+Currency' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  parameter: navigation_focus_page {
    hidden: no
    group_label: "Dashboard Navigation"
    # allowed_value: {value:"1"}
    # allowed_value: {value:"2"}
    ## additional allowed values beyond 2 tabs
    allowed_value: {value:"3"}
    allowed_value: {value:"4"}
  }

  parameter: navigation_style {
    group_label: "Dashboard Navigation"
  }

  filter: filter1 {
    hidden: yes
    type: date
    group_label: "Dashboard Navigation"
    label: "Date"
  }

  filter: filter2 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Business Unit"
  }

  filter: filter3 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Customer Type"
  }

  filter: filter4 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Country"
  }

  filter: filter5 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Customer"
  }

  filter: filter6 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Order Source"
  }

  filter: filter7 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Item Category"
  }

  filter: filter8 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "Target Currency"
  }





}
