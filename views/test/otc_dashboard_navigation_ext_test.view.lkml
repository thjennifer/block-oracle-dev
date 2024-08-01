include: "/views/core/otc_dashboard_navigation_ext.view"

view: +otc_dashboard_navigation_ext {


  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: {% assign subject = parameter_navigation_subject._parameter_value %}
          {% case subject %}
            {% when "orders" %}
            "otc_order_status_test|Order Status|1,2,3,4,5,6,7,8,10||otc_order_sales_performance_test|Sales Performance|1,2,3,4,5,6,7,8,9,10||otc_order_fulfillment_test|Order Fulfillment|1,2,3,4,5,6,7,8,9,10"
          {% when "billing" %}
            "otc_billing_and_invoicing_test|Billing & Invoicing|1,2,3,4,5,6,7,8,10||otc_billing_accounts_receivable_test|Accounts Receivable|1,2,3,4,5,6,10||otc_billing_invoice_line_details_test|Invoice Details|1,2,3,4,5,6,7,8,10"
          {% endcase %}
          ;;
  }

  dimension: map_filter_numbers_to_dashboard_filter_names {
    sql: '1|date||2|business_unit||3|customer_type||4|customer_country||5|customer_name||6|target_currency||7|order_source||8|item_category||9|item_language||10|test_or_demo' ;;
  }

  # dimension: filter10 {
  #   hidden: no
  #   label: "test_or_demo"
  # }


   }