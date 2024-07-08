include: "/views/base/navigation_template.view"
view: otc_dashboard_navigation_sales_ext {

  view_label: "@{view_label_for_filters}"

  extends: [navigation_template]

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: 'otc_order_status|Order Status||otc_sales_performance|Sales Performance||otc_order_fulfillment|Order Fulfillment' ;;
    # sql: 'otc_billing|Billing & Invoicing||otc_accounts_receivable|Accounts Receivable Overview||otc_billing_invoice_details|Invoice Details' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|date||filter2|business_unit||filter3|customer_type||filter4|customer_country||filter5|customer_name||filter6|target_currency||filter7|order_source||filter8|item_category||filter9|item_language' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  parameter: navigation_focus_page {
    hidden: no
    group_label: "Dashboard Navigation"
    ## additional allowed values beyond 2 tabs
    allowed_value: {value:"3"}
  }

  parameter: navigation_style {
    group_label: "Dashboard Navigation"
  }

  filter: filter1 {
    hidden: yes
    type: date
    group_label: "Dashboard Navigation"
    label: "date"
  }

  filter: filter2 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "business_unit"
  }

  filter: filter3 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "customer_type"
  }

  filter: filter4 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "customer_country"
  }

  filter: filter5 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "customer_name"
  }

  filter: filter6 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "target_currency"
  }

  filter: filter7 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "order_source"
  }

  filter: filter8 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "item_category"
  }

  filter: filter9 {
    hidden: yes
    type: string
    group_label: "Dashboard Navigation"
    label: "item_language"
  }

}
