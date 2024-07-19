include: "/views/base/template_dashboard_navigation.view"

view: otc_dashboard_navigation_ext {
  extends: [template_dashboard_navigation]


  dimension: map_filter_numbers_to_dashboard_filter_names {
    sql: '1|date||2|business_unit||3|customer_type||4|customer_country||5|customer_name||6|target_currency||7|order_source||8|item_category||9|item_language' ;;
    # sql: "1|date||2|business_unit||3|customer_type||4|customer_country" ;;
  }

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: {% assign subject = parameter_navigation_subject._parameter_value %}
          {% case subject %}
            {% when "orders" %}
            "otc_order_status|Order Status|1,2,3,4,5,6,7,8||otc_order_sales_performance|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment|Order Fulfillment|1,2,3,4,5,6,7,8,9||otc_order_line_details|Orders with Line Details|1,2,3,4,5,6,7,8,9"
          {% when "billing" %}
            "otc_billing_and_invoicing|Billing & Invoicing|1,2,3,4,5,6,7,8||otc_billing_accounts_receivable|Accounts Receivable|1,2,3,4,5,6||otc_billing_invoice_details|Invoice Details|1,2,3,4,5,6,7,8,9"
          {% when "orders_with_line_details" %}
            "otc_order_status|Order Status|1,2,3,4,5,6,7,8||otc_order_sales_performance|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment|Order Fulfillment|1,2,3,4,5,6,7,8,9||otc_order_line_details|Orders with Line Details|1,2,3,4,5,6,7,8,9"
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
    hidden: yes
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

  parameter: parameter_navigation_subject {
    hidden: no
    type: unquoted
    label: "Navigation Subject Area"
    description: "Which set of dashboards to display? Select either orders, orders_with_line_details, or billing."
    allowed_value: {value: "orders" }
    allowed_value: {value: "billing" }
    allowed_value: {value: "orders_with_line_details" }
    default_value: "orders"
  }


}
