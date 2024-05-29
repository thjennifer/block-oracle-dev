include: "/views/base/navigation_template.view"

view: navigation_otc_ext {
  extends: [navigation_template]

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: 'otc_order_status|Order Status||otc_sales_performance|Sales Performance||otc_order_fulfillment|Order Fulfillment' ;;
  }

  dimension: filter_bindings {
    hidden: yes
    type: string
    sql: 'filter1|Order+Date||filter2|Business+Unit||filter3|Country||filter4|Customer||filter5|Order+Source||filter6|Item+Cagegory||filter7|Target+Currency||filter8|Test+or+Demo' ;;
    # sql: 'filter1|Order+Date||filter2|Country+Name' ;;
  }

  parameter: navigation_focus_page {
    hidden: no
    type: unquoted
    allowed_value: {value:"1"}
    allowed_value: {value:"2"}
    allowed_value: {value:"3"}
    # allowed_value: {value:"4"}
    # allowed_value: {value:"5"}
    default_value: "1"
  }

  filter: filter1 {
    hidden: yes
    type: date
    label: "Order Date"
  }

  filter: filter2 {
    hidden: yes
    type: string
    label: "Business Unit"
  }

  filter: filter3 {
    hidden: yes
    type: string
    label: "Country"
  }

  filter: filter4 {
    hidden: yes
    type: string
    label: "Customer"
  }

  filter: filter5 {
    hidden: yes
    type: string
    label: "Order Source"
  }

  filter: filter6 {
    hidden: yes
    type: string
    label: "Item Category"
  }

  filter: filter7 {
    hidden: yes
    type: string
    label: "Target Currency"
  }

  filter: filter8 {
    hidden: yes
    type: string
    label: "Test or Demo"
  }



}
