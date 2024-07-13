include: "/views/core/otc_dashboard_navigation_ext.view"

view: +otc_dashboard_navigation_ext {


  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: {% assign subject = parameter_navigation_subject._parameter_value %}
          {% case subject %}
            {% when "orders" %}
            "otc_order_status_test|Order Status|1,2,3,4,5,6,7,8||otc_sales_performance_test|Sales Performance|1,2,3,4,5,6,7,8,9||otc_order_fulfillment_test|Order Fulfillment|1,2,3,4,5,6,7,8,9"
          {% when "billing" %}
            "otc_billing_test|Billing & Invoicing|1,2,3,4,5,6,7,8||otc_accounts_receivable_test|Accounts Receivable|1,2,3,4,5,6||otc_billing_invoice_details_test|Invoice Details|1,2,3,4,5,6,7,8"
          {% endcase %}
          ;;
  }


   }
