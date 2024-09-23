include: "/views/core/otc_dashboard_navigation_ext.view"

view: +otc_dashboard_navigation_ext {

  dimension: dash_bindings {
    hidden: yes
    type: string
    sql: {% assign subject = parameter_navigation_subject._parameter_value %}
          {% case subject %}
            {% when "orders" %}
            "150|Order Status|1,2,3,4,5,6,7,8||151|Sales Performance|1,2,3,4,5,6,7,8,9||152|Order Fulfillment|1,2,3,4,5,6,7,8,9"
          {% when "billing" %}
            "154|Billing & Invoicing|1,2,3,4,5,6,7,8||155|Accounts Receivable|1,2,3,4,5,6"
          {% when "odetails" %}
            "150|Order Status|1,2,3,4,5,6,7,8||151|Sales Performance|1,2,3,4,5,6,7,8,9||152|Order Fulfillment|1,2,3,4,5,6,7,8,9||153|Orders with Line Details|1,2,3,4,5,6,7,8,9"
           {% when "bdetails" %}
            "154|Billing & Invoicing|1,2,3,4,5,6,7,8||155|Accounts Receivable|1,2,3,4,5,6||156|Invoice Details|1,2,3,4,5,6,7,8,9"
          {% endcase %}
          ;;
    # sql: "otc_order_status|Order Status|1,2,3,4||otc_sales_performance|Sales Performance|1,2,3,4" ;;
    }

   }
