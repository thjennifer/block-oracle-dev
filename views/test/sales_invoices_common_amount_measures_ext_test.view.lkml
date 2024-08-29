include: "/views/core/sales_invoices_common_amount_measures_ext.view"

view: +sales_invoices_common_amount_measures_ext {
    extension: required




    measure: total_transaction_amount_target_currency_formatted {
      link: {
        label: "Invoice Line Details (TEST)"
        icon_url: "/favicon.ico"
        url: "
        @{link_build_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign use_qualified_filter_names = false %}
        {% assign source_to_destination_filters_mapping = '@{link_map_sales_invoices_to_invoice_details}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

        {% assign use_default_filters_to_override = false %}
        @{link_build_dashboard_url}
        "
      }
    }

    measure: total_discount_amount_target_currency_formatted {
     link: {
        label: "Invoice Line Details (TEST)"
        icon_url: "/favicon.ico"
        url: "
        @{link_build_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign use_qualified_filter_names = false %}
        {% assign source_to_destination_filters_mapping = '@{link_map_sales_invoices_to_invoice_details}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

        {% assign use_default_filters_to_override = false %}
        @{link_build_dashboard_url}
        "
      }
    }

    measure: total_tax_amount_target_currency_formatted {
      link: {
        label: "Invoice Line Details (TEST)"
        icon_url: "/favicon.ico"
        url: "
        @{link_build_variable_defaults}
        {% assign link = link_generator._link %}
        {% assign use_qualified_filter_names = false %}
        {% assign source_to_destination_filters_mapping = '@{link_map_sales_invoices_to_invoice_details}'%}

        {% assign model = _model._name %}
        {% assign target_dashboard = _model._name | append: '::otc_billing_invoice_line_details_test' %}

        {% assign use_default_filters_to_override = false %}
        @{link_build_dashboard_url}
        "
      }
    }


 }