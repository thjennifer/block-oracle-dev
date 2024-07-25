include: "/views/core/sales_invoices_common_amount_measures_ext.view"

view: +sales_invoices_common_amount_measures_ext {
    extension: required




    measure: total_transaction_amount_target_currency_formatted {
      link: {
        label: "Invoice Line Details (TEST)"
        icon_url: "/favicon.ico"
        url: "
        @{link_generate_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign qualify_filter_names = false %}
        {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details_test' %}

        {% assign default_filters_override = false %}
        @{link_generate_dashboard_url}
        "
      }
    }

    measure: total_discount_amount_target_currency_formatted {
     link: {
        label: "Invoice Line Details (TEST)"
        icon_url: "/favicon.ico"
        url: "
        @{link_generate_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign qualify_filter_names = false %}
        {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details_test' %}

        {% assign default_filters_override = false %}
        @{link_generate_dashboard_url}
        "
      }
    }

    measure: total_tax_amount_target_currency_formatted {
      link: {
        label: "Invoice Line Details (TEST)"
        icon_url: "/favicon.ico"
        url: "
        @{link_generate_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign qualify_filter_names = false %}
        {% assign filters_mapping = '@{link_sales_invoices_to_target_dashboard}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_details_test' %}

        {% assign default_filters_override = false %}
        @{link_generate_dashboard_url}
        "
      }
    }


 }